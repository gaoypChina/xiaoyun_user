class CarPropertyModel {
  int id;
  String title;

  CarPropertyModel({this.id, this.title});

  CarPropertyModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
  }
}
