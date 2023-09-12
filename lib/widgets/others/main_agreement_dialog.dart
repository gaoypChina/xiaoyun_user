import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/pages/others/agreement_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/sp_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';

class MainAgreementDialog extends StatelessWidget {
  final Function onConfirmed;

  const MainAgreementDialog({
    Key key,
    this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double contentWidth = 270;
    return Container(
      width: contentWidth,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "服务条款及隐私说明",
            style: TextStyle(
              color: DYColors.text_normal,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Text("感谢您选择鲸轿洗车APP及对鲸轿洗车的信任！"),
          SizedBox(height: 12),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "鲸轿洗车APP的各项内容和服务的所有权归本公司拥有。用户在接受本服务之前，请务必仔细阅读"),
                TextSpan(
                  text: "《用户使用条款》",
                  style: TextStyle(color: Color(0xff007AFF)),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      NavigatorUtils.showPage(
                        context,
                        AgreementPage(
                          title: "用户协议",
                          type: 4,
                        ),
                      );
                    },
                ),
                TextSpan(text: "和"),
                TextSpan(
                  text: "《隐私声明》",
                  style: TextStyle(color: Color(0xff007AFF)),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      NavigatorUtils.showPage(
                        context,
                        AgreementPage(
                          title: "隐私声明",
                          type: 5,
                        ),
                      );
                    },
                ),
                TextSpan(text: "。用户使用服务前，需要同意以上条款，若不同意，将无法使用我们的产品和服务，并会退出应用。"),
              ],
            ),
            style: TextStyle(
              fontSize: 14,
              color: DYColors.text_normal,
              height: 1.6,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonActionButton(
                title: "拒绝",
                radius: 20,
                height: 40,
                titleColor: DYColors.text_gray,
                bgColor: Color(0xffDAE2E9),
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else {
                    ToastUtils.showInfo("好的，请再想想哦~");
                  }
                },
                width: 108,
              ),
              CommonActionButton(
                title: "同意",
                width: 108,
                radius: 20,
                height: 40,
                onPressed: () {
                  SpUtil.putBool(Constant.agreement, true);
                  Navigator.of(context).pop();
                  if (this.onConfirmed != null) {
                    this.onConfirmed();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
