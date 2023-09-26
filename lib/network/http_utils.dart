import 'package:dio/dio.dart';
import '../utils/toast_utils.dart';
import '../constant/constant.dart';

import 'logout_interceptor.dart';
import 'logs_interceptor.dart';
import 'result_data.dart';
import 'token_interceptor.dart';

class HttpUtils {
  static const Duration connectTimeout = Duration(milliseconds: 2000);
  static const Duration receiveTimeout = Duration(milliseconds: 2000);

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
        bool showError = true
      }) async {
    return await request(
        path,
        method: GET,
        queryParameters: params,
        onSuccess: onSuccess,
        onError: onError,
        showError: showError);
  }

  static Future<ResultData> post(String path,
      {Map<String, dynamic>? params,
        Function(ResultData resultData)? onSuccess,
        Function(String msg)? onError,
        bool showError = true}) async {
    return await request(
        path,
        params: params,
        method: POST,
        onSuccess: onSuccess,
        onError: onError,
        showError: showError);
  }

  static Future<ResultData> request(String path,
      {String? method,
        dynamic params,
        dynamic queryParameters,
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
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(LogoutInterceptor());
    // _dio.interceptors.add(LogInterceptor(responseBody: true));

    late ResultData resultData;
    try {
      Response response;
      response = await _dio.request(path,queryParameters: queryParameters,data: params);
      resultData = ResultData.fromJson(response.data);
    } catch (error) {
      String message = '网络连接错误';
      if (error is DioException) {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          message = '网络请求超时';
        }
        resultData = ResultData(null, message, 102);
      }
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
