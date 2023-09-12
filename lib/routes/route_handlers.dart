import 'package:fluro/fluro.dart';
import 'package:xiaoyun_user/pages/login/login_page.dart';
import 'package:xiaoyun_user/pages/mine/car_add_page.dart';
import 'package:xiaoyun_user/pages/mine/my_car_page.dart';
import 'package:xiaoyun_user/pages/others/common_web_page.dart';

import '../pages/home/notice_page.dart';
import '../pages/main_tab_page.dart';
import '../pages/loading_page.dart';
import '../pages/welcome_page.dart';

var loadingHandler = Handler(handlerFunc: (context, params) => LoadingPage());
var mainHandler = Handler(handlerFunc: (context, params) => MainTabPage());
var welcomeHandler = Handler(handlerFunc: (context, params) => WelcomePage());
var loginHandler = Handler(handlerFunc: (context, params) => LoginPage());
var noticeHandler = Handler(handlerFunc: (context, params) => NoticePage());
var myCarHandler = Handler(handlerFunc: (context, params) => MyCarPage());
var addCarHandler = Handler(handlerFunc: (context, params) => CarAddPage());

var webviewHandler = Handler(handlerFunc: (context, params) {
  String urlStr = params['urlStr']?.first;
  String title = params['title']?.first;
  return CommonWebPage(
    title: title,
    urlStr: urlStr,
  );
});
