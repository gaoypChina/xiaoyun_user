class ProjectModel {
  int id = 0;
  String? projectTitle;
  String? priceMoney;
  String? avatarImgUrl;
  double? originalPriceMoney;

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    projectTitle = json["projectTitle"];
    priceMoney = json["priceMoney"];
    avatarImgUrl = json["avatarImgUrl"];
    String original = json["originalPriceMoney"] ?? "0";
    originalPriceMoney = double.tryParse(original) ?? 0.0;
  }
}
