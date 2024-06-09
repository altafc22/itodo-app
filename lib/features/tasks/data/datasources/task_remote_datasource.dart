import 'dart:convert';

import 'package:itodo/common/extensions/app_extension.dart';
import 'package:itodo/common/utils/log_utils.dart';
import 'package:itodo/features/tasks/data/model/complete_task_model.dart';
import 'package:itodo/features/tasks/domain/usecase/add_task.dart';
import 'package:itodo/features/tasks/domain/usecase/move_task.dart';
import 'package:itodo/features/tasks/domain/usecase/reorder_task.dart';
import 'package:itodo/features/tasks/domain/usecase/update_task.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/errors/error_response.dart';
import '../../../../common/errors/exceptions.dart';
import '../../../../common/network/api_client.dart';
import '../../../../common/network/api_config.dart';
import '../model/task_model.dart';

abstract interface class TaskRemoteDataSource {
  Future<TaskModel> add(AddTaskParams param);
  Future<TaskModel> update(UpdateTaskParams param);
  Future<List<TaskModel>> getAll();
  Future<TaskModel> get(String id);
  Future<String> delete(String id);
  Future<String> reopen(String id);
  Future<String> close(String id);
  Future<String> move(MoveTaskParams sectionId);
  Future<String> reorder(List<ReorderTasksParams> sectionId);
  Future<CompletedTasksModel> getCompletedTasks();
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiClient api;
  TaskRemoteDataSourceImpl(this.api);

  @override
  Future<TaskModel> add(AddTaskParams param) async {
    try {
      final body = jsonEncode(param);
      printInfo("BODY:::: $body");
      var response = await api.post(
        endpoint: ApiConfig.tasks,
        body: body,
      );
      printInfo(response.body);
      if (response.statusCode.success) {
        return TaskModel.fromJson(jsonDecode(response.body));
      } else {
        var error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw ServerException(error.error ?? 'Error occured');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TaskModel> update(UpdateTaskParams param) async {
    try {
      var response = await api.post(
        endpoint: "${ApiConfig.tasks}/${param.id}",
        body: jsonEncode(param),
      );
      printInfo(response.body);
      if (response.statusCode.success) {
        return TaskModel.fromJson(jsonDecode(response.body));
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
  Future<TaskModel> get(String id) async {
    try {
      var response = await api.get(
        endpoint: "${ApiConfig.tasks}/$id",
      );

      if (response.statusCode.success) {
        var data = jsonDecode(response.body);
        return TaskModel.fromJson(data);
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
  Future<List<TaskModel>> getAll() async {
    try {
      var response = await api.get(endpoint: "${ApiConfig.tasks}/");

      if (response.statusCode.success) {
        var tasks = (jsonDecode(response.body) as List)
            .map((data) => TaskModel.fromJson(data))
            .toList();

        return tasks;
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
        endpoint: "${ApiConfig.tasks}/$id",
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
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> close(String id) async {
    try {
      var response = await api.post(
        endpoint: "${ApiConfig.tasks}/$id/close",
      );

      if (response.statusCode.success) {
        return 'Task closed sucessfully';
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
  Future<String> reopen(String id) async {
    try {
      var response = await api.post(
        endpoint: "${ApiConfig.tasks}/$id/reopen",
      );

      if (response.statusCode.success) {
        return 'Task reopened sucessfully';
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
  Future<String> move(MoveTaskParams params) async {
    try {
      var uuid = const Uuid().v1();

      final data = {
        'commands': [
          {
            "type": "item_move",
            "uuid": uuid,
            "args": {
              "id": params.id,
              "section_id": params.sectionId,
            }
          }
        ]
      };

      var response = await api.post(
        newBaseUrl: ApiConfig.syncBaseUrl + ApiConfig.sync,
        endpoint: "",
        body: jsonEncode(data),
      );

      if (response.statusCode.success) {
        final responseData = jsonDecode(response.body);
        final syncStatusValue = responseData['sync_status'][uuid];
        printInfo(syncStatusValue);
        if (syncStatusValue == 'ok') {
          return 'Task moved sucessfully';
        } else {
          throw const ServerException('Error occured');
        }
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
  Future<String> reorder(List<ReorderTasksParams> items) async {
    try {
      var uuid = const Uuid().v1();

      final data = {
        'commands': [
          {
            "type": "item_reorder",
            "uuid": uuid,
            "args": {
              "items": items,
            }
          }
        ]
      };

      var response = await api.post(
        newBaseUrl: ApiConfig.syncBaseUrl + ApiConfig.sync,
        endpoint: "",
        body: jsonEncode(data),
      );

      if (response.statusCode.success) {
        final responseData = jsonDecode(response.body);
        final syncStatusValue = responseData['sync_status'][uuid];
        printInfo(syncStatusValue);
        if (syncStatusValue == 'ok') {
          return 'Task reordered sucessfully';
        } else {
          throw const ServerException('Error occured');
        }
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
  Future<CompletedTasksModel> getCompletedTasks() async {
    try {
      var response = await api.get(
        newBaseUrl: ApiConfig.syncBaseUrl + ApiConfig.completedTasks,
        endpoint: "",
      );

      if (response.statusCode.success) {
        var tasks = CompletedTasksModel.fromJson(jsonDecode(response.body));
        return tasks;
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
