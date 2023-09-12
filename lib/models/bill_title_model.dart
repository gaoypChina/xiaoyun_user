class BillTitleModel {
  int id;
  String title;
  int headType;
  bool isDefault;

  BillTitleModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["company"] ?? json["uname"];
    headType = json["headType"];
    isDefault = json["isDefault"] == 1;
  }
}
