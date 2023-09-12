import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/pages/mine/modify_phone_code_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class ModifyPhoneNewPage extends StatefulWidget {
  @override
  _ModifyPhoneNewPageState createState() => _ModifyPhoneNewPageState();
}

class _ModifyPhoneNewPageState extends State<ModifyPhoneNewPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _phoneController = TextEditingController();

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
                  "修改手机号码",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 80),
                DYTextField(
                  fontSize: 24,
                  focusNode: _focusNode,
                  placeholder: "请输入新手机号",
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
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
                title: "获取验证码",
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
    if (_phoneController.text.length != 11) {
      ToastUtils.showInfo("请输入11位有效的手机号");
      return;
    }
    NavigatorUtils.showPage(
      context,
      ModifyPhoneCodePage(
        phoneNo: _phoneController.text,
      ),
    );
  }
}
