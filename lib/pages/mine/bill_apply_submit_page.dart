import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/bill_title_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/mine/bill_title_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/title_input_field.dart';
import 'package:xiaoyun_user/widgets/others/bottom_button_bar.dart';

class BillApplySubmitPage extends StatefulWidget {
  final String orderIds;
  final String totalMoney;
  final int billType;

  const BillApplySubmitPage({
    Key key,
    @required this.orderIds,
    @required this.totalMoney,
    this.billType = 0,
  }) : super(key: key);

  @override
  _BillApplySubmitPageState createState() => _BillApplySubmitPageState();
}

class _BillApplySubmitPageState extends State<BillApplySubmitPage> {
  TextEditingController _emailController = TextEditingController();
  BillTitleModel _billTitle;

  @override
  void initState() {
    super.initState();
    _getDefaultOrderBill();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "申请发票",
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Constant.padding),
              children: [
                SizedBox(height: 50),
                Text(
                  "发票金额",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: DYColors.text_gray),
                ),
                SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "￥",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: "${widget.totalMoney}",
                        style: TextStyle(fontSize: 40),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 80),
                CommonCard(
                  padding: Constant.horizontalPadding,
                  child: Column(
                    children: [
                      CommonCellWidget(
                        title: "发票抬头",
                        subtitle: _billTitle == null ? "请选择" : _billTitle.title,
                        subtitleStyle: TextStyle(
                          color: _billTitle == null
                              ? DYColors.text_gray
                              : DYColors.text_normal,
                        ),
                        onClicked: () async {
                          BillTitleModel titleModel =
                              await NavigatorUtils.showPage(
                            context,
                            BillTitlePage(
                              isCheckMode: true,
                            ),
                          );
                          if (titleModel != null) {
                            _billTitle = titleModel;
                            setState(() {});
                          }
                        },
                      ),
                      TitleInputField(
                        title: "接收邮箱",
                        placeholder: "请输入邮箱",
                        keyboardType: TextInputType.emailAddress,
                        hiddenDivider: true,
                        controller: _emailController,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          BottomButtonBar(
            title: "确认申请",
            onPressed: _applyAction,
          )
        ],
      ),
    );
  }

  void _applyAction() {
    if (_billTitle == null) {
      ToastUtils.showInfo("请选择发票抬头");
      return;
    }
    if (_emailController.text.isEmpty) {
      ToastUtils.showInfo("请输入接收邮箱");
      return;
    }
    ToastUtils.showLoading("提交中...");
    HttpUtils.post(
      "userBill/addOrderBill.do",
      params: {
        "billHeadId": _billTitle.id,
        "email": _emailController.text,
        "orderIds": widget.orderIds,
        "billType": widget.billType,
      },
      onSuccess: (resultData) {
        ToastUtils.showSuccess("申请成功");
        Future.delayed(Duration(seconds: 1)).then(
          (value) => NavigatorUtils.goBackWithParams(context, true),
        );
      },
    );
  }

  void _getDefaultOrderBill() {
    HttpUtils.get(
      "userBill/defaultOrderBill.do",
      onSuccess: (resultData) {
        _billTitle = BillTitleModel.fromJson(resultData.data);
        if (_billTitle.id == null) {
          _billTitle = null;
        }
        setState(() {});
      },
    );
  }
}
