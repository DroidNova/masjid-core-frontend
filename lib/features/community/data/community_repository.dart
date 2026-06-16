import 'package:platform_core_frontend/features/community/data/community_api.dart';
import 'package:platform_core_frontend/features/community/data/models/community_user_model.dart';
import 'package:platform_core_frontend/features/community/data/models/masjid_detail_model.dart';

class CommunityRepository {
  CommunityRepository({CommunityApi? communityApi})
      : _communityApi = communityApi ?? CommunityApi();

  final CommunityApi _communityApi;

  Future<MasjidDetailModel> getMyMasjid() => _communityApi.getMyMasjid();

  Future<List<CommunityUserModel>> getMyMasjidUsers() {
    return _communityApi.getMyMasjidUsers();
  }
}
