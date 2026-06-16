import 'package:platform_core_frontend/features/super_admin/data/super_admin_api.dart';
import 'package:platform_core_frontend/features/super_admin/models/admin_dashboard_summary.dart';
import 'package:platform_core_frontend/features/super_admin/models/admin_masjid_model.dart';
import 'package:platform_core_frontend/features/super_admin/models/admin_masjid_request_model.dart';
import 'package:platform_core_frontend/features/super_admin/models/admin_user_detail_model.dart';
import 'package:platform_core_frontend/features/super_admin/models/admin_user_model.dart';

class AdminPage<T>{ const AdminPage(this.items,this.total); final List<T> items; final int total; }
class SuperAdminRepository { SuperAdminRepository({SuperAdminApi? api}):_api=api??SuperAdminApi(); final SuperAdminApi _api;
Future<AdminPage<AdminUserModel>> getUsers({String? search,String? status,String? role}) async { final r=await _api.getUsers(search: search,status: status,role: role); return AdminPage(r.items.map(AdminUserModel.fromJson).toList(), r.total); }
Future<AdminUserDetailModel> getUser(String id) async => AdminUserDetailModel.fromJson(await _api.getUser(id));
Future<void> updateUserStatus(String id,String status)=>_api.updateUserStatus(id, {'status':status});
Future<void> updateUserRoles(String id,List<String> roles)=>_api.updateUserRoles(id, {'roles':roles});
Future<AdminPage<AdminMasjidRequestModel>> getMasjidRequests({String? search,String? status}) async { final r=await _api.getMasjidRequests(search: search,status: status); return AdminPage(r.items.map(AdminMasjidRequestModel.fromJson).toList(), r.total); }
Future<AdminMasjidRequestModel> getMasjidRequest(String id) async => AdminMasjidRequestModel.fromJson(await _api.getMasjidRequest(id));
Future<void> updateMasjidRequestStatus(String id,String status,{String? reason})=>_api.updateMasjidRequestStatus(id, {'status':status, if(reason!=null)'reason':reason, if(reason!=null)'rejectionReason':reason});
Future<AdminPage<AdminMasjidModel>> getMasjids({String? search,String? status}) async { final r=await _api.getMasjids(search: search,status: status); return AdminPage(r.items.map(AdminMasjidModel.fromJson).toList(), r.total); }
Future<AdminMasjidModel> getMasjid(String id) async => AdminMasjidModel.fromJson(await _api.getMasjid(id));
Future<void> updateMasjidStatus(String id,String status,{String? reason})=>_api.updateMasjidStatus(id, {'status':status, if(reason!=null)'reason':reason});
Future<AdminDashboardSummary> getDashboardSummary() async { final users=await getUsers(); final masjids=await getMasjids(); final pending=await getMasjidRequests(status:'PENDING'); final approved=await getMasjidRequests(status:'APPROVED'); final rejected=await getMasjidRequests(status:'REJECTED'); int c(String s)=>users.items.where((u)=>u.status?.toUpperCase()==s).length; return AdminDashboardSummary(totalUsers: users.total, activeUsers: c('ACTIVE'), inactiveUsers: c('INACTIVE'), suspendedUsers: c('SUSPENDED'), totalMasjids: masjids.total, pendingRequests: pending.total, approvedRequests: approved.total, rejectedRequests: rejected.total); }
}
