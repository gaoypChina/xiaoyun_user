import 'package:dio/dio.dart';
import '../utils/sp_utils.dart';
import '../constant/constant.dart';

class TokenInterceptor extends InterceptorsWrapper {
  String? _token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token == null) {
      _token = getAuthorization();
    }
    options.headers["Authorization"] = "Bearer " + _token!;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      var responseJson = response.data["data"];

      if (responseJson == null || !(responseJson is Map)) {
        super.onResponse(response, handler);
        return;
      }

      if ((response.statusCode == 201 || response.statusCode == 200) && responseJson["token"] != null) {
        _token = responseJson["token"];
        SpUtil.putString(Constant.token, _token!);
      }
    } catch (e) {
      print(e);
    }
    super.onResponse(response, handler);
  }

  ///清除授权
  clearAuthorization() {
    this._token = null;
    SpUtil.remove(Constant.token);
  }

  ///获取授权token
  String getAuthorization() {
    return SpUtil.getString(Constant.token);
  }
}
