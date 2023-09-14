import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/routes/route_export.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/others/get_code_btn.dart';

class ModifyPhoneCodePage extends StatefulWidget {
  final String phoneNo;

  const ModifyPhoneCodePage({super.key, required this.phoneNo});

  @override
  _ModifyPhoneCodePageState createState() => _ModifyPhoneCodePageState();
}

class _ModifyPhoneCodePageState extends State<ModifyPhoneCodePage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _codeController = TextEditingController();
  Function? _resetTimerAction;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _getSmsCode();
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
                  "输入验证码",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 80),
                Row(
                  children: [
                    Expanded(
                      child: DYTextField(
                        fontSize: 24,
                        focusNode: _focusNode,
                        placeholder: "请输入验证码",
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                    ),
                    GetCodeBtn(
                      startOnBuild: true,
                      phoneNo: widget.phoneNo,
                      onClicked: (resetTimer) {
                        _resetTimerAction = resetTimer;
                        _getSmsCode();
                      },
                    )
                  ],
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
                title: "确定",
                width: 105,
                onPressed: _confirmAction,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getSmsCode() {
    HttpUtils.post(
      "approve/getSmsCode.do",
      params: {"cellphone": widget.phoneNo, "type": 3},
      onSuccess: (resultData) {},
      onError: (msg) {
        _resetTimerAction?.call();
      },
    );
  }

  void _confirmAction() {
    if (_codeController.text.isEmpty) {
      ToastUtils.showInfo("请输入验证码");
      return;
    }
    ToastUtils.showLoading();
    HttpUtils.post(
      "user/updateUserPhone.do",
      params: {"cellphone": widget.phoneNo, "smsCode": _codeController.text},
      onSuccess: (resultData) {
        ToastUtils.showSuccess("修改成功");
        Future.delayed(Duration(seconds: 1), () {
          Navigator.popUntil(context, ModalRoute.withName(Routes.main));
        });
      },
    );
  }
}
