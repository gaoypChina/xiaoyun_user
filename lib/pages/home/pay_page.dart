import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/order_status_event_bus.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/models/wechat_pay_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/home/pay_success_page.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/others/bottom_button_bar.dart';
import 'package:tobias/tobias.dart' as tobias;
import 'package:fluwx/fluwx.dart';

enum PayType { balance, wechat, alipay }

class PayPage extends StatefulWidget {
  final String orderNo;
  final String money;
  final int? orderId;
  final bool isOtherFee;
  final bool isRecharge;

  const PayPage({
    super.key,
    required this.orderNo,
    required this.money,
    this.orderId,
    this.isOtherFee = false,
    this.isRecharge = false,
  });
  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> with WidgetsBindingObserver {
  PayType _payType = PayType.wechat;
  bool _isPaying = false;
  bool _isWeChatInstalled = false;
  double _balanceValue = 0.00;
  double _moneyValue = 0.0;
  bool _isBalancePay = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _moneyValue = double.tryParse(widget.money) ?? 0.00;
    _initFluwx();
    if (!widget.isRecharge) {
      _getBalance();
    }
  }

  void _initFluwx() async {
    Fluwx fluwx = Fluwx();
    _isWeChatInstalled = await fluwx.isWeChatInstalled;
    // fluwx.weChatResponseEventHandler.listen((res) {
    //   print("res------ ${res.errCode}");
    //   if (res.errCode != 0) {
    //     ToastUtils.showError('支付取消');
    //   }
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isPaying) {
      _checkPaymentStatus();
      print("AppLifecycleState.resumed -------------");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: DYAppBar(
          title: "支付",
        ),
        body: Column(
          children: [
            Expanded(child: _buildSingleChildScrollView()),
            BottomButtonBar(
              title: "确认支付",
              onPressed: _payAction,
            )
          ],
        ),
      ),
      onWillPop: () async {
        DialogUtils.showAlertDialog(
          context,
          message: '您尚未支付，确定要退出支付吗？',
          cancelAction: () {},
          confirmAction: () {
            NavigatorUtils.goBack(context);
          },
        );
        return false;
      },
    );
  }

  void _goToNextPage() {
    if (widget.isRecharge) {
      UserEventBus().fire(UserStateChangedEvent(true));
    } else {
      OrderStatusEventBus().fire(OrderStateChangedEvent());
    }
    if (widget.isOtherFee) {
      ToastUtils.showSuccess("支付成功");
      NavigatorUtils.goBack(context);
      return;
    }
    NavigatorUtils.showPage(
      context,
      PaySuccessPage(
        orderId: widget.orderId??0,
        isRecharge: widget.isRecharge,
      ),
      replace: true,
    );
  }

  Widget _buildSingleChildScrollView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Constant.padding,
        vertical: 40,
      ),
      child: Column(
        children: [
          Text.rich(
            TextSpan(text: "￥", children: [
              TextSpan(
                text: widget.money,
                style: TextStyle(fontSize: 40),
              )
            ]),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "支付金额",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 60),
          CommonCard(
            padding: Constant.horizontalPadding,
            child: Column(
              children: [
                if (!widget.isRecharge)
                  _buildPayTypeWidget(
                    icon: "common_pay_balance",
                    title: "账户余额(￥$_balanceValue)",
                    payType: PayType.balance,
                    disable: _balanceValue <= 0,
                    isChecked: _isBalancePay || _payType == PayType.balance,
                  ),
                _buildPayTypeWidget(
                  icon: "common_pay_wechat",
                  title: "微信支付",
                  payType: PayType.wechat,
                  isChecked: _payType == PayType.wechat,
                ),
                _buildPayTypeWidget(
                  icon: "common_pay_alipay",
                  title: "支付宝支付",
                  payType: PayType.alipay,
                  hiddenDivider: true,
                  isChecked: _payType == PayType.alipay,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayTypeWidget({
    String? icon,
    required String title,
    PayType payType = PayType.wechat,
    bool hiddenDivider = false,
    bool disable = false,
    bool isChecked = false,
  }) {
    String iconName = "common_check_normal";
    if (!disable && isChecked) {
      iconName = "common_check_selected";
    }
    return CommonCellWidget(
      icon: icon,
      title: title,
      iconSize: 28,
      titleWidth: 200,
      titleStyle: TextStyle(
        fontSize: 16,
        color: disable ? DYColors.text_light_gray : DYColors.text_normal,
      ),
      endSolt: DYLocalImage(
        imageName: iconName,
        size: 24,
      ),
      showArrow: false,
      hiddenDivider: hiddenDivider,
      onClicked: () {
        if (disable) {
          return;
        }
        if (_balanceValue < _moneyValue && payType == PayType.balance) {
          setState(() {
            _isBalancePay = !_isBalancePay;
          });
        } else {
          setState(() {
            _payType = payType;
          });
        }
      },
    );
  }

  void _payAction() {
    String payWayCode;
    if (_payType == PayType.alipay) {
      payWayCode = "ALIPAY";
    } else if (_payType == PayType.wechat) {
      payWayCode = "WXPAY";
    } else {
      payWayCode = "BALANCE";
    }
    if (_isBalancePay) {
      payWayCode += ",BALANCE";
    }
    if (_payType == PayType.wechat && !_isWeChatInstalled) {
      ToastUtils.showInfo("未安装微信APP");
      return;
    }
    String netPath =
        widget.isRecharge ? "userHome/payOrder.do" : "order/payOrder.do";
    ToastUtils.showLoading();
    HttpUtils.post(
      netPath,
      params: {"orderNum": widget.orderNo, "payType": payWayCode},
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        _isPaying = true;
        if (_payType == PayType.balance) {
          _checkPaymentStatus();
        } else if (_payType == PayType.alipay) {
          _payWithAliPay(resultData.data);
        } else {
          WechatPayModel payModel = WechatPayModel.fromJson(resultData.data);
          _payWithWechat(payModel);
        }
      },
    );
  }

  void _payWithAliPay(String orderString) async {
    Map payResult;
    try {
      payResult = await tobias.aliPay(orderString);
    } on Exception catch (err) {
      print(err);
      payResult = {};
    }
    if (!mounted) return;

    var resultStatus = payResult['resultStatus'];
    debugPrint('resultStatus ' + resultStatus.toString());
    if (resultStatus == '9000') {
      bool isAliInstalled = await tobias.isAliPayInstalled();
      if (!isAliInstalled) {
        _checkPaymentStatus();
      }
    } else {
      ToastUtils.showError('支付失败');
    }
  }

  void _payWithWechat(WechatPayModel payModel) {
    Fluwx fluwx = Fluwx();
    fluwx.pay(which: Payment(
      appId: payModel.appid,
      partnerId: payModel.partnerid,
      prepayId: payModel.prepayid,
      packageValue: payModel.package,
      nonceStr: payModel.noncestr,
      sign: payModel.sign,
      timestamp: payModel.timestamp,
    )).then((data) {
      debugPrint('data --- $data');
    });
  }

  void _checkPaymentStatus() {
    ToastUtils.showLoading("检查中...");
    HttpUtils.post(
      "order/payQuery.do",
      params: {"orderNum": widget.orderNo, "type": widget.isRecharge ? 1 : 0},
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        int payStatus = resultData.data["payStatus"];
        if (payStatus == 1) {
          _goToNextPage();
        }
      },
    );
  }

  void _getBalance() {
    HttpUtils.get(
      "userHome/getUserBalance.do",
      onSuccess: (resultData) {
        setState(() {
          _balanceValue = double.tryParse(resultData.data["balance"]) ?? 0.00;
        });
      },
    );
  }
}
