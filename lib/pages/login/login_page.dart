import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/login/account_binding_page.dart';
import 'package:xiaoyun_user/pages/login/register_page.dart';
import 'package:xiaoyun_user/pages/others/agreement_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/sp_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/login/authcode_login_widget.dart';
import 'package:xiaoyun_user/widgets/login/password_login_widget.dart';

import 'package:fluwx/fluwx.dart' as fluwx;

import '../../routes/routes.dart';

enum LoginType { authcode, password }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginType _loginType = LoginType.authcode;

  TextEditingController _phoneController;
  TextEditingController _codeController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  bool _isWeChatInstalled = false;
  bool _isSignInAppleAvailable = false;
  bool _isAgree = false;
  StreamSubscription<fluwx.BaseWeChatResponse> _wxlogin;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: SpUtil.getString(Constant.phone),
    );
    _initConfirgure();
  }

  void _initConfirgure() async {
    var result = await fluwx.isWeChatInstalled;
    _isWeChatInstalled = result;
    _isSignInAppleAvailable = await SignInWithApple.isAvailable();
    setState(() {});

    _wxlogin = fluwx.weChatResponseEventHandler.listen((res) {
      print("======weChatResponseEventHandler");
      if (res.errCode != 0) {
        ToastUtils.showError('登录取消');
      } else {
        if (res is fluwx.WeChatAuthResponse) {
          print("weChatResponseEventHandler ：" + res.code.toString());
          String code = res.code;
          _thirdPartLogin(code, 0);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _wxlogin.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        actions: [
          NavigationItem(
            title: "注册",
            onPressed: () {
              NavigatorUtils.showPage(context, RegisterPage());
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constant.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedCrossFade(
                firstChild: AuthCodeLoginWidget(
                  phoneController: _phoneController,
                  codeController: _codeController,
                  onExchanged: () {
                    _loginType = LoginType.password;
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {});
                  },
                ),
                secondChild: PasswordLoginWidget(
                  accountController: _phoneController,
                  pwdController: _pwdController,
                  onExchanged: () {
                    _loginType = LoginType.authcode;
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {});
                  },
                ),
                crossFadeState: _loginType == LoginType.authcode
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 250),
              ),
              CommonActionButton(
                title: "登录",
                onPressed: _loginAction,
              ),
              SizedBox(height: ScreenUtil().setHeight(130)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (_isWeChatInstalled)
                      _thirdPartLoginBtn(
                        "login_wechat",
                        "微信登录",
                        onPressed: _weChatLoginAction,
                      ),
                    if (defaultTargetPlatform == TargetPlatform.iOS &&
                        _isSignInAppleAvailable)
                      _thirdPartLoginBtn(
                        "login_apple",
                        "通过Apple登录",
                        onPressed: _appleLoginAction,
                      ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(55)),
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

  Widget _thirdPartLoginBtn(String icon, String title, {Function onPressed}) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          DYLocalImage(
            imageName: icon,
            size: 50,
          ),
          // SizedBox(height: 8),
          // Text(
          //   title,
          //   style: TextStyle(
          //     fontSize: 14,
          //     color: DYColors.text_normal,
          //   ),
          // )
        ],
      ),
      onPressed: onPressed,
    );
  }

  void _weChatLoginAction() {
    if (!_isWeChatInstalled) {
      ToastUtils.showInfo("未安装微信APP");
      return;
    }
    if (!_isAgree) {
      ToastUtils.showInfo("请先阅读并同意\n用户服务协议和隐私政策");
      return;
    }
    fluwx.sendWeChatAuth(scope: "snsapi_userinfo");
    // NavigatorUtils.showPage(context, AccountBindingPage());
  }

  void _appleLoginAction() async {
    if (!_isAgree) {
      ToastUtils.showInfo("请先阅读并同意\n用户服务协议和隐私政策");
      return;
    }
    AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [],
    );
    String userIdentifier = credential.userIdentifier;
    print(userIdentifier);
    _thirdPartLogin(userIdentifier, 1);
  }

  void _thirdPartLogin(String code, int type) {
    ToastUtils.showLoading("登录中...");
    HttpUtils.post(
      "approve/thirdLogin.do",
      params: {"code": code, "type": type},
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        //审核状态，1：待审核，2：审核通过，3：审核失败,4:手机未绑定,5:密码未设置
        int status = resultData.data["status"];
        String bindId = resultData.data["wxBindId"];
        String token = resultData.data["token"];
        if (status == 2) {
          int userId = resultData.data["user"]["id"];
          _loginSuccessAction(token, userId);
        } else if (status == 4) {
          NavigatorUtils.showPage(
            context,
            AccountBindingPage(type: type, bindId: bindId),
          );
        } else if (status == 5) {
          SpUtil.putString(Constant.token, token);
          int userId = resultData.data["user"]["id"];
          SpUtil.putBool(Constant.loginState, true);

          //设置推送别名
          JPush().setAlias(Constant.jpushAliasPre + "$userId");

          UserEventBus().fire(UserStateChangedEvent(true, isRegister: true));
          Navigator.popUntil(context, ModalRoute.withName(Routes.main));
        }
      },
    );
  }

  void _loginAction() {
    String netPath;
    Map<String, dynamic> params;
    if (_loginType == LoginType.authcode) {
      if (_phoneController.text.length != 11) {
        ToastUtils.showInfo("请输入11位有效的手机号");
        return;
      }
      if (_codeController.text.isEmpty) {
        ToastUtils.showInfo("请输入验证码");
        return;
      }
      netPath = "approve/smsLogin.do";
      params = {
        "cellphone": _phoneController.text,
        "smsCode": _codeController.text
      };
    } else {
      if (_phoneController.text.length != 11) {
        ToastUtils.showInfo("请输入11位有效的手机号");
        return;
      }
      if (_pwdController.text.isEmpty) {
        ToastUtils.showInfo("请输入密码");
        return;
      }
      netPath = "approve/userNamePassLogin.do";
      params = {
        "cellphone": _phoneController.text,
        "password": _pwdController.text
      };
    }
    if (!_isAgree) {
      ToastUtils.showInfo("请先阅读并同意\n用户服务协议和隐私政策");
      return;
    }
    ToastUtils.showLoading("登录中...");
    HttpUtils.post(
      netPath,
      params: params,
      onSuccess: (resultData) {
        String token = resultData.data["token"];
        int userId = resultData.data["user"]["id"];
        _loginSuccessAction(token, userId);
      },
    );
  }

  void _loginSuccessAction(String token, int userId) {
    ToastUtils.showSuccess("登录成功");
    SpUtil.putBool(Constant.loginState, true);
    SpUtil.putString(Constant.phone, _phoneController.text);

    SpUtil.putString(Constant.token, token);

    //设置推送别名
    JPush().setAlias(Constant.jpushAliasPre + "$userId");

    Future.delayed(Duration(seconds: 1), () {
      UserEventBus().fire(UserStateChangedEvent(true));
      NavigatorUtils.goBack(context);
    });
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
