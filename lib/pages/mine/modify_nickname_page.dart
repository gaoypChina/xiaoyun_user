import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class ModifyNicknamePage extends StatefulWidget {
  @override
  _ModifyNicknamePageState createState() => _ModifyNicknamePageState();
}

class _ModifyNicknamePageState extends State<ModifyNicknamePage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _nicknameController = TextEditingController();

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
                  "修改昵称",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 80),
                DYTextField(
                  fontSize: 24,
                  focusNode: _focusNode,
                  placeholder: "请输入昵称",
                  controller: _nicknameController,
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
                title: "保存",
                width: 105,
                onPressed: _saveAction,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveAction() {
    if (_nicknameController.text.isEmpty) {
      ToastUtils.showInfo("请输入昵称");
      return;
    }
    ToastUtils.showLoading("保存中...");
    HttpUtils.post(
      "user/updateUser.do",
      params: {"nickName": _nicknameController.text, "type": 0},
      onSuccess: (resultData) {
        ToastUtils.showSuccess("修改成功");
        Future.delayed(Duration(seconds: 1), () {
          UserEventBus().fire(UserStateChangedEvent(true));
          NavigatorUtils.goBackWithParams(context, _nicknameController.text);
        });
      },
    );
  }
}
