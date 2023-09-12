import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../routes/route_export.dart';

class NavigatorUtils {
  static Future showPage(BuildContext context, Widget page,
      {bool replace = false, bool clearStack = false}) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (clearStack) {
      return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
        (check) => false,
      );
    }

    return replace
        ? Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => page,
            ),
          )
        : Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
  }

  static Future push(BuildContext context, String path,
      {bool replace = false, bool clearStack = false}) {
    FocusScope.of(context).requestFocus(FocusNode());
    return Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transition: TransitionType.native);
  }

  static pushResult(
      BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Application.router
        .navigateTo(context, path,
            replace: replace,
            clearStack: clearStack,
            transition: TransitionType.native)
        .then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {
      print("$error");
    });
  }

  /// 返回
  static void goBack(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop(context);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, result) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pop(context, result);
  }

  /// 跳到WebView页
  static goWebViewPage(BuildContext context, String title, String urlStr) {
    //fluro 不支持传中文,需转换
    push(context,
        '${Routes.webview}?title=${Uri.encodeComponent(title)}&urlStr=${Uri.encodeComponent(urlStr)}');
  }
}
