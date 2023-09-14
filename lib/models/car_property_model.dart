class CarPropertyModel {
  int id = 0;
  String title = '';

  CarPropertyModel({this.id = 0, this.title = ''});

  CarPropertyModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
  }
}
