class OrderBillModel {
  int id = 0;
  String no = '';
  String? completeTime;
  double payFee = 0.00;
  String server = '';
  bool isChecked = false;

  OrderBillModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    no = json["no"];
    completeTime = json["completeTime"];
    payFee = double.tryParse(json["payFee"]) ?? 0.00;
    List serverList = json["orderPriceList"];
    server = serverList.map((e) => e["projectTitle"]).toList().join(" ");
  }
}
