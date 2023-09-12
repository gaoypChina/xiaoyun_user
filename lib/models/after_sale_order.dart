import 'package:xiaoyun_user/models/project_model.dart';

class AfterSaleOrder {
  int id;
  String no;
  List<ProjectModel> orderPriceList;
  String priceMoney;

  bool isReserve = false;
  String reserveStartTime;
  String reserveEndTime;

  int orderSta;
  String status = "";

  AfterSaleOrder.fromJson(Map<String, dynamic> json) {
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
    orderSta = json["orderSta"];
    //1：待审核，2：审核通过，3：审核拒绝，4：已打款
    status = ["", "待审核", "退款中", "已拒绝", "已退款"][orderSta];
  }
}
