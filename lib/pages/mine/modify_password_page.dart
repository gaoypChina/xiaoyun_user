import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/others/divider_input_widget.dart';

class ModifyPasswordPage extends StatefulWidget {
  @override
  _ModifyPasswordPageState createState() => _ModifyPasswordPageState();
}

class _ModifyPasswordPageState extends State<ModifyPasswordPage> {
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _newPwdController = TextEditingController();
  TextEditingController _pwdConfirmController = TextEditingController();

  FocusNode _pwdNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pwdNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Constant.padding),
              children: [
                Text(
                  "修改密码",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                DividerInputView(
                  placeholder: "请输入原密码",
                  controller: _pwdController,
                  obscureText: true,
                  focusNode: _pwdNode,
                ),
                DividerInputView(
                  placeholder: "请输入新密码",
                  controller: _newPwdController,
                  obscureText: true,
                ),
                DividerInputView(
                  placeholder: "请再次输入新密码",
                  controller: _pwdConfirmController,
                  obscureText: true,
                ),
              ],
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(
                  right: Constant.padding, bottom: Constant.padding),
              alignment: Alignment.centerRight,
              child: CommonActionButton(
                title: "确定",
                width: 105,
                onPressed: _confirmBtnClicked,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmBtnClicked() {
    if (_pwdController.text.isEmpty ||
        _pwdConfirmController.text.isEmpty ||
        _newPwdController.text.isEmpty) {
      ToastUtils.showInfo("请输入完整的密码信息");
      return;
    }
    if (_newPwdController.text != _pwdConfirmController.text) {
      ToastUtils.showInfo("两次输入的密码不一致");
      return;
    }
    if (_pwdController.text == _newPwdController.text) {
      ToastUtils.showInfo("新密码不可与旧密码一致");
      return;
    }
    HttpUtils.post(
      "user/updateUserPass.do",
      params: {
        "password": _newPwdController.text,
        "repetPassword": _pwdConfirmController.text,
        "oldPassword": _pwdController.text,
      },
      onSuccess: (resultData) {
        ToastUtils.showSuccess("修改成功");
        Future.delayed(Duration(seconds: 1), () {
          NavigatorUtils.goBack(context);
        });
      },
    );
  }
}
