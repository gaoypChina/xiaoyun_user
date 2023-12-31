class ServiceProjectModel {
  int id = 0;
  String title = '';
  String photoImgUrl = '';
  String priceMoney = '';
  double originalPriceMoney = 0.0;
  String content = '';
  String intro = '';
  String tag = '';
  bool isHot = false;
  String recommendText = '';

  bool isChecked = false;

  ServiceProjectModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    content = json["content"] ?? "";
    intro = json["intro"] ?? "";
    photoImgUrl = json["photoImgUrl"] ?? "";
    priceMoney = json["priceMoney"];
    originalPriceMoney = double.tryParse(json["originalPriceMoney"]) ?? 0.0;
    tag = json["tag"] ?? "";
    isHot = json["cornerMark"] == "1";
    recommendText = json["recommendText"];
  }
}
