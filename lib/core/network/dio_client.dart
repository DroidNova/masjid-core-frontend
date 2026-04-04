import 'package:dio/dio.dart';
import 'package:platform_core_frontend/core/config/app_config.dart';
import 'package:platform_core_frontend/core/constants/api_endpoints.dart';
import 'package:platform_core_frontend/core/errors/app_exception.dart';
import 'package:platform_core_frontend/core/network/api_result.dart';
import 'package:platform_core_frontend/core/network/interceptors/auth_interceptor.dart';
import 'package:platform_core_frontend/core/storage/token_storage.dart';
import 'package:platform_core_frontend/features/auth/data/models/auth_tokens_model.dart';
import 'package:platform_core_frontend/shared/types/json_types.dart';

class DioClient {
  DioClient({required AppConfig config, required TokenStorage tokenStorage})
      : _tokenStorage = tokenStorage,
        _dio = Dio(
          BaseOptions(
            baseUrl: config.apiBaseUrl,
            connectTimeout: config.requestTimeout,
            receiveTimeout: config.requestTimeout,
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ),
        _refreshDio = Dio(
          BaseOptions(
            baseUrl: config.apiBaseUrl,
            connectTimeout: config.requestTimeout,
            receiveTimeout: config.requestTimeout,
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      AuthInterceptor(
        dio: _dio,
        tokenStorage: _tokenStorage,
        refreshTokens: _refreshTokens,
        clearSession: _tokenStorage.clearTokens,
      ),
    );
  }

  final Dio _dio;
  final Dio _refreshDio;
  final TokenStorage _tokenStorage;

  Future<ApiResult<T>> get<T>(
    String path, {
    JsonMap? queryParameters,
    T Function(dynamic json)? parser,
    bool requiresAuth = true,
  }) {
    return _request<T>(
      () => _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      ),
      parser,
    );
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    T Function(dynamic json)? parser,
    bool requiresAuth = true,
  }) {
    return _request<T>(
      () => _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      ),
      parser,
    );
  }

  Future<ApiResult<T>> patch<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    T Function(dynamic json)? parser,
    bool requiresAuth = true,
  }) {
    return _request<T>(
      () => _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      ),
      parser,
    );
  }

  Future<ApiResult<T>> _request<T>(
    Future<Response<dynamic>> Function() call,
    T Function(dynamic json)? parser,
  ) async {
    try {
      final response = await call();
      final payload = response.data;

      if (parser != null) {
        return ApiSuccess<T>(parser(payload));
      }

      return ApiSuccess<T>(payload as T);
    } on DioException catch (error) {
      return ApiFailure<T>(_mapDioException(error));
    } catch (_) {
      return ApiFailure<T>(const UnknownException());
    }
  }

  Future<bool> _refreshTokens() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await _refreshDio.post<dynamic>(
        ApiEndpoints.authRefresh,
        data: {'refreshToken': refreshToken},
      );
      final tokens = AuthTokensModel.fromResponse(response.data);
      if (tokens.accessToken.isEmpty || tokens.refreshToken.isEmpty) {
        return false;
      }

      await _tokenStorage.saveAccessToken(tokens.accessToken);
      await _tokenStorage.saveRefreshToken(tokens.refreshToken);
      return true;
    } catch (_) {
      return false;
    }
  }

  AppException _mapDioException(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final apiMessage = _extractApiErrorMessage(exception);

    if (statusCode == 401) {
      return UnauthorizedException(apiMessage ?? 'Unauthorized request');
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerException(
        message: apiMessage ?? 'Server error',
        code: statusCode,
      );
    }

    if (exception.type == DioExceptionType.connectionError ||
        exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout) {
      return const NetworkException();
    }

    if (statusCode != null && statusCode >= 400) {
      return UnknownException(apiMessage ?? 'Request failed');
    }

    return UnknownException(exception.message ?? 'Request failed');
  }

  String? _extractApiErrorMessage(DioException exception) {
    final data = exception.response?.data;
    if (data is! JsonMap) {
      return null;
    }

    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    if (message is List && message.isNotEmpty) {
      final first = message.first;
      if (first is String && first.trim().isNotEmpty) {
        return first.trim();
      }
    }

    return null;
  }
}
