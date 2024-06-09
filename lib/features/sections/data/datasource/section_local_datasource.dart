import 'package:hive/hive.dart';

import '../model/section_model.dart';

abstract interface class SectionLocalDataSource {
  void insert({required List<SectionModel> items});
  List<SectionModel> getAll();
  List<SectionModel> getAllByProjectId(String projectId);
}

class SectionLocalDataSourceImpl implements SectionLocalDataSource {
  final Box box;
  SectionLocalDataSourceImpl(this.box);
  @override
  List<SectionModel> getAll() {
    List<SectionModel> items = [];
    for (int i = 0; i < box.length; i++) {
      final jsonData = box.get(i.toString());
      items.add(SectionModel.fromJson(jsonData));
    }
    return items;
  }

  @override
  void insert({required List<SectionModel> items}) {
    box.clear(); // clearing old cached records
    box.write(() {
      for (int i = 0; i < items.length; i++) {
        box.put(i.toString(), items[i]);
      }
    });
  }

  @override
  List<SectionModel> getAllByProjectId(String projectId) {
    List<SectionModel> items = [];
    for (int i = 0; i < box.length; i++) {
      final jsonData = box.get(i.toString());
      items.add(SectionModel.fromJson(jsonData));
    }
    List<SectionModel> filteredSections =
        items.where((section) => section.projectId == projectId).toList();

    return filteredSections;
  }
}
