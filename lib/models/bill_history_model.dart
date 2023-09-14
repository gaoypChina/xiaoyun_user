class BillHistoryModel {
  int id = 0;
  String createTime = '0';
  String? priceMoney;
  int? status;
  String defaultName = '';
  int? count;

  BillHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    createTime = json["createTime"];
    priceMoney = json["priceMoney"];
    status = json["status"];
    if (json.containsKey('defaultName')) {
      defaultName = json['defaultName'];
    }
    count = json["count"];
  }
}

class BillHistoryDetailModel extends BillHistoryModel {
  String billTitle = '';
  String email = '';
  String dutyNo = '';
  String regAddress = '';
  String regPhone = '';
  String openBank = '';
  String bankNo = '';
  int headType = 0;
  List<String> no = [];

  BillHistoryDetailModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    String? uname = json["uname"];
    billTitle = uname == null || uname.isEmpty ? json["company"] : uname;
    email = json["email"];
    dutyNo = json["dutyNo"];
    regAddress = json["regAddress"];
    regPhone = json["regPhone"];
    openBank = json["openBank"];
    bankNo = json["bankNo"];
    headType = json["headType"];

    List noJsonList = json["no"];
    no = noJsonList.map((e) => e.toString()).toList();
  }
}
