import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:package_info/package_info.dart';
// import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/models/update_model.dart';
import 'package:xiaoyun_user/models/user_info.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
// import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/order/order_page.dart';
import 'package:xiaoyun_user/routes/routes.dart';
import 'package:xiaoyun_user/utils/db_utils.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/sp_utils.dart';
import 'package:xiaoyun_user/widgets/others/bottom_tab_bar.dart';
import 'package:xiaoyun_user/widgets/others/update_dialog.dart';
import '../utils/toast_utils.dart';
import 'home/home_page.dart';
import 'mine/mine_page.dart';

class MainTabPage extends StatefulWidget {
  @override
  _MainTabPageState createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _currentIndex = 0;
  int _exitTime = 0;
  StreamSubscription _subscription;

  final PageController _pageController = PageController();
  List<Widget> _bodyList = [HomePage(), OrderPage(), MinePage()];
  List<BottomTabBarItem> _itemList = [
    BottomTabBarItem(
        iconName: "tab_home", activeIconName: "tab_home_sel", name: "首页"),
    BottomTabBarItem(
        iconName: "tab_order", activeIconName: "tab_order_sel", name: "订单"),
    BottomTabBarItem(
        iconName: "tab_mine", activeIconName: "tab_mine_sel", name: "我的"),
  ];

  @override
  void initState() {
    super.initState();
    _initUserInfoCache();

    _subscription = UserEventBus().on<UserStateChangedEvent>().listen((event) {
      bool isLogin = event.isLogin;
      if (isLogin) {
        // _connectRongIM();
      } else {
        _pageController.jumpTo(0);
      }
    });
    bool isLogin = SpUtil.getBool(Constant.loginState);
    if (isLogin) {
      // _connectRongIM();
    }
    _initJpushState();

    Future.delayed(Duration(seconds: 3), () {
      _getVersion();
    });
  }

  Future<void> _initJpushState() async {
    JPush jpush = JPush();

    jpush.setup(
      appKey: Constant.jpushIOSKey,
      channel: "App Store",
      production: true,
      debug: true,
    );
    jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        debugPrint("flutter onReceiveNotification: $message");
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        debugPrint("flutter onOpenNotification: $message");
        jpush.setBadge(0).then((map) {});
        handleNotificationMessage(message);
      },

      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        debugPrint("flutter onReceiveMessage: $message");
      },
    );
    jpush.applyPushAuthority(
      NotificationSettingsIOS(sound: true, alert: true, badge: true),
    );
    if (Platform.isIOS) {
      jpush.setBadge(0).then((map) {});
      jpush.getLaunchAppNotification().then((message) {
        print('getLaunchAppNotification message : $message');
        jpush.setBadge(0).then((map) {});
        if (message.isNotEmpty) {
          handleNotificationMessage(message);
        }
      });
    }
  }

  void handleNotificationMessage(Map<String, dynamic> message) {
    Map extraData = message['extras'];
    int actionType = extraData['actionType'];

    bool isLogin = SpUtil.getBool(Constant.loginState);
    if (!isLogin) {
      return;
    }
    if (actionType == 1) {}
  }

  // void _connectRongIM() {
  //   HttpUtils.get("user/rongToken.do", onSuccess: (resultData) {
  //     RongIMClient.disconnect(false);
  //     String token = resultData.data["token"];
  //     RongIMClient.connect(token, (int code, String userId) {
  //       print('connect result ' + code.toString());
  //       SpUtil.putString(Constant.imUserId, userId);
  //       UserInfoDataSource.getUserInfo(userId);
  //     });
  //   });
  // }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // 初始化用户信息缓存
  void _initUserInfoCache() {
    DbUtils.instance.openDb();
    UserInfoCacheListener cacheListener = UserInfoCacheListener();
    cacheListener.getUserInfo = (String userId) async {
      return await UserInfoDataSource.fetchUserInfo(userId);
    };
    UserInfoDataSource.setCacheListener(cacheListener);
  }

  void _getVersion() {
    int type = Platform.isIOS ? 0 : 1;
    HttpUtils.get(
      "approve/appVersion.do",
      params: {"type": type},
      onSuccess: (resultData) async {
        var data = resultData.data;
        if (data == null) return;
        UpdateModel updateModel = UpdateModel.fromJson(resultData.data);
        final PackageInfo info = await PackageInfo.fromPlatform();
        String currentVersion = info.version;
        if (updateModel.appVersionNew.compareTo(currentVersion) == 1) {
          DialogUtils.showCustomDialog(
            context: context,
            backgroundColor: Colors.transparent,
            child: UpdateDialog(
              updateModel: updateModel,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime dateTime = DateTime.now();
        if (dateTime.millisecondsSinceEpoch - _exitTime > 3000) {
          ToastUtils.showText("再按一次将退出鲸轿洗车");
          _exitTime = dateTime.millisecondsSinceEpoch;
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor:
            _currentIndex == 0 ? Colors.white : DYColors.background,
        body: PageView(
          children: _bodyList,
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            if (index == _currentIndex) return;
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomTabBar(
          currentIndex: _currentIndex,
          tabBarItems: _itemList,
          onTap: (index) {
            bool isLogin = SpUtil.getBool(Constant.loginState);
            if (index > 0 && !isLogin) {
              NavigatorUtils.push(context, Routes.login);
              return;
            }
            _pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
