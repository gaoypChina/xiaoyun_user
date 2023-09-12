class ServicePhoneModel {
  String name;
  String phone;

  ServicePhoneModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    phone = json["phone"];
  }
}
