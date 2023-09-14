import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ToastUtils {
  static initialize() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 3000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..animationStyle = EasyLoadingAnimationStyle.offset
      ..backgroundColor = Colors.black.withOpacity(0.8)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..progressColor = Colors.white
      ..userInteractions = true;
  }

  static showInfo(String msg) {
    EasyLoading.showInfo(msg);
  }

  static showError(String msg) {
    EasyLoading.showError(msg);
  }

  static showSuccess(String msg) {
    EasyLoading.showSuccess(msg);
  }

  static showLoading([String? msg]) {
    EasyLoading.show(status: msg);
  }

  static showText(String msg) {
    EasyLoading.showToast(msg);
  }

  static dismiss() {
    EasyLoading.dismiss();
  }
}
