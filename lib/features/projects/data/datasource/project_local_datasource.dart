import 'package:hive/hive.dart';
import 'package:itodo/common/errors/exceptions.dart';
import 'package:itodo/features/projects/data/model/project_model.dart';

abstract interface class ProjectLocalDataSource {
  void insert({required List<ProjectModel> items});
  List<ProjectModel> getAll();
  ProjectModel getById(String id);
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final Box box;
  ProjectLocalDataSourceImpl(this.box);
  @override
  List<ProjectModel> getAll() {
    List<ProjectModel> items = [];
    for (int i = 0; i < box.length; i++) {
      final jsonData = box.get(i.toString());
      items.add(ProjectModel.fromJson(jsonData));
    }
    return items;
  }

  @override
  void insert({required List<ProjectModel> items}) {
    box.clear();
    box.write(() {
      for (int i = 0; i < items.length; i++) {
        box.put(i.toString(), items[i]);
      }
    });
  }

  @override
  ProjectModel getById(String id) {
    for (int i = 0; i < box.length; i++) {
      final jsonData = box.get(i.toString());
      final item = ProjectModel.fromJson(jsonData);
      if (item.id == id) {
        return item;
      }
    }
    return throw const ServerException("Project Not found");
  }
}
