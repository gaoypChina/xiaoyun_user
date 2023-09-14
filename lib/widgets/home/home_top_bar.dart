import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/routes/route_export.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/sp_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

import 'home_action_btn.dart';

class HomeTopBar extends StatelessWidget {
  final String city;
  final VoidCallback? onCityPressed;
  final VoidCallback? onScanAction;

  const HomeTopBar({
    super.key,
    required this.city,
    this.onCityPressed,
    this.onScanAction,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 36,
              child: CupertinoButton(
                minSize: 0,
                color: Colors.white,
                padding: const EdgeInsets.only(left: 12, right: 8),
                borderRadius: BorderRadius.circular(18),
                child: Row(
                  children: [
                    DYLocalImage(
                      imageName: "home_city_icon",
                      width: 14,
                      height: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      this.city,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: DYColors.text_normal,
                      ),
                    ),
                    DYLocalImage(
                      imageName: "common_right_arrow",
                      size: 24,
                    ),
                  ],
                ),
                onPressed: this.onCityPressed,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: DYColors.text_dark_gray.withOpacity(0.2),
                    offset: Offset(0, 10),
                    blurRadius: 20,
                  )
                ],
              ),
            ),
            Spacer(),
            HomeActionBtn(
              imageName: "home_scan_icon",
              onPressed: this.onScanAction,
            ),
            SizedBox(width: 15),
            HomeActionBtn(
              imageName: "home_message_icon",
              onPressed: () {
                bool isLogin = SpUtil.getBool(Constant.loginState);
                if (!isLogin) {
                  NavigatorUtils.push(context, Routes.login);
                  return;
                }
                NavigatorUtils.push(context, Routes.notice);
              },
            ),
          ],
        ),
      ),
    );
  }
}
