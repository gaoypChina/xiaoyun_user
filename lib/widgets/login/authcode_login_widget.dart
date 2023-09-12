import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/slider_bar.dart';
import 'package:xiaoyun_user/widgets/others/divider_input_widget.dart';
import 'package:xiaoyun_user/widgets/others/get_code_btn.dart';

class AuthCodeLoginWidget extends StatefulWidget {
  final Function onExchanged;
  final TextEditingController phoneController;
  final TextEditingController codeController;

  const AuthCodeLoginWidget(
      {Key key, this.onExchanged, this.phoneController, this.codeController})
      : super(key: key);
  @override
  _AuthCodeLoginWidgetState createState() => _AuthCodeLoginWidgetState();
}

class _AuthCodeLoginWidgetState extends State<AuthCodeLoginWidget> {
  bool _verifySuccess = false;
  final GlobalKey<SliderBarState> _sliderBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constant.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "验证码登录",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: ScreenUtil().setHeight(70)),
          DividerInputView(
            placeholder: "请输入手机号",
            controller: widget.phoneController,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 10),
          SliderBar(
            key: _sliderBarKey,
            width: MediaQuery.of(context).size.width - 4 * Constant.padding,
            onSuccess: () {
              setState(() {
                _verifySuccess = true;
              });
            },
          ),
          SizedBox(height: 10),
          DividerInputView(
            placeholder: "请输入验证码",
            controller: widget.codeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            slot: Row(
              children: [
                GetCodeBtn(
                  phoneController: widget.phoneController,
                  onClicked: (resetTimer) {
                    if (!_verifySuccess) {
                      ToastUtils.showInfo("请先拖动滑块验证");
                      resetTimer();
                      return;
                    }
                    HttpUtils.post(
                      "approve/getSmsCode.do",
                      params: {
                        "cellphone": widget.phoneController.text,
                        "type": 1
                      },
                      onSuccess: (resultData) {},
                      onError: (msg) {
                        setState(() {
                          _verifySuccess = false;
                        });
                        resetTimer();
                        _sliderBarKey.currentState.resetWidget();
                      },
                    );
                  },
                )
              ],
            ),
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
                        "用账号密码登录",
                        style: TextStyle(fontSize: 14, color: DYColors.primary),
                      ),
                      DYLocalImage(
                        imageName: "login_arrow_right",
                        size: 24,
                      ),
                    ],
                  ),
                  onPressed: widget.onExchanged,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
