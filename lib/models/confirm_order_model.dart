import 'package:xiaoyun_user/models/car_model.dart';
import 'package:xiaoyun_user/models/coupon_model.dart';
import 'package:xiaoyun_user/models/service_project_model.dart';

class ConfirmOrderModel {
  String? projectFee;
  String? starFee;
  String? allStarFee;
  String? payFee;
  CarModel? car;
  List<ServiceProjectModel> projects = [];
  List<CouponModel> couponList = [];
  String? address = '';
  String? phone = '';
  String? contact = '';
  int sex = 0;

  String? couponPrice;
  double discountPrice = 0.0;

  ConfirmOrderModel.fromJson(Map<String, dynamic> json) {
    projectFee = json["projectFee"];
    starFee = json["starFee"];
    allStarFee = json["allStarFee"];
    payFee = json["payFee"];
    car = CarModel.fromJson(json["car"]);

    projects = [];
    List projectsJsonList = json["projects"] as List;
    projectsJsonList.forEach((element) {
      projects.add(ServiceProjectModel.fromJson(element));
    });

    couponList = [];
    List couponJsonList = json["couponList"] as List;
    couponJsonList.forEach((element) {
      couponList.add(CouponModel.fromJson(element));
    });

    address = json["address"];
    phone = json["phone"];
    contact = json["contact"];
    sex = json["sex"] ?? -1;

    couponPrice = json["couponPrice"];
    discountPrice = double.tryParse(json["discountPrice"]) ?? 0.0;
  }
}
