import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'route_handlers.dart';

class Routes {
  static String root = '/';
  static String main = '/main';
  static String welcome = '/welcome';
  static String login = '/login';
  static String webview = '/webview';
  static String notice = '/notice';
  static String myCar = '/myCar';
  static String addCar = '/addCar';

  static void configureRoutes(FluroRouter router) {
    router.define(root, handler: loadingHandler);
    router.define(main, handler: mainHandler);
    router.define(welcome, handler: welcomeHandler);
    router.define(login, handler: loginHandler);
    router.define(webview, handler: webviewHandler);
    router.define(notice, handler: noticeHandler);
    router.define(myCar, handler: myCarHandler);
    router.define(addCar, handler: addCarHandler);

    router.notFoundHandler = Handler(handlerFunc: (context, params) {
      debugPrint("Route Was Not Found !!!");
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('页面发生错误！'),
        ),
      );
    });
  }
}
