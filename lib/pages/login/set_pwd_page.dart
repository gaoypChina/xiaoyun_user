import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/routes/route_export.dart';
import 'package:xiaoyun_user/utils/sp_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/others/divider_input_widget.dart';

class SetPwdPage extends StatefulWidget {
  final bool isFromSetting;
  final int userId;

  const SetPwdPage({Key key, this.userId, this.isFromSetting = false})
      : super(key: key);

  @override
  _SetPwdPageState createState() => _SetPwdPageState();
}

class _SetPwdPageState extends State<SetPwdPage> {
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _pwdConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        actions: [
          if (!widget.isFromSetting)
            NavigationItem(
              title: "跳过",
              onPressed: () {
                SpUtil.putBool(Constant.loginState, true);

                //设置推送别名
                JPush().setAlias(Constant.jpushAliasPre + "${widget.userId}");

                UserEventBus()
                    .fire(UserStateChangedEvent(true, isRegister: true));
                Navigator.popUntil(context, ModalRoute.withName(Routes.main));
              },
            )
        ],
      ),
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
                    "设置密码",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(60)),
                  DividerInputView(
                    placeholder: "请输入密码",
                    obscureText: true,
                    controller: _pwdController,
                  ),
                  SizedBox(height: 10),
                  DividerInputView(
                    placeholder: "请再次输入密码",
                    obscureText: true,
                    controller: _pwdConfirmController,
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
            CommonActionButton(title: "完成", onPressed: _confirmAction),
          ],
        ),
      ),
    );
  }

  void _confirmAction() {
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
    ToastUtils.showLoading("设置中...");
    HttpUtils.post(
      "approve/setPassword.do",
      params: {
        "password": _pwdController.text,
        "repetPassword": _pwdConfirmController.text,
      },
      onSuccess: (resultData) {
        ToastUtils.showSuccess("设置成功");
        if (widget.isFromSetting) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.popUntil(context, ModalRoute.withName(Routes.main));
          });
        } else {
          SpUtil.putBool(Constant.loginState, true);
          //设置推送别名
          JPush().setAlias(Constant.jpushAliasPre + "${widget.userId}");

          Future.delayed(Duration(seconds: 1), () {
            UserEventBus().fire(UserStateChangedEvent(true, isRegister: true));
            Navigator.popUntil(context, ModalRoute.withName(Routes.main));
          });
        }
      },
    );
  }
}
