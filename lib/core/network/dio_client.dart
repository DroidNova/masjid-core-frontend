import 'package:dio/dio.dart';
import 'package:platform_core_frontend/core/config/app_config.dart';
import 'package:platform_core_frontend/core/errors/app_exception.dart';
import 'package:platform_core_frontend/core/network/api_result.dart';
import 'package:platform_core_frontend/core/storage/token_storage.dart';
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
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<ApiResult<T>> get<T>(
    String path, {
    JsonMap? queryParameters,
    T Function(dynamic json)? parser,
  }) {
    return _request<T>(
      () => _dio.get<dynamic>(path, queryParameters: queryParameters),
      parser,
    );
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    T Function(dynamic json)? parser,
  }) {
    return _request<T>(
      () => _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
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
      return const ApiFailure<T>(UnknownException());
    }
  }

  AppException _mapDioException(DioException exception) {
    final statusCode = exception.response?.statusCode;

    if (statusCode == 401) {
      return const UnauthorizedException();
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerException(
        message: 'Server error',
        code: statusCode,
      );
    }

    if (exception.type == DioExceptionType.connectionError ||
        exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout) {
      return const NetworkException();
    }

    return UnknownException(exception.message ?? 'Request failed');
  }
}
