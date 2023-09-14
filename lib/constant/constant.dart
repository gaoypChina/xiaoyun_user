import 'package:flutter/material.dart';

class Constant {
  static const String loginState = 'LoginState';
  static const String imUserId = 'IMUserID';
  static const String token = 'UserToken';
  static const String bundleVersion = "BundleVersion";
  static const String phone = 'Phone';
  static const String latLng = "latitudeLongitude";
  static const String agreement = "Agreement";

  static const double padding = 16;
  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: 16);

  static const String universalLink = "https://www.jingjiaowow.com/";
  static const String weChatAppId = "wx26c0ce7dc3abcbdd";

  static const String amapIOSKey = "e486bdc5f1926cbf688138bbfd484d12";
  static const String amapAndroidKey = "41d3ae27b4fcdc4746170f49ae026441";
  static const String jpushIOSKey = "678f20dff94f6e228c61f3d8";

  //正式环境
  static const String host = 'http://api.user.jingjiaowow.com/washer-user/';
  static const String rongAppKey = "4z3hlwrv42x2t";
  static const String jpushAliasPre = "user_";
  //测试环境
  // static const String host = 'http://java.b.dyuit.cn/xiaoyun-api/washer-user/';
  // static const String rongAppKey = "pwe86ga5pst96";
  // static const String jpushAliasPre = "test_user_";

  static const String baseUrl = host + 'api/';
  static const String webUrl = host + 'html/';
}

//常用颜色
class DYColors {
  static const Color primary = Color(0xff00A2FF);
  static const Color background = Color(0xffF7F8FA);
  static const Color search_bar = Color(0xffF6F7FA);
  static const Color normal_bg = Color(0xffF6F7FA);
  static const Color app_bar = Color(0xffF7F8FA);
  static const Color icon = Color(0xff25292C);
  static const Color yellowDot = Color(0xffFEC221);
  static const Color divider = Color(0xffEDEDED);
  static const Color text_normal = Color(0xff25292C);
  static const Color text_dark_gray = Color(0xff666666);
  static const Color text_gray = Color(0xff818484);
  static const Color text_light_gray = Color(0xff939496);
  static const Color text_red = Color(0xffE8684A);
}
