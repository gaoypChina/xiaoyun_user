class RechargePriceModel {
  int? id;
  String presentedPrice = '0.0';
  String price = '0.0';
  int? type;
  String content = '';

  RechargePriceModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    presentedPrice = json["presentedPrice"];
    price = json["price"];
    type = json["type"];
    content = json["content"] ?? "";
  }
}
