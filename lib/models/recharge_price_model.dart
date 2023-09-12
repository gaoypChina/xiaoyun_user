class RechargePriceModel {
  int id;
  String presentedPrice;
  String price;
  int type;
  String content;

  RechargePriceModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    presentedPrice = json["presentedPrice"];
    price = json["price"];
    type = json["type"];
    content = json["content"] ?? "";
  }
}
