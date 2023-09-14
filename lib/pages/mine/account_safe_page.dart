import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/routes/route_export.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/sp_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

import '../login/set_pwd_page.dart';
import 'modify_password_page.dart';

class AccountSafePage extends StatefulWidget {
  final bool hasPwd;
  const AccountSafePage({super.key, required this.hasPwd});

  @override
  _AccountSafePageState createState() => _AccountSafePageState();
}

class _AccountSafePageState extends State<AccountSafePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(title: "账号安全"),
      body: ListView(
        padding: const EdgeInsets.all(Constant.padding),
        children: [
          CommonCard(
            padding: Constant.horizontalPadding,
            child: Column(
              children: [
                CommonCellWidget(
                  title: widget.hasPwd ? "修改账号密码" : "设置账号密码",
                  hiddenDivider: TargetPlatform.iOS == defaultTargetPlatform,
                  onClicked: () {
                    if (widget.hasPwd) {
                      NavigatorUtils.showPage(context, ModifyPasswordPage());
                    } else {
                      NavigatorUtils.showPage(
                        context,
                        SetPwdPage(isFromSetting: true),
                      );
                    }
                  },
                ),
                // CommonCellWidget(
                //   title: "支付密码",
                //   onClicked: () {
                //     if (widget.hasPwd) {
                //       NavigatorUtils.showPage(context, ModifyPasswordPage());
                //     } else {
                //       NavigatorUtils.showPage(
                //         context,
                //         SetPwdPage(isFromSetting: true),
                //       );
                //     }
                //   },
                // ),
                if (TargetPlatform.android == defaultTargetPlatform)
                  CommonCellWidget(
                    title: "注销账号",
                    subtitle: "注销后无法恢复，请谨慎操作",
                    subtitleStyle: TextStyle(fontSize: 12),
                    hiddenDivider: true,
                    onClicked: () {
                      DialogUtils.showActionSheetDialog(
                        context,
                        message: "注销后无法恢复，请谨慎操作，确定要这样做吗？",
                        dialogItems: [
                          ActionSheetDialogItem(
                            title: "确认注销",
                            isDestructiveAction: true,
                            onPressed: _cancelAccountAction,
                          ),
                        ],
                      );
                    },
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _cancelAccountAction() {
    ToastUtils.showLoading("注销中...");
    HttpUtils.post(
      "user/userLogout.do",
      onSuccess: (resultData) {
        bool result = resultData.data;
        if (result) {
          ToastUtils.showSuccess("注销成功");
          Future.delayed(Duration(seconds: 1), () {
            SpUtil.putBool(Constant.loginState, false);
            UserEventBus().fire(UserStateChangedEvent(false));
            JPush().deleteAlias();
            Navigator.popUntil(context, ModalRoute.withName(Routes.main));
          });
        } else {
          ToastUtils.showInfo(resultData.msg??'未知错误');
        }
      },
    );
  }
}
