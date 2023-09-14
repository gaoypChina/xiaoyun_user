class ResultData {
  var data;
  String? msg;
  int code;

  bool get isSuccessful {
    return code == 100;
  }

  ResultData(this.data, this.msg, this.code);

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      json['result'],
      json['resultDes'],
      json['code'],
    );
  }
}
