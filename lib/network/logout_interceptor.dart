import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/routes/route_export.dart';

import '../constant/constant.dart';
import '../utils/sp_utils.dart';

import 'result_data.dart';

class LogoutInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      ResultData resultData = ResultData.fromJson(response.data);
      if (resultData.code == 401) {
        JPush jPush = JPush();
        jPush.deleteAlias();
        jPush.cleanTags().then((map) {});
        SpUtil.remove(Constant.loginState);
        UserEventBus().fire(UserStateChangedEvent(false));
        Application.navigatorKey.currentState.popUntil(
          ModalRoute.withName(Routes.main),
        );
        Application.navigatorKey.currentState.pushNamed(Routes.login);
      }
    } catch (e) {
      print(e);
    }
    super.onResponse(response, handler);
  }
}
