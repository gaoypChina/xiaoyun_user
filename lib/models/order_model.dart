import 'package:xiaoyun_user/models/project_model.dart';

class OrderModel {
  int id = 0;
  String no = '';
  List<ProjectModel> orderPriceList = [];
  String priceMoney = '0.00';

  bool isReserve = false;
  String? reserveStartTime;
  String? reserveEndTime;

  bool isCancel = false;
  bool isPay = false;

  bool isEvaluate = false;
  bool isEvaluable = false;
  int isOtherFeePay = 1; //其他费用是否已支付/退还，0:是未发生支付和退还，1:已支付，2:退还 3.待支付
  String otherFeePay = '0.0';

  String? otherFeeTotal;

  String? otherFeeThirdTradeNo;
  String? discountPrice;

  int orderSta = 1;
  String status = "";

  int? otherFeePayType; // 其他费用支付方式:2:微信,3:支付宝,4:余额抵扣,5:混合支付

  int? payType; //订单支付方式，1：0元支付，2：微信支付，3：支付宝支付 4:余额抵扣  5混合支付
  bool? isBalance; //是否使用余额抵扣:0:未使用,1:使用
  String? balancePrice;
  int? surplusOrderPayType; //混合支付订单费用支付方式:0:支付宝,1:微信
  String? surplusOrderPrice;
  int? surplusOtherPayType; //合支付其他费用支付方式:0:支付宝,1:微信
  String? surplusOtherPrice;

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    no = json["no"];
    priceMoney = json["priceMoney"];
    isReserve = json["reserveStartTime"] != null;
    reserveStartTime = json["reserveStartTime"];
    reserveEndTime = json["reserveEndTime"];

    orderPriceList = [];

    List? projectJsonList = json["orderPriceVo"];
    if (projectJsonList == null) {
      projectJsonList = json["orderPriceList"];
    }

    projectJsonList!.forEach((element) {
      orderPriceList.add(ProjectModel.fromJson(element));
    });

    isCancel = json["isCancel"] == 1;
    isPay = json["isPay"] == 1;
    isEvaluate = json["isEvaluate"] == 1;
    if (json.containsKey('isEvaluation')) {
      isEvaluable = json['isEvaluation'] == 0;
    }
    isOtherFeePay = json["isOtherFeePay"];
    otherFeeThirdTradeNo = json["otherFeeThirdTradeNo"];
    otherFeePay = json["otherFeePay"] ?? "0.00";
    if (json.containsKey('otherFeeTotal')) {
      otherFeeTotal = json['otherFeeTotal'];
    }

    orderSta = json["orderSta"] ?? 0;

    status = ["", "待分配", "待服务", "服务中", "已完成", "售后", "已取消"][orderSta];
    if (isCancel) {
      status = "已取消";
    } else if (!isPay) {
      status = "待支付";
    }

    if (json.containsKey('discountPrice')) {
      discountPrice = json['discountPrice'];
    }

    if (json.containsKey('payType')) {
      payType = json['payType'];
    }

    if (json.containsKey('isBalance')) {
      isBalance = json['isBalance'] == 1;
    }

    if (json.containsKey('balancePrice')) {
      balancePrice = json['balancePrice'];
    }

    if (json.containsKey('surplusOrderPayType')) {
      surplusOrderPayType = json['surplusOrderPayType'];
    }

    if (json.containsKey('surplusOrderPrice')) {
      surplusOrderPrice = json['surplusOrderPrice'];
    }

    if (json.containsKey('surplusOtherPayType')) {
      surplusOtherPayType = json['surplusOtherPayType'];
    }

    if (json.containsKey('surplusOtherPrice')) {
      surplusOtherPrice = json['surplusOtherPrice'];
    }
  }
}
