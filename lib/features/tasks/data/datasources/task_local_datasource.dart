import 'package:hive/hive.dart';
import 'package:itodo/common/errors/exceptions.dart';
import 'package:itodo/common/utils/log_utils.dart';
import 'package:itodo/features/tasks/data/model/complete_task_model.dart';
import 'package:itodo/features/tasks/data/model/task_model.dart';

abstract interface class TaskLocalDataSource {
  void insert({required List<TaskModel> items});
  List<TaskModel> getAll();
  List<TaskModel> getAllByProjectId(String projectId);
  void deleteLocalTask(String id);
  CompletedTasksModel getAllCompleted();
  void saveCompletedTasks(CompletedTasksModel data);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box taskBox;
  final Box completedTaskBox;

  TaskLocalDataSourceImpl(this.taskBox, this.completedTaskBox);
  @override
  List<TaskModel> getAll() {
    List<TaskModel> items = [];
    for (int i = 0; i < taskBox.length; i++) {
      final jsonData = taskBox.get(i.toString());
      items.add(TaskModel.fromJson(jsonData));
    }
    return items;
  }

  @override
  void insert({required List<TaskModel> items}) {
    taskBox.clear();
    taskBox.write(() {
      for (int i = 0; i < items.length; i++) {
        taskBox.put(i.toString(), items[i].toJson());
      }
    });
  }

  @override
  List<TaskModel> getAllByProjectId(String projectId) {
    List<TaskModel> items = [];
    for (int i = 0; i < taskBox.length; i++) {
      final jsonData = taskBox.get(i.toString());
      items.add(TaskModel.fromJson(jsonData));
    }
    List<TaskModel> filteredSections =
        items.where((section) => section.projectId == projectId).toList();

    return filteredSections;
  }

  @override
  void deleteLocalTask(String id) {
    printInfo("ID in deleteLocalTask: $id");
    for (int i = 0; i < taskBox.length; i++) {
      Map<String, dynamic>? jsonData = taskBox.get(i.toString());

      if (jsonData != null) {
        final localId = jsonData['id'];
        if (localId == id) {
          printInfo("Deleting $localId");
          taskBox.deleteAt(i);
        }
      }
    }
  }

  @override
  void saveCompletedTasks(CompletedTasksModel data) {
    completedTaskBox.clear();
    completedTaskBox.write(() {
      completedTaskBox.put("0", data.toJson());
    });
  }

  @override
  CompletedTasksModel getAllCompleted() {
    try {
      final jsonData = completedTaskBox.get("0");
      return CompletedTasksModel.fromJson(jsonData);
    } catch (e) {
      throw const ServerException("Not found");
    }
  }
}
