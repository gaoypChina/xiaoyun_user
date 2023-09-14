import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/slider_bar.dart';
import 'package:xiaoyun_user/widgets/others/divider_input_widget.dart';
import 'package:xiaoyun_user/widgets/others/get_code_btn.dart';

class GetBackPwdPage extends StatefulWidget {
  @override
  _GetBackPwdPageState createState() => _GetBackPwdPageState();
}

class _GetBackPwdPageState extends State<GetBackPwdPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  bool _verifySuccess = false;
  final GlobalKey<SliderBarState> _sliderBarKey = GlobalKey();

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
                      "找回密码",
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
                                  "type": 2
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
                      obscureText: true,
                      controller: _pwdController,
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
              CommonActionButton(title: "重置密码", onPressed: _resetAction),
            ],
          ),
        ),
      ),
    );
  }

  void _resetAction() {
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

    ToastUtils.showLoading("重置中...");
    HttpUtils.post(
      "approve/findPass.do",
      params: {
        "cellphone": _phoneController.text,
        "smsCode": _codeController.text,
        "password": _pwdController.text,
      },
      onSuccess: (resultData) {
        ToastUtils.showSuccess("重置成功");
        Future.delayed(Duration(seconds: 1), () {
          NavigatorUtils.goBack(context);
        });
      },
    );
  }
}
