import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/sp_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/slider_bar.dart';
import 'package:xiaoyun_user/widgets/others/divider_input_widget.dart';
import 'package:xiaoyun_user/widgets/others/get_code_btn.dart';

import '../../event/user_event_bus.dart';
import '../../routes/routes.dart';

class AccountBindingPage extends StatefulWidget {
  final String bindId;
  final int type;

  const AccountBindingPage(
      {
        super.key,
        required this.bindId,
        required this.type
      });
  @override
  _AccountBindingPageState createState() => _AccountBindingPageState();
}

class _AccountBindingPageState extends State<AccountBindingPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  bool _verifySuccess = false;
  final GlobalKey<SliderBarState> _sliderBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Constant.padding),
        child: Column(
          children: [
            Padding(
              padding: Constant.horizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "账号绑定",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(60)),
                  DividerInputView(
                    placeholder: "请输入手机号",
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 10),
                  SliderBar(
                    key: _sliderBarKey,
                    width: MediaQuery.of(context).size.width -
                        4 * Constant.padding,
                    onSuccess: () {
                      setState(() {
                        _verifySuccess = true;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DividerInputView(
                    placeholder: "请输入验证码",
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    slot: GetCodeBtn(
                      phoneController: _phoneController,
                      onClicked: (resetTimer) {
                        if (!_verifySuccess) {
                          ToastUtils.showInfo("请先拖动滑块验证");
                          resetTimer();
                          return;
                        }
                        HttpUtils.post(
                          "approve/getSmsCode.do",
                          params: {"cellphone": _phoneController.text},
                          onSuccess: (resultData) {},
                          onError: (msg) {
                            setState(() {
                              _verifySuccess = false;
                            });
                            resetTimer();
                            _sliderBarKey.currentState?.resetWidget();
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
            CommonActionButton(
              title: "确定",
              onPressed: _confirmAction,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmAction() {
    if (_phoneController.text.length != 11) {
      ToastUtils.showInfo("请输入11位有效的手机号");
      return;
    }

    if (_codeController.text.isEmpty) {
      ToastUtils.showInfo("请输入验证码");
      return;
    }
    ToastUtils.showLoading("绑定中...");
    HttpUtils.post(
      "approve/thirdBindCellphone.do",
      params: {
        "bindId": widget.bindId,
        "cellphone": _phoneController.text,
        "smsCode": _codeController.text,
        "type": widget.type,
      },
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        String token = resultData.data["token"];
        SpUtil.putString(Constant.token, token);

        int userId = resultData.data["user"]["id"];

        SpUtil.putBool(Constant.loginState, true);

        //设置推送别名
        JPush().setAlias(Constant.jpushAliasPre + "$userId");

        UserEventBus().fire(UserStateChangedEvent(true, isRegister: true));
        Navigator.popUntil(context, ModalRoute.withName(Routes.main));
      },
    );
  }
}
