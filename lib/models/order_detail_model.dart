import 'package:xiaoyun_user/models/car_model.dart';
import 'package:xiaoyun_user/models/order_model.dart';

class OrderDetailModel extends OrderModel {
  String address;
  String gps;
  String contact;
  String phone;
  String comment;
  CarModel accountCar;
  String carLocation;
  String otherComment;

  String createTime;
  String cancelTime;
  String receiveTime;
  String startTime;
  String completeTime;

  bool isStarServe;
  String starFeeMoney;
  String payFeeMoney;
  String priceMoney;

  String wxPayPriceTotal;
  String aliPayPriceTotal;

  int couponReduceFee;
  String couponReduceFeeMoney;

  StaffModel staff;

  int waitNumber;

  bool cancelable;
  bool afterSalesable;
  bool isRefundStatus;
  String otherFeeTotalPrice;

  List<String> beforePhotoList = [];
  List<String> afterPhotoList = [];

  OrderDetailModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    address = json["address"];
    gps = json["gps"];
    contact = json["contact"];
    phone = json["phone"];
    carLocation = json["carLocation"] ?? "";
    comment = json["comment"];
    otherComment = json["otherComment"];

    isStarServe = json["starfeeStatus"] == 1;
    starFeeMoney = json["starFeeMoney"];
    priceMoney = json["priceMoney"] ?? "0.00";
    couponReduceFee = json["couponReduceFee"];
    couponReduceFeeMoney = json["couponReduceFeeMoney"] ?? "0.00";
    payFeeMoney = json["payFeeMoney"] ?? "0.00";

    wxPayPriceTotal = json["wxPayPriceTotal"] ?? "0.00";
    aliPayPriceTotal = json["aliPayPriceTotal"] ?? "0.00";

    if (json["dyStaffVO"] != null) {
      staff = StaffModel.fromJson(json["dyStaffVO"]);
    }

    accountCar = CarModel.fromJson(json["accountCar"]);

    cancelable = json["status"] == 0;
    afterSalesable = json["salesStatus"] == 0;
    isRefundStatus = json["isRefundStatus"] == 1;

    waitNumber = json["waitNumber"];

    List beforePhotoJsonList = json["beforePhotoList"] ?? [];
    beforePhotoJsonList.forEach((element) {
      beforePhotoList.add(element["fullImgUrlBefore"]);
    });

    List afterPhotoJsonList = json["afterPhotoList"] ?? [];
    afterPhotoJsonList.forEach((element) {
      afterPhotoList.add(element["fullImgUrlAfter"]);
    });

    createTime = json["createTime"];
    cancelTime = json["cancelTime"];
    receiveTime = json["receiveTime"];
    startTime = json["startTime"];
    completeTime = json["completeTime"];

    otherFeeTotalPrice = json["otherFeeTotalPrice"];
  }
}

class StaffModel {
  int id;
  String phone;
  String uname;
  String avatarImgUrl;
  String rating;

  StaffModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    phone = json["phone"];
    uname = json["uname"];
    avatarImgUrl = json["avatarImgUrl"] ?? "";
    rating = json["rating"] ?? "0";
  }
}
