class OtherFeeModel {
  String otherComment;
  String staffUpdateTime;
  String otherFeePayPrice;

  double payFeePrice;
  String staffUpdateCarType;
  String carType;
  double staffUpdateOrderMoneyPrice;
  bool isAdd;

  OtherFeeModel.fromJson(Map<String, dynamic> json) {
    otherComment = json["otherComment"] ?? "未填写";
    staffUpdateTime = json["staffUpdateTime"];
    otherFeePayPrice = json["otherFeePayPrice"];
    String payFeeValue = json["payFeePrice"] ?? "0.0";
    payFeePrice = double.tryParse(payFeeValue) ?? 0.0;
    staffUpdateCarType = json["staffUpdateCarType"];
    carType = json["carType"];
    staffUpdateOrderMoneyPrice =
        double.tryParse(json["staffUpdateOrderMoneyPrice"]) ?? 0.0;
    isAdd = json["moneyType"] == 0;
  }
}
