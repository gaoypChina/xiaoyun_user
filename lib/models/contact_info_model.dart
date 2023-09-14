class ContactInfo {
  int? id;
  String address = '';
  String contactName = '';
  String contactPhone = '';
  int sex = 1;
  bool isDefault = true;

  ContactInfo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    contactName = json["contactName"];
    address = json["address"];
    contactPhone = json["contactPhone"];
    sex = json["sex"];
    isDefault = json["isDefault"] == 1;
  }
}
