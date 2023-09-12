class NoticeModel {
  int id;
  String content;
  String createTime;
  int messageType; //消息类型：1：订单状态变更，2：订单退款，3：售后，4：开票，5：提现
  int messageChildType; // 消息子类类型：1：用户付款成功，2：用户订单接单成功，3：修改订单待支付，4：用户售后，5：用户退款成功，6：用户开票成功，7：洗车工待接单，8：洗车工提现成功，9：洗车工已接单订单被取消
  int orderId;
  bool isRead;

  String title;

  NoticeModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    content = json["content"];
    createTime = json["createTime"];
    messageType = json["messageType"];
    messageChildType = json["messageChildType"];
    orderId = json["orderId"];
    isRead = json["readStatus"] == 1;
    if (messageChildType > 6) {
      title = "系统消息";
    } else {
      title = [
        "",
        "付款成功",
        "订单接单成功",
        "修改订单待支付",
        "售后",
        "退款成功",
        "开票成功"
      ][messageChildType];
    }
  }
}
