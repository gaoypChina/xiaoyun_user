import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/models/coupon_model.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

import 'new_user_coupon_cell.dart';

class NewUserCouponDialog extends StatelessWidget {
  final List<CouponModel> couponList;

  const NewUserCouponDialog({super.key, required this.couponList});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DYLocalImage(
            imageName: "home_new_coupon_header",
            width: 300,
          ),
          Container(
            width: 290,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 16),
            child: Column(
              children: [
                ..._buildCouponWidgetList(),
                SizedBox(height: 8),
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: DYLocalImage(
                    imageName: "home_new_coupon_btn",
                  ),
                  onPressed: () {
                    NavigatorUtils.goBack(context);
                  },
                ),
                SizedBox(height: 8),
                Text(
                  "可在“我的-优惠券”中查看",
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xffF1C5A2),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xffEE4544),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 40),
          IconButton(
            icon: DYLocalImage(
              imageName: "home_new_coupon_close",
              size: 32,
            ),
            onPressed: () {
              NavigatorUtils.goBack(context);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCouponWidgetList() {
    return List.generate(this.couponList.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: NewUserCouponCell(
          couponModel: this.couponList[index],
        ),
      );
    });
  }
}
