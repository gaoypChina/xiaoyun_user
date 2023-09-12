import 'package:xiaoyun_user/models/project_model.dart';

class OrderModel {
  int id;
  String no;
  List<ProjectModel> orderPriceList;
  String priceMoney;

  bool isReserve = false;
  String reserveStartTime;
  String reserveEndTime;

  bool isCancel;
  bool isPay;

  bool isEvaluate;
  bool isEvaluable;
  int isOtherFeePay; //其他费用是否已支付/退还，0:是未发生支付和退还，1:已支付，2:退还 3.待支付
  String otherFeePay;

  String otherFeeTotal;

  String otherFeeThirdTradeNo;
  String discountPrice;

  int orderSta;
  String status = "";

  int otherFeePayType; // 其他费用支付方式:2:微信,3:支付宝,4:余额抵扣,5:混合支付

  int payType; //订单支付方式，1：0元支付，2：微信支付，3：支付宝支付 4:余额抵扣  5混合支付
  bool isBalance; //是否使用余额抵扣:0:未使用,1:使用
  String balancePrice;
  int surplusOrderPayType; //混合支付订单费用支付方式:0:支付宝,1:微信
  String surplusOrderPrice;
  int surplusOtherPayType; //合支付其他费用支付方式:0:支付宝,1:微信
  String surplusOtherPrice;

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    no = json["no"];
    priceMoney = json["priceMoney"];
    isReserve = json["reserveStartTime"] != null;
    reserveStartTime = json["reserveStartTime"];
    reserveEndTime = json["reserveEndTime"];

    orderPriceList = [];

    List projectJsonList = json["orderPriceVo"];
    if (projectJsonList == null) {
      projectJsonList = json["orderPriceList"];
    }

    projectJsonList.forEach((element) {
      orderPriceList.add(ProjectModel.fromJson(element));
    });

    isCancel = json["isCancel"] == 1;
    isPay = json["isPay"] == 1;
    isEvaluate = json["isEvaluate"] == 1;
    isEvaluable = json["isEvaluation"] == 0;
    isOtherFeePay = json["isOtherFeePay"];
    otherFeeThirdTradeNo = json["otherFeeThirdTradeNo"];
    otherFeePay = json["otherFeePay"] ?? "0.00";
    otherFeeTotal = json["otherFeeTotal"] ?? "0.00";

    orderSta = json["orderSta"] ?? 0;

    status = ["", "待分配", "待服务", "服务中", "已完成", "售后", "已取消"][orderSta];
    if (isCancel) {
      status = "已取消";
    } else if (!isPay) {
      status = "待支付";
    }

    discountPrice = json["discountPrice"];
    payType = json["payType"];
    isBalance = json["isBalance"] == 1;
    balancePrice = json["balancePrice"];

    surplusOrderPayType = json["surplusOrderPayType"];
    surplusOrderPrice = json["surplusOrderPrice"];
    surplusOtherPayType = json["surplusOtherPayType"];
    surplusOtherPrice = json["surplusOtherPrice"];
  }
}
