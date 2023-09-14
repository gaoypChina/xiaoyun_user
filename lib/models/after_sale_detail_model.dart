class AfterSaleDetailModel {
  int? id;
  String no = '';
  String createTime = '';
  int? orderId;
  String reason = '';
  String comment = '';
  int status = 0;
  String refuseReason = '';
  String refundFeeMoney = '';

  List<String> photoList = [];
  String statusTitle = "";
  String statusDesc = "";

  AfterSaleDetailModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    no = json["no"];
    createTime = json["createTime"];
    orderId = json["orderId"];
    reason = json["reason"];
    comment = json["comment"] ?? "未填写";
    status = json["status"];
    refuseReason = json["refuseReason"] ?? "未填写";
    refundFeeMoney = json["refundFeeMoney"];

    List photoJsonList = json["photoList"] ?? [];
    photoList =
        photoJsonList.map<String>((e) => e["photo"].toString()).toList();

    //1：待审核，2：审核通过，3：审核拒绝，4：已打款
    statusTitle = ["", "退款待处理", "退款中", "已拒绝", "已打款"][status];
    statusDesc = [
      "",
      "退款申请提交成功，请等待商家处理",
      "正在进行退款处理，请耐心等待",
      "商家拒绝了您的退款申请。原因：",
      "退款已发送，请注意查收"
    ][status];
    if (status == 3) {
      statusDesc += refuseReason;
    }
  }
}
