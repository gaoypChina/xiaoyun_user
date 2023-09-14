import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/others/agreement_page.dart';
import 'package:xiaoyun_user/routes/route_export.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/sp_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/slider_bar.dart';
import 'package:xiaoyun_user/widgets/others/divider_input_widget.dart';
import 'package:xiaoyun_user/widgets/others/get_code_btn.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _pwdConfirmController = TextEditingController();

  bool _verifySuccess = false;
  final GlobalKey<SliderBarState> _sliderBarKey = GlobalKey();

  bool _isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constant.padding),
          child: Column(
            children: [
              Padding(
                padding: Constant.horizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "注册",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      slot: Row(
                        children: [
                          GetCodeBtn(
                            phoneController: _phoneController,
                            onClicked: (resetTimer) {
                              if (!_verifySuccess) {
                                ToastUtils.showInfo("请先拖动滑块验证");
                                resetTimer();
                                return;
                              }
                              HttpUtils.post(
                                "approve/getSmsCode.do",
                                params: {
                                  "cellphone": _phoneController.text,
                                  "type": 0
                                },
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
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    DividerInputView(
                      placeholder: "请输入密码",
                      controller: _pwdController,
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    DividerInputView(
                      placeholder: "请再次输入密码",
                      controller: _pwdConfirmController,
                      obscureText: true,
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
              CommonActionButton(
                title: "注册",
                onPressed: _registerAction,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      children: [
                        DYLocalImage(
                          imageName: _isAgree
                              ? "common_check_selected"
                              : "common_check_normal",
                          size: 24,
                        ),
                        Text(
                          "我已经同意",
                          style: TextStyle(
                            fontSize: 12,
                            color: DYColors.text_normal,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        _isAgree = !_isAgree;
                      });
                    },
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "用户服务协议",
                      style: TextStyle(fontSize: 12, color: DYColors.primary),
                    ),
                    onPressed: () {
                      _showAgreement("用户协议", 4);
                    },
                  ),
                  Text(
                    "和",
                    style: TextStyle(fontSize: 12),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "隐私政策",
                      style: TextStyle(fontSize: 12, color: DYColors.primary),
                    ),
                    onPressed: () {
                      _showAgreement("隐私政策", 5);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _registerAction() {
    if (_phoneController.text.length != 11) {
      ToastUtils.showInfo("请输入11位有效的手机号");
      return;
    }
    if (_codeController.text.isEmpty) {
      ToastUtils.showInfo("请输入验证码");
      return;
    }
    if (_pwdController.text.isEmpty) {
      ToastUtils.showInfo("请输入密码");
      return;
    }
    if (_pwdConfirmController.text.isEmpty) {
      ToastUtils.showInfo("请再次输入密码");
      return;
    }
    if (_pwdController.text != _pwdConfirmController.text) {
      ToastUtils.showInfo("两次输入的密码不一致");
      return;
    }
    if (!_isAgree) {
      ToastUtils.showInfo("请先阅读并同意\n用户服务协议和隐私政策");
      return;
    }
    ToastUtils.showLoading("注册中...");
    HttpUtils.post(
      "approve/register.do",
      params: {
        "cellphone": _phoneController.text,
        "smsCode": _codeController.text,
        "password": _pwdController.text,
        "repetPassword": _pwdConfirmController.text,
      },
      onSuccess: (resultData) {
        ToastUtils.showSuccess("注册成功");
        SpUtil.putBool(Constant.loginState, true);
        SpUtil.putString(Constant.phone, _phoneController.text);

        String token = resultData.data["token"];
        SpUtil.putString(Constant.token, token);

        //设置推送别名
        int userId = resultData.data["user"]["id"];
        JPush().setAlias(Constant.jpushAliasPre + "$userId");

        Future.delayed(Duration(seconds: 1), () {
          UserEventBus().fire(UserStateChangedEvent(true, isRegister: true));
          Navigator.popUntil(context, ModalRoute.withName(Routes.main));
        });
      },
    );
  }

  void _showAgreement(String title, int type) {
    NavigatorUtils.showPage(
      context,
      AgreementPage(
        title: title,
        type: type,
      ),
    );
  }
}
