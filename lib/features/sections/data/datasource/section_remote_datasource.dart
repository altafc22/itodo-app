import 'dart:convert';

import 'package:itodo/common/extensions/app_extension.dart';
import 'package:itodo/common/utils/log_utils.dart';

import '../../../../common/errors/error_response.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/network/api_client.dart';
import '../../../../common/network/api_config.dart';
import '../../domain/usecase/update_section.dart';
import '../model/section_model.dart';

abstract interface class SectionRemoteDataSource {
  Future<SectionModel> add(String name);
  Future<SectionModel> update(UpdateSectionParams param);
  Future<List<SectionModel>> getAll();
  Future<SectionModel> get(String id);
  Future<String> delete(String id);
}

class SectionRemoteDataSourceImpl implements SectionRemoteDataSource {
  final ApiClient api;
  SectionRemoteDataSourceImpl(this.api);

  @override
  Future<SectionModel> add(String name) async {
    try {
      var response = await api.post(
        endpoint: ApiConfig.sections,
        body: {"name": name},
      );
      printInfo(response.body);
      if (response.statusCode.success) {
        return SectionModel.fromJson(jsonDecode(response.body));
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
  Future<SectionModel> update(UpdateSectionParams param) async {
    try {
      var response = await api.post(
        endpoint: "${ApiConfig.sections}/${param.id}",
        body: param.toJson(),
      );
      printInfo(response.body);
      if (response.statusCode.success) {
        return SectionModel.fromJson(jsonDecode(response.body));
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
  Future<SectionModel> get(String id) async {
    try {
      var response = await api.get(
        endpoint: "${ApiConfig.sections}/$id",
      );

      if (response.statusCode.success) {
        var data = jsonDecode(response.body);
        return SectionModel.fromJson(data);
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
  Future<List<SectionModel>> getAll() async {
    try {
      var response = await api.get(endpoint: "${ApiConfig.sections}/");

      if (response.statusCode.success) {
        var projects = (jsonDecode(response.body) as List)
            .map((data) => SectionModel.fromJson(data))
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
        endpoint: "${ApiConfig.sections}/$id",
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
