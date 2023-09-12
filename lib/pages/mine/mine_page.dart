import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/models/service_phone_model.dart';
import 'package:xiaoyun_user/models/user_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/mine/contact_info_page.dart';
import 'package:xiaoyun_user/pages/mine/discount_coupon_page.dart';
import 'package:xiaoyun_user/pages/mine/my_balance_page.dart';
import 'package:xiaoyun_user/pages/order/after_sale_page.dart';
import 'package:xiaoyun_user/pages/mine/bill_page.dart';
import 'package:xiaoyun_user/pages/mine/setting_page.dart';
import 'package:xiaoyun_user/routes/route_export.dart';
import 'package:xiaoyun_user/utils/common_utils.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_network_image.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';

import '../../widgets/common/custom_app_bar.dart';
import 'feedback_page.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController = RefreshController();
  UserModel _userInfo;
  StreamSubscription _subscription;
  List<ServicePhoneModel> _servicePhoneList = [];
  String _balance = "0.00";
  int _couponCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserAndCarInfo();
    _subscription = UserEventBus().on<UserStateChangedEvent>().listen((event) {
      bool isLogin = event.isLogin;
      if (isLogin) {
        _loadUserAndCarInfo();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DYAppBar(
        showBack: false,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          _buidTopActions(),
        ],
      ),
      body: CommonRefresher(
        scrollView: _buildListView(),
        controller: _refreshController,
        onRefresh: () {
          _loadUserAndCarInfo();
        },
      ),
    );
  }

  ListView _buildListView() {
    return ListView(
      children: [
        _buildHeaderWidget(),
        SizedBox(height: 12),
        _buildServiceManageWidget(),
        SizedBox(height: 12),
        _buildMoreServeWidget(),
      ],
    );
  }

  Widget _buidTopActions() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(
        top: 20,
        right: Constant.padding,
      ),
      child: Row(
        children: [
          _buildNavigationItem(
            icon: "mine_home_message",
            onPressed: () {
              NavigatorUtils.push(context, Routes.notice);
            },
          ),
          Container(
            width: 1,
            height: 10,
            color: Colors.white,
          ),
          _buildNavigationItem(
            icon: "mine_home_setting",
            onPressed: () {
              NavigatorUtils.showPage(context, SettingPage());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({String icon, Function onPressed}) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      minSize: 36,
      child: DYLocalImage(
        imageName: icon,
        size: 24,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildServiceManageWidget() {
    return CommonCard(
      padding: Constant.horizontalPadding,
      margin: Constant.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Constant.padding),
          Text(
            "服务管理",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceItem(
                icon: "mine_home_car",
                title: "我的车库",
                onPressed: () {
                  NavigatorUtils.push(context, Routes.myCar);
                },
              ),
              _buildServiceItem(
                icon: "mine_home_contact",
                title: "常用联系人",
                onPressed: () {
                  NavigatorUtils.showPage(context, ContactInfoPage());
                },
              ),
              _buildServiceItem(
                icon: "mine_home_after_sale",
                title: "售后记录",
                onPressed: () {
                  NavigatorUtils.showPage(context, AfterSalePage());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem({String icon, String title, Function onPressed}) {
    return CupertinoButton(
      child: Column(
        children: [
          DYLocalImage(
            imageName: icon,
            size: 32,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: DYColors.text_normal,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildMoreServeWidget() {
    return CommonCard(
      padding:
          const EdgeInsets.symmetric(horizontal: Constant.padding, vertical: 8),
      margin: Constant.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCellItem(
            "mine_cell_recharge",
            "会员充值",
            onPressed: () {
              NavigatorUtils.showPage(context, MyBalancePage());
            },
          ),
          _buildCellItem(
            "mine_cell_bill",
            "申请开票",
            onPressed: () {
              NavigatorUtils.showPage(context, BillPage());
            },
          ),
          _buildCellItem(
            "mine_cell_service",
            "联系客服",
            onPressed: () {
              if (_servicePhoneList.isEmpty) {
                _getCustomerPhoneList();
              } else {
                _showPhoneDialog();
              }
            },
          ),
          _buildCellItem(
            "mine_cell_feedback",
            "意见反馈",
            onPressed: () {
              NavigatorUtils.showPage(context, FeedbackPage());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCellItem(String icon, String title, {Function onPressed}) {
    return CommonCellWidget(
      padding: const EdgeInsets.symmetric(vertical: 10),
      icon: icon,
      iconSize: 24,
      title: title,
      hiddenDivider: true,
      onClicked: onPressed,
    );
  }

  Widget _buildHeaderWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: Constant.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + kToolbarHeight,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 12),
            child: Row(
              children: [
                _buildUserHeader(),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    _userInfo?.nickname ?? "未设置",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildBalanceAndCouponCard(),
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/mine/mine_home_bg.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildBalanceAndCouponCard() {
    return Stack(
      children: [
        DYLocalImage(
          imageName: "mine_home_middle_bg",
          height: 94,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Container(
          height: 94,
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Expanded(
                child: _buildHeaderBtn(
                  title: "我的余额",
                  value: _balance,
                  icon: "mine_home_balance",
                  onPressed: () {
                    NavigatorUtils.showPage(context, MyBalancePage());
                  },
                ),
              ),
              Container(width: 1, height: 20, color: Colors.white),
              Expanded(
                child: _buildHeaderBtn(
                  title: "优惠券(张)",
                  value: "$_couponCount",
                  icon: "mine_home_coupon",
                  onPressed: () {
                    NavigatorUtils.showPage(context, DiscountCouponPage());
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderBtn(
      {String title, String value, String icon, Function onPressed}) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          DYLocalImage(imageName: icon, size: 36),
        ],
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildUserHeader() {
    Widget userDefault = DYLocalImage(
      imageName: "common_user_header",
      size: 60,
    );
    if (_userInfo != null &&
        _userInfo.avatarImgUrl != null &&
        _userInfo.avatarImgUrl.isNotEmpty) {
      return ClipOval(
        child: DYNetworkImage(
          imageUrl: _userInfo.avatarImgUrl,
          placeholder: userDefault,
          size: 60,
        ),
      );
    }
    return userDefault;
  }

  void _loadUserAndCarInfo() async {
    ToastUtils.showLoading();
    await _loadUserInfo();
    _getBalance();
    _refreshController.refreshCompleted();
    ToastUtils.dismiss();
  }

  Future _loadUserInfo() async {
    return await HttpUtils.get(
      "user/userDetail.do",
      onSuccess: (resultData) {
        _userInfo = UserModel.fromJson(resultData.data);
        setState(() {});
      },
    );
  }

  void _getCustomerPhoneList() {
    ToastUtils.showLoading("加载中...");
    HttpUtils.get(
      "user/getCustomerServiceTelephone.do",
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        List phoneList = resultData.data;
        _servicePhoneList =
            phoneList.map((e) => ServicePhoneModel.fromJson(e)).toList();
        if (_servicePhoneList.isEmpty) {
          ToastUtils.showInfo("暂时无法联系客服，请稍后再试");
        } else {
          _showPhoneDialog();
        }
      },
    );
  }

  void _getBalance() {
    HttpUtils.get(
      "userHome/getUserBalance.do",
      onSuccess: (resultData) {
        setState(() {
          _balance = resultData.data["balance"];
          _couponCount = resultData.data["count"];
        });
      },
    );
  }

  void _showPhoneDialog() {
    DialogUtils.showActionSheetDialog(
      context,
      dialogItems: _servicePhoneList
          .map(
            (phoneModel) => ActionSheetDialogItem(
              title: "${phoneModel.name} ${phoneModel.phone}",
              onPressed: () {
                CommonUtils.launchTelUrl(phoneModel.phone);
              },
            ),
          )
          .toList(),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
