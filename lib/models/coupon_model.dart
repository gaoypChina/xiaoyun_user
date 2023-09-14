class CouponModel {
  int id = 0;
  String expireTime = '';
  int? couponId;
  String title = '';
  String? full;
  String? money;
  String? fullMoney;
  String? moneyMoney;
  int? status;
  String remark = '';
  int? type; //优惠券类型，1：全场通用满减券,2:首单免费券,3:普通免费券
  String couponCode = '';
  int? activityStatus; //活动状态:0:不存在,1:活动进行中,2:活动已结束, 3: 活动未开始
  int? getStatus; //是否领取:0:未领取,1:已领取

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    expireTime = json["expireTime"];
    couponId = json["couponId"];
    title = json["title"];
    int fullValue = json["full"] ?? 0;
    full = (fullValue / 100).toStringAsFixed(0);
    int moneyValue = json["money"] ?? 0;
    money = (moneyValue / 100).toStringAsFixed(0);
    couponId = json["couponId"];
    fullMoney =
        (double.tryParse("${json["fullMoney"]}") ?? 0.0).toStringAsFixed(0);
    moneyMoney =
        (double.tryParse("${json["moneyMoney"]}") ?? 0.0).toStringAsFixed(0);
    status = json["status"];
    remark = json["remark"] ?? "";
    type = json["type"];
    if (json.containsKey('couponCode')) {
      couponCode = json['couponCode'];
    }
    if (json.containsKey('activityStatus')) {
      activityStatus = json['activityStatus'];
    }
    if (json.containsKey('getStatus')) {
      getStatus = json['getStatus'];
    }
  }
}
