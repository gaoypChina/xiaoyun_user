class ResultData {
  var data;
  String? msg;
  int code;

  bool get isSuccessful {
    return code == 100;
  }

  ResultData(this.data, this.msg, this.code);

  factory ResultData.fromJson(Map<String, dynamic> json) {
    var data = json.containsKey('result')?json['result']:json['data'];
    String? msg = json.containsKey('resultDes')? json['resultDes']:json['msg'];
    int code = json['code'];
    return ResultData(
      data,
      msg,
      code,
    );
  }
}
