import 'package:platform_core_frontend/features/imam_salary/data/imam_salary_api.dart';
import 'package:platform_core_frontend/features/imam_salary/models/create_imam_salary_request.dart';
import 'package:platform_core_frontend/features/imam_salary/models/imam_salary_model.dart';
import 'package:platform_core_frontend/features/imam_salary/models/update_imam_salary_request.dart';

class ImamSalaryRepository {
  ImamSalaryRepository({ImamSalaryApi? imamSalaryApi})
      : _imamSalaryApi = imamSalaryApi ?? ImamSalaryApi();

  final ImamSalaryApi _imamSalaryApi;

  Future<List<ImamSalaryModel>> getImamSalaries() {
    return _imamSalaryApi.getImamSalaries();
  }

  Future<ImamSalaryModel> getImamSalaryById(String id) {
    return _imamSalaryApi.getImamSalaryById(id);
  }

  Future<ImamSalaryModel> createImamSalary(
    CreateImamSalaryRequest request,
  ) {
    return _imamSalaryApi.createImamSalary(request);
  }

  Future<ImamSalaryModel> updateImamSalary(
    String id,
    UpdateImamSalaryRequest request,
  ) {
    return _imamSalaryApi.updateImamSalary(id, request);
  }

  Future<void> deleteImamSalary(String id) {
    return _imamSalaryApi.deleteImamSalary(id);
  }
}
