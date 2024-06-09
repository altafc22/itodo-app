/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
// class Args {
//   String? id;
//   String? sectionid;
//   String? projectid;

//   Args({this.id, this.sectionid, this.projectid});

//   Args.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     sectionid = json['section_id'];
//     projectid = json['project_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['section_id'] = sectionid;
//     data['project_id'] = projectid;
//     return data;
//   }
// }

class Command {
  String? type;
  String? uuid;
  Map<String, dynamic>? args;

  Command({this.type, this.uuid, this.args});

  Command.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    uuid = json['uuid'];
    args = json['args'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['uuid'] = uuid;
    data['args'] = args;
    return data;
  }
}

class SyncApiParams {
  List<Command?>? commands;

  SyncApiParams({this.commands});

  SyncApiParams.fromJson(Map<String, dynamic> json) {
    if (json['commands'] != null) {
      commands = <Command>[];
      json['commands'].forEach((v) {
        commands!.add(Command.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commands'] = commands?.map((v) => v?.toJson()).toList();
    return data;
  }
}
