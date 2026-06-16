import 'package:dio/dio.dart';
import 'package:platform_core_frontend/core/network/api_client.dart';

class AdminListResult { const AdminListResult(this.items,this.total); final List<Map<String,dynamic>> items; final int total; }

class SuperAdminApi {
  SuperAdminApi({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  final ApiClient _apiClient;

  Future<AdminListResult> getUsers({String? search,String? status,String? role,int page=1,int limit=20}) => _getList('/admin/users', {'search':search,'status':status,'role':role,'page':page,'limit':limit});
  Future<Map<String,dynamic>> getUser(String id) => _getMap('/admin/users/$id');
  Future<Map<String,dynamic>> updateUserStatus(String id, Map<String,dynamic> data) => _patchMap('/admin/users/$id/status', data);
  Future<Map<String,dynamic>> updateUserRoles(String id, Map<String,dynamic> data) => _postMap('/admin/users/$id/roles', data);
  Future<AdminListResult> getMasjidRequests({String? search,String? status,int page=1,int limit=20}) => _getList('/masjid-requests', {'search':search,'status':status,'page':page,'limit':limit});
  Future<Map<String,dynamic>> getMasjidRequest(String id) async { final list = await _getList('/masjid-requests', {'id':id,'limit':1}); return list.items.isNotEmpty ? list.items.first : <String,dynamic>{}; }
  Future<Map<String,dynamic>> updateMasjidRequestStatus(String id, Map<String,dynamic> data) => _patchMap('/masjid-requests/$id/status', data);
  Future<AdminListResult> getMasjids({String? search,String? status,int page=1,int limit=20}) => _getList('/masjids', {'search':search,'status':status,'page':page,'limit':limit});
  Future<Map<String,dynamic>> getMasjid(String id) => _getMap('/masjids/$id');
  Future<Map<String,dynamic>> updateMasjidStatus(String id, Map<String,dynamic> data) => _patchMap('/masjids/$id/status', data);

  Future<AdminListResult> _getList(String path, Map<String,dynamic> query) async { try { final r=await _apiClient.dio.get<Object?>(path,queryParameters: query..removeWhere((k,v)=>v==null||v=='')); final d=_unwrap(r.data); final total=_total(d); final raw=d is Map<String,dynamic> ? d['items'] : d; final items=raw is List ? raw.whereType<Map<String,dynamic>>().toList() : <Map<String,dynamic>>[]; return AdminListResult(items,total==0?items.length:total); } on DioException catch(e){ throw Exception(_message(e)); }}
  Future<Map<String,dynamic>> _getMap(String path) async { try { final r=await _apiClient.dio.get<Object?>(path); final d=_unwrap(r.data); return d is Map<String,dynamic> ? d : <String,dynamic>{}; } on DioException catch(e){ throw Exception(_message(e)); }}
  Future<Map<String,dynamic>> _patchMap(String path, Object data) async { try { final r=await _apiClient.dio.patch<Object?>(path,data:data); final d=_unwrap(r.data); return d is Map<String,dynamic> ? d : <String,dynamic>{}; } on DioException catch(e){ throw Exception(_message(e)); }}
  Future<Map<String,dynamic>> _postMap(String path, Object data) async { try { final r=await _apiClient.dio.post<Object?>(path,data:data); final d=_unwrap(r.data); return d is Map<String,dynamic> ? d : <String,dynamic>{}; } on DioException catch(e){ throw Exception(_message(e)); }}
  Object? _unwrap(Object? r)=> r is Map<String,dynamic> && r.containsKey('data') ? r['data'] : r;
  int _total(Object? d){ if(d is Map<String,dynamic>){ final t=d['total']??d['count']; if(t is int)return t; return int.tryParse(t?.toString()??'')??0;} return 0; }
  String _message(DioException e){ final d=e.response?.data; if(d is Map<String,dynamic>){ final m=d['message']; if(m is String)return m; } if(e.response?.statusCode==403)return 'You are not allowed to perform this action.'; if(e.response?.statusCode==401)return 'Session expired. Please login again.'; if(e.response?.statusCode==404)return 'This API is not available yet.'; return e.message??'Something went wrong.'; }
}
