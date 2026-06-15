import 'package:platform_core_frontend/features/announcements/data/announcements_api.dart';
import 'package:platform_core_frontend/features/announcements/data/models/announcement_model.dart';
import 'package:platform_core_frontend/features/announcements/data/models/create_announcement_request.dart';
import 'package:platform_core_frontend/features/announcements/data/models/update_announcement_request.dart';

class AnnouncementsRepository {
  AnnouncementsRepository({AnnouncementsApi? announcementsApi})
      : _announcementsApi = announcementsApi ?? AnnouncementsApi();

  final AnnouncementsApi _announcementsApi;

  Future<List<AnnouncementModel>> getAnnouncements() {
    return _announcementsApi.getAnnouncements();
  }

  Future<AnnouncementModel> createAnnouncement(
    CreateAnnouncementRequest request,
  ) {
    return _announcementsApi.createAnnouncement(request);
  }

  Future<AnnouncementModel> updateAnnouncement(
    String id,
    UpdateAnnouncementRequest request,
  ) {
    return _announcementsApi.updateAnnouncement(id, request);
  }

  Future<void> deleteAnnouncement(String id) {
    return _announcementsApi.deleteAnnouncement(id);
  }
}
