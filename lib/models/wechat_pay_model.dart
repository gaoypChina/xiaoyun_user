class WechatPayModel {
  String appid;
  String noncestr;
  String package;
  String partnerid;
  String prepayid;
  String sign;
  int timestamp;

  WechatPayModel.fromJson(Map<String, dynamic> json) {
    appid = json["appid"];
    noncestr = json["noncestr"];
    package = json["package"];
    partnerid = json["partnerid"];
    prepayid = json["prepayid"];
    sign = json["sign"];
    timestamp = json["timestamp"];
  }
}
