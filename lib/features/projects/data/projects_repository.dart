import 'package:platform_core_frontend/features/projects/data/models/create_project_request.dart';
import 'package:platform_core_frontend/features/projects/data/models/project_model.dart';
import 'package:platform_core_frontend/features/projects/data/models/update_project_request.dart';
import 'package:platform_core_frontend/features/projects/data/projects_api.dart';

class ProjectsRepository {
  ProjectsRepository({ProjectsApi? projectsApi})
      : _projectsApi = projectsApi ?? ProjectsApi();

  final ProjectsApi _projectsApi;

  Future<List<ProjectModel>> getProjects() => _projectsApi.getProjects();

  Future<ProjectModel> getProjectById(String id) {
    return _projectsApi.getProjectById(id);
  }

  Future<ProjectModel> createProject(CreateProjectRequest request) {
    return _projectsApi.createProject(request);
  }

  Future<ProjectModel> updateProject(String id, UpdateProjectRequest request) {
    return _projectsApi.updateProject(id, request);
  }

  Future<void> deleteProject(String id) => _projectsApi.deleteProject(id);
}
