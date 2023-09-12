import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/mine/modify_phone_new_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class ModifyPhonePwdPage extends StatefulWidget {
  @override
  _ModifyPhonePwdPageState createState() => _ModifyPhonePwdPageState();
}

class _ModifyPhonePwdPageState extends State<ModifyPhonePwdPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
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
                  "验证密码",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 80),
                DYTextField(
                  fontSize: 24,
                  focusNode: _focusNode,
                  placeholder: "输入密码",
                  controller: _pwdController,
                  obscureText: true,
                )
              ],
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(
                  right: Constant.padding, bottom: Constant.padding),
              alignment: Alignment.centerRight,
              child: CommonActionButton(
                title: "下一步",
                width: 105,
                onPressed: _nextStepAction,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStepAction() {
    if (_pwdController.text.isEmpty) {
      ToastUtils.showInfo("请输入密码");
      return;
    }
    ToastUtils.showLoading();
    HttpUtils.post(
      "user/validUserPass.do",
      params: {"password": _pwdController.text},
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        NavigatorUtils.showPage(context, ModifyPhoneNewPage());
      },
    );
  }
}
