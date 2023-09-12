import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/coupon_model.dart';
import 'package:xiaoyun_user/models/page_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/mine/invalid_discount_coupon_page.dart';
import 'package:xiaoyun_user/utils/bottom_sheet_utils.dart';
import 'package:xiaoyun_user/utils/common_utils.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_empty_widget.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/mine/discount_coupon_cell.dart';

import 'package:fluwx/fluwx.dart' as fluwx;

import '../../event/user_event_bus.dart';

enum ShareType { wechat, timeline, copy }

class DiscountCouponPage extends StatefulWidget {
  @override
  _DiscountCouponPageState createState() => _DiscountCouponPageState();
}

class _DiscountCouponPageState extends State<DiscountCouponPage> {
  List<CouponModel> _couponList = [];
  TextEditingController _couponController = TextEditingController();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  String _deviceId;

  @override
  void initState() {
    super.initState();
    _loadCouponList();
    _getDeviceId();
  }

  void _getDeviceId() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await _deviceInfo.iosInfo;
      _deviceId = iosDeviceInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await _deviceInfo.androidInfo;
      _deviceId = androidDeviceInfo.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "我的优惠券",
        actions: [
          NavigationItem(
            iconName: "navigation_share",
            onPressed: _showShareDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildListView()),
          SafeArea(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white),
              child: CupertinoButton(
                onPressed: _showExchangeAlert,
                child: Text(
                  "兑换优惠券",
                  style: TextStyle(
                    color: DYColors.text_normal,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(Constant.padding),
      itemBuilder: (context, index) {
        if (_couponList.isEmpty) {
          if (index == 0) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: CommonEmptyWidget(),
            );
          }
        } else {
          if (index < _couponList.length) {
            return DiscountCouponCell(
              couponModel: _couponList[index],
            );
          }
        }
        return CupertinoButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "查看无效券",
                style: TextStyle(fontSize: 11, color: DYColors.text_gray),
              ),
              DYLocalImage(imageName: "common_right_arrow", size: 24),
            ],
          ),
          onPressed: () {
            NavigatorUtils.showPage(context, InvalidDiscountCouponPage());
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: _couponList.isEmpty ? 2 : _couponList.length + 1,
    );
  }

  void _showExchangeAlert() {
    DialogUtils.showAlertDialog(
      context,
      title: "兑换优惠券",
      autoDismiss: false,
      onDissmissCallback: (type) {},
      body: Column(
        children: [
          Text(
            "兑换优惠券",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: DYColors.text_normal,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: SizedBox(
              height: 40,
              child: DYTextField(
                controller: _couponController,
                placeholder: "请输入优惠券兑换码",
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: DYColors.divider,
              ),
            ),
          ),
        ],
      ),
      cancelAction: () {},
      confirmAction: () {
        _exchangeAction();
        _couponController.clear();
        NavigatorUtils.goBack(context);
      },
    );
  }

  void _showShareDialog() {
    BottomSheetUtil.show(
      context,
      height: 150,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "分享到",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShareItem(ShareType.wechat),
                  _buildShareItem(ShareType.timeline),
                  _buildShareItem(ShareType.copy),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareItem(ShareType type) {
    String iconName;
    String title;
    if (type == ShareType.wechat) {
      iconName = "common_share_wechat";
      title = "微信";
    } else if (type == ShareType.timeline) {
      iconName = "common_share_timeline";
      title = "朋友圈";
    } else {
      iconName = "common_share_copy";
      title = "复制链接";
    }
    return GestureDetector(
      child: Column(
        children: [
          DYLocalImage(imageName: iconName, size: 50),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(title),
          ),
        ],
      ),
      onTap: () {
        NavigatorUtils.goBack(context);
        String link = Constant.host + "share/index.html";
        String title = "鲸轿洗车";
        String description = "让洗车更方便，赶快加入我们吧~";
        switch (type) {
          case ShareType.wechat:
            _weChatShare(fluwx.WeChatScene.SESSION, link, title, description);
            break;
          case ShareType.timeline:
            _weChatShare(fluwx.WeChatScene.TIMELINE, link, title, description);
            break;

          case ShareType.copy:
            Clipboard.setData(
              ClipboardData(text: link),
            );
            ToastUtils.showSuccess("复制成功");
            break;
          default:
        }
      },
    );
  }

  void _exchangeAction() {
    if (_couponController.text.isEmpty) {
      ToastUtils.showInfo("请输入优惠券兑换码");
      return;
    }
    HttpUtils.get(
      "userCoupon/toReceiveCoupon.do",
      params: {
        "couponCode": _couponController.text,
        "deviceId": _deviceId ?? ""
      },
      onSuccess: (resultData) {
        ToastUtils.showSuccess("领取成功");
        _loadCouponList();
        Future.delayed(Duration(seconds: 1), () {
          UserEventBus().fire(UserStateChangedEvent(true));
        });
      },
    );
  }

  void _loadCouponList() {
    HttpUtils.get(
      "userCoupon/selectByPage.do",
      params: {"status": 1, "size": 100, "index": 1},
      onSuccess: (resultData) {
        _couponList.clear();
        PageModel pageModel = PageModel.fromJson(resultData.data);
        pageModel.records.forEach((element) {
          _couponList.add(CouponModel.fromJson(element));
        });
        setState(() {});
      },
    );
  }

  void _weChatShare(fluwx.WeChatScene scene, String link, String title,
      String description) async {
    if (!(await fluwx.isWeChatInstalled)) {
      ToastUtils.showInfo("您未安装微信");
      return;
    }
    bool result = await fluwx.shareToWeChat(
      fluwx.WeChatShareWebPageModel(
        link,
        scene: scene,
        title: title,
        description: description,
        thumbnail: fluwx.WeChatImage.asset(
          CommonUtils.getImagePath("common_share_logo", "common"),
        ),
      ),
    );
    if (result) {
      ToastUtils.showSuccess("分享成功");
    } else {
      ToastUtils.showError("分享失败");
    }
  }
}
