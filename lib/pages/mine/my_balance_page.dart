import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/recharge_price_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/home/pay_page.dart';
import 'package:xiaoyun_user/pages/mine/recharge_agreement_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/mine/balance_header_card.dart';
import 'package:xiaoyun_user/widgets/mine/recharge_card.dart';
import 'package:xiaoyun_user/widgets/others/check_button.dart';

class MyBalancePage extends StatefulWidget {
  const MyBalancePage({super.key});

  @override
  State<MyBalancePage> createState() => _MyBalancePageState();
}

class _MyBalancePageState extends State<MyBalancePage> {
  List<RechargePriceModel> _priceList = [];
  int _checkedIndex = -1;
  bool _isAgree = false;
  String _balanceValue = "0.00";

  @override
  void initState() {
    super.initState();
    _getRechargePrice();
    _getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleWidget: Text(
          "账户余额",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: DYColors.primary,
        leading: NavigationItem(
          iconName: "navigation_back_white",
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      body: _buildBodyView(),
    );
  }

  Widget _buildBodyView() {
    return Stack(
      children: [
        Container(height: 100, color: DYColors.primary),
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            BalanceHeaderCard(balanceValue: _balanceValue),
            SizedBox(height: 20),
            _buildRechangeCard(),
            SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: _checkedIndex != -1
                  ? Text(_priceList[_checkedIndex].content)
                  : Container(),
            ),
            CommonActionButton(
              title: "立即充值",
              onPressed: _rechargeAction,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CheckButton(
                  isChecked: _isAgree,
                  title: "我已经阅读并同意",
                  iconSize: 20,
                  style: TextStyle(fontSize: 12, color: DYColors.text_gray),
                  onPressed: () {
                    setState(() {
                      _isAgree = !_isAgree;
                    });
                  },
                ),
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  minSize: 0,
                  child: Text(
                    "《鲸轿洗车充值协议》",
                    style: TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    NavigatorUtils.showPage(context, RechargeAgreementPage());
                  },
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _buildRechangeCard() {
    int columnCount = 3;
    double space = 10.0;
    double cellWidth =
        ((MediaQuery.of(context).size.width - 15 * 4 - 20 - space * 2) /
            columnCount);
    double cellHeight = 60;
    double childAspectRatio = cellWidth / cellHeight;

    return CommonCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "充值",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              mainAxisSpacing: space,
              crossAxisSpacing: space,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              bool isChecked = index == _checkedIndex;
              RechargePriceModel priceItem = _priceList[index];
              return RechargeCard(
                priceItem: priceItem,
                isChecked: isChecked,
                onTap: () {
                  setState(() {
                    _checkedIndex = index;
                  });
                },
              );
            },
            itemCount: _priceList.length,
          )
        ],
      ),
    );
  }

  void _getRechargePrice() {
    ToastUtils.showLoading();
    HttpUtils.post(
      "userHome/getRechargePrice.do",
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        List result = resultData.data;
        setState(() {
          _priceList =
              result.map((e) => RechargePriceModel.fromJson(e)).toList();
        });
      },
    );
  }

  void _rechargeAction() {
    if (_checkedIndex == -1) {
      ToastUtils.showInfo("请选择充值金额");
      return;
    }
    if (!_isAgree) {
      ToastUtils.showInfo("请先阅读并同意充值协议");
      return;
    }
    ToastUtils.showLoading("订单创建中...");
    RechargePriceModel selectedItem = _priceList[_checkedIndex];
    HttpUtils.post(
      "userHome/rechargeBalance.do",
      params: {"rechargePriceId": selectedItem.id},
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        String orderNo = resultData.data["no"];
        String money = resultData.data["payPrice"];
        NavigatorUtils.showPage(
          context,
          PayPage(
            orderNo: orderNo,
            money: money,
            isRecharge: true,
          ),
        );
      },
    );
  }

  void _getBalance() {
    HttpUtils.get(
      "userHome/getUserBalance.do",
      onSuccess: (resultData) {
        setState(() {
          _balanceValue = resultData.data["balance"];
        });
      },
    );
  }
}
