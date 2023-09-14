class BalanceModel {
  int? id;
  String? createTime;
  int type = 0; //0:其他,1：充值，2：退款, 3: 余额抵扣
  int? flow;
  String moneyPrice = '0';
  String balancePrice = '0';
  String title = '';
  String? orderId;

  BalanceModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    createTime = json["createTime"];
    type = json["type"];
    flow = json["flow"];
    moneyPrice = "${json["moneyPrice"]}";
    balancePrice = "${json["balancePrice"]}";
    title = json["title"];
    orderId = json["orderId"];
  }
}
