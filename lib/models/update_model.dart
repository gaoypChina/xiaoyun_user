class UpdateModel {
  String appVersionNew;
  String content;
  String downloadLink;
  bool isForce;

  UpdateModel.fromJson(Map<String, dynamic> json) {
    appVersionNew = json["appVersionNew"];
    content = json["content"] ?? "";
    downloadLink = json["downloadLink"] ?? "";
    isForce = json["status"] == 1;
  }
}
