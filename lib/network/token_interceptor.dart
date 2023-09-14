import 'package:dio/dio.dart';
import '../utils/sp_utils.dart';
import '../constant/constant.dart';

class TokenIntercxeptor extends InterceptorsWrapper {
  String? _token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token == null) {
      var authorizationCode = getAuthorization();
      if (authorizationCode != null) {
        _token = authorizationCode;
      }
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

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          responseJson["token"] != null) {
        _token = responseJson["token"];
        SpUtil.putString(Constant.token, _token??'');
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
  getAuthorization() {
    String token = SpUtil.getString(Constant.token);
    if (token == null) {
      return '';
    } else {
      this._token = token;
      return token;
    }
  }
}
