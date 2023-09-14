import 'package:dio/dio.dart';
import '../utils/toast_utils.dart';
import '../constant/constant.dart';

import 'logout_interceptor.dart';
import 'logs_interceptor.dart';
import 'result_data.dart';
import 'token_interceptor.dart';

class HttpUtils {
  static const int connectTimeout = 20000;
  static const int receiveTimeout = 30000;

  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';
  static const String UPLOAD = 'upload';

  static Future<ResultData> get(String path,
      {Map<String, dynamic>? params,
      Function(ResultData resultData)? onSuccess,
      Function(String msg)? onError,
      bool showError = true}) async {
    return await request(path,
        params: params,
        method: GET,
        onSuccess: onSuccess,
        onError: onError,
        showError: showError);
  }

  static Future<ResultData> post(String path,
      {Map<String, dynamic>? params,
      Function(ResultData resultData)? onSuccess,
      Function(String msg)? onError,
      bool showError = true}) async {
    return await request(path,
        params: params,
        method: POST,
        onSuccess: onSuccess,
        onError: onError,
        showError: showError);
  }

  static Future<ResultData> request(String path,
      {String? method,
      dynamic params,
      Function(ResultData)? onSuccess,
      Function(String msg)? onError,
      bool showError = true}) async {
    BaseOptions options = BaseOptions(
      method: GET,
      baseUrl: Constant.baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      responseType: ResponseType.json,
      headers: {'platform': '1', 'version': '2.0.0'},
    );
    if (method != null) {
      options.method = method;
    }
    if (method == UPLOAD) {
      options.contentType = 'multipart/form-data';
    } else {
      options.contentType = "application/json";
    }

    Dio _dio = Dio(options);

    _dio.interceptors.add(LogsInterceptors());
    _dio.interceptors.add(TokenIntercxeptor());
    _dio.interceptors.add(LogoutInterceptor());
    // _dio.interceptors.add(LogInterceptor(responseBody: true));

    ResultData resultData;
    try {
      Response response;
      if (method == GET) {
        response = await _dio.get(path, queryParameters: params);
      } else {
        response = await _dio.post(path, data: params);
      }
      resultData = ResultData.fromJson(response.data);
    } on DioError catch (error) {
      String message = '网络连接错误';
      if (error.type == DioErrorType.connectTimeout ||
          error.type == DioErrorType.receiveTimeout) {
        message = '网络请求超时';
      }
      resultData = ResultData(null, message, 102);
    }
    if (resultData.isSuccessful) {
      if (onSuccess != null) {
        onSuccess(resultData);
      }
    } else {
      if (showError) {
        ToastUtils.showError(resultData.msg ?? "未知错误");
      }
      if (onError != null) {
        onError(resultData.msg ?? '未知错误');
      }
    }
    return resultData;
  }
}
