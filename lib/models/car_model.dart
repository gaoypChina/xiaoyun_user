class CarModel {
  int id;
  String code;
  int codeType;
  int carBrandId;
  String carBrandTitle;
  int carColourId;
  String carColourTitle;
  int carTypeId;
  String carTypeTitle;
  int photo;
  String photoImgUrl;
  bool isDefault;
  bool isJersey;

  CarModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    code = json["code"];
    codeType = json["codeType"];
    carBrandId = json["carBrandId"];
    carBrandTitle = json["carBrandTitle"];
    carColourId = json["carColourId"];
    carColourTitle = json["carColourTitle"];
    carTypeId = json["carTypeId"];
    carTypeTitle = json["carTypeTitle"];
    photo = json["photo"];
    photoImgUrl = json["photoImgUrl"];
    isDefault = json["isDefault"] == 1;
    isJersey = json["isJersey"] == 1;
  }
}
