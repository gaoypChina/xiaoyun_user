import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/utils/common_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

import '../../models/update_model.dart';
import '../../utils/navigator_utils.dart';

class UpdateDialog extends StatelessWidget {
  final UpdateModel updateModel;
  const UpdateDialog({super.key, required this.updateModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              DYLocalImage(imageName: "common_update_header"),
              Positioned(
                top: 60,
                left: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "发现新版本",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "V${this.updateModel.appVersionNew}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "更新内容",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 20),
                  child: Text(
                    this.updateModel.content,
                    style: TextStyle(
                      fontSize: 13,
                      color: DYColors.text_gray,
                      height: 1.5,
                    ),
                  ),
                ),
                CommonActionButton(
                  title: "立即更新",
                  onPressed: () {
                    CommonUtils.launchWebUrl(this.updateModel.downloadLink);
                  },
                )
              ],
            ),
          ),
          if (!this.updateModel.isForce)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: IconButton(
                icon: DYLocalImage(
                  imageName: "home_new_coupon_close",
                  size: 32,
                ),
                onPressed: () {
                  NavigatorUtils.goBack(context);
                },
              ),
            ),
        ],
      ),
    );
  }
}
