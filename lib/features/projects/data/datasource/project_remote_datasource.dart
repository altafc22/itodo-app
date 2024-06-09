import 'dart:convert';

import 'package:itodo/common/extensions/app_extension.dart';
import 'package:itodo/common/utils/log_utils.dart';
import 'package:itodo/features/projects/data/model/project_model.dart';
import 'package:itodo/features/projects/domain/usecase/update_project.dart';

import '../../../../common/errors/error_response.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/network/api_client.dart';
import '../../../../common/network/api_config.dart';

abstract interface class ProjectRemoteDataSource {
  Future<ProjectModel> add(String name);
  Future<ProjectModel> update(UpdateProjectParams param);
  Future<List<ProjectModel>> getAll();
  Future<ProjectModel> get(String id);
  Future<String> delete(String id);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ApiClient api;
  ProjectRemoteDataSourceImpl(this.api);

  @override
  Future<ProjectModel> add(String name) async {
    try {
      var response = await api.post(
        endpoint: ApiConfig.projects,
        body: {"name": name},
      );
      printInfo(response.body);
      if (response.statusCode.success) {
        return ProjectModel.fromJson(jsonDecode(response.body));
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.error ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ProjectModel> update(UpdateProjectParams param) async {
    try {
      var response = await api.post(
        endpoint: "${ApiConfig.projects}/${param.id}",
        body: param.toJson(),
      );
      printInfo(response.body);
      if (response.statusCode.success) {
        return ProjectModel.fromJson(jsonDecode(response.body));
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.error ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ProjectModel> get(String id) async {
    try {
      var response = await api.get(
        endpoint: "${ApiConfig.projects}/$id",
      );

      if (response.statusCode.success) {
        var data = jsonDecode(response.body);
        return ProjectModel.fromJson(data);
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.error ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<ProjectModel>> getAll() async {
    try {
      var response = await api.get(endpoint: "${ApiConfig.projects}/");

      if (response.statusCode.success) {
        var projects = (jsonDecode(response.body) as List)
            .map((data) => ProjectModel.fromJson(data))
            .toList();
        return projects;
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.error ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> delete(String id) async {
    try {
      var response = await api.delete(
        endpoint: "${ApiConfig.projects}/$id",
      );

      if (response.statusCode.success) {
        return 'Task deleted sucessfully';
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.error ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }
}
