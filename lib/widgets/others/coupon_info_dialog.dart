import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/models/coupon_model.dart';
import 'package:xiaoyun_user/widgets/others/dash_line.dart';

import '../../utils/navigator_utils.dart';
import '../common/common_local_image.dart';

class CouponInfoDialog extends StatelessWidget {
  final CouponModel coupon;
  final Function()? onAction;
  const CouponInfoDialog({super.key, required this.coupon, this.onAction});

  @override
  Widget build(BuildContext context) {
    String activityStatus = "";
    if (this.coupon.activityStatus == 2) {
      activityStatus = "活动已结束";
    } else if (this.coupon.activityStatus == 3) {
      activityStatus = "活动未开始";
    } else {
      activityStatus = "很遗憾，优惠券已抢完";
    }
    return Container(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              DYLocalImage(
                imageName: "mine_coupon_dialog_bg",
              ),
              Container(
                width: 200,
                margin: const EdgeInsets.only(top: 80),
                padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                child: Row(
                  children: [
                    if (this.coupon.type == 1)
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "￥",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffD15737),
                              ),
                            ),
                            Text(
                              "${this.coupon.money}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffD15737),
                              ),
                            ),
                            Container(
                              height: 40,
                              padding: const EdgeInsets.only(left: 9),
                              child: DashedLine(
                                dashWidth: 1,
                                dashHeight: 3,
                                color: Color(0xffD45F3C),
                                direction: Axis.vertical,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            this.coupon.title,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xffD5623E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            this.coupon.type == 1
                                ? "满${this.coupon.full}可用"
                                : this.coupon.remark,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff6D1D0D).withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xffFFF3E4),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Positioned(
                bottom: 35,
                child: SizedBox(
                  width: 215,
                  height: 45,
                  child: this.coupon.activityStatus == 1
                      ? CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          child: DYLocalImage(
                            imageName: "home_new_coupon_btn",
                          ),
                          onPressed: () {
                            NavigatorUtils.goBack(context);
                            this.onAction?.call();
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            activityStatus,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffFFF3E4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
            ],
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
}
