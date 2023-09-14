import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/pages/login/getback_pwd_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/others/divider_input_widget.dart';

class PasswordLoginWidget extends StatelessWidget {
  final VoidCallback? onExchanged;
  final TextEditingController? accountController;
  final TextEditingController? pwdController;

  const PasswordLoginWidget(
      {super.key, this.onExchanged, this.accountController, this.pwdController});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constant.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "账号密码登录",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: ScreenUtil().setHeight(70)),
          DividerInputView(
            placeholder: "请输入手机号",
            controller: this.accountController,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 10),
          DividerInputView(
            placeholder: "请输入密码",
            controller: this.pwdController,
            obscureText: true,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(35),
                bottom: ScreenUtil().setHeight(55)),
            child: Row(
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      Text(
                        "用手机短信登录",
                        style: TextStyle(fontSize: 14, color: DYColors.primary),
                      ),
                      DYLocalImage(
                        imageName: "login_arrow_right",
                        size: 24,
                      ),
                    ],
                  ),
                  onPressed: this.onExchanged,
                ),
                Spacer(),
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      Text(
                        "找回密码",
                        style: TextStyle(
                            fontSize: 14, color: DYColors.text_normal),
                      ),
                    ],
                  ),
                  onPressed: () {
                    NavigatorUtils.showPage(context, GetBackPwdPage());
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
