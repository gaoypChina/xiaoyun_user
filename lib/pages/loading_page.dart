import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/routes/route_export.dart';
import 'package:xiaoyun_user/utils/common_utils.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/others/main_agreement_dialog.dart';
import 'package:fluwx/fluwx.dart';

import '../utils/toast_utils.dart';
import '../utils/sp_utils.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _checkAgreement();
    setupCustomErrorPage();
  }

  void _initDatas() async {
    WidgetsFlutterBinding.ensureInitialized();

    await enableFluttifyLog(false);
    await AmapService.instance.updatePrivacyAgree(true);
    await AmapService.instance.updatePrivacyShow(true);
    await AmapService.instance.init(
      iosKey: Constant.amapIOSKey,
      androidKey: Constant.amapAndroidKey,
    );
    bool result = await Fluwx().registerApi(
      appId: Constant.weChatAppId,
      universalLink: Constant.universalLink,
    );

    print("registerWxApi $result");

    ToastUtils.initialize();
    // RongIMClient.init(Constant.rongAppKey);
    // RongIMClient.setReconnectKickEnable(true);
    _jumpToNewRoute();
  }

  void _checkAgreement() async {
    await SpUtil.getInstance();
    bool agreement = SpUtil.getBool(Constant.agreement);
    Future.delayed(Duration(seconds: 1), () {
      if (!agreement) {
        _showAgreementDialog();
      } else {
        _initDatas();
      }
    });
  }

  void setupCustomErrorPage() {
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
      return Center(
        child: Text(
          '页面出现严重错误，请尝试重启应用',
          textAlign: TextAlign.center,
          style: TextStyle(
            decoration: TextDecoration.none,
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334));
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(
            CommonUtils.getImagePath("launch_bg", "common", format: "jpg"),
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _jumpToNewRoute() async {
    String savedVersion = SpUtil.getString(Constant.bundleVersion);
    final PackageInfo info = await PackageInfo.fromPlatform();
    String currentVersion = info.version;
    if (savedVersion.isNotEmpty && savedVersion == currentVersion) {
      NavigatorUtils.push(context, Routes.main, replace: true, clearStack: true);
    } else {
      //保存新版本
      SpUtil.putString(Constant.bundleVersion, currentVersion);
      //新版本(欢迎页面)
      //新版本每次都重走一次欢迎页
      NavigatorUtils.push(context, Routes.welcome, replace: true, clearStack: true);
    }
  }

  void _showAgreementDialog() async {
    DialogUtils.showCustomDialog(
      context: context,
      child: MainAgreementDialog(
        onConfirmed: () {
          _initDatas();
        },
      ),
    );
  }
}
