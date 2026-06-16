import 'package:platform_core_frontend/features/dashboard/data/dashboard_api.dart';
import 'package:platform_core_frontend/features/dashboard/data/models/dashboard_response.dart';

class DashboardRepository {
  DashboardRepository({DashboardApi? dashboardApi})
      : _dashboardApi = dashboardApi ?? DashboardApi();

  final DashboardApi _dashboardApi;

  Future<DashboardResponse> getMyMasjidDashboard() {
    return _dashboardApi.getMyMasjidDashboard();
  }
}
