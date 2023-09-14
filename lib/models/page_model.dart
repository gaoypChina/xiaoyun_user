class PageModel {
  int? current;
  int pages = 0;
  int? total;
  int? size;
  List records = [];

  PageModel.fromJson(Map<String, dynamic> json) {
    current = json["current"];
    pages = json["pages"];
    total = json["total"];
    size = json["size"];
    records = json["records"] as List;
  }
}
