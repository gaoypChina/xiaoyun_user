class BillTitleModel {
  int? id;
  String? title;
  int? headType;
  bool isDefault = true;

  BillTitleModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["company"] ?? json["uname"];
    headType = json["headType"];
    isDefault = json["isDefault"] == 1;
  }
}
