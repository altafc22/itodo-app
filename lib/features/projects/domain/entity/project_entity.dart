class ProjectEntity {
  String id;
  String name;
  int? commentcount;
  int? order;
  String? color;
  bool? isshared;
  bool? isfavorite;
  String? parentid;
  bool? isinboxproject;
  bool? isteaminbox;
  String? viewstyle;
  String? url;

  ProjectEntity(
      {this.id = '',
      this.name = '',
      this.commentcount,
      this.order,
      this.color,
      this.isshared,
      this.isfavorite,
      this.parentid,
      this.isinboxproject,
      this.isteaminbox,
      this.viewstyle,
      this.url});
}
