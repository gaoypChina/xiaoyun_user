import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/coupon_model.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/others/dash_line.dart';

class NewUserCouponCell extends StatelessWidget {
  final CouponModel couponModel;

  const NewUserCouponCell({super.key, required this.couponModel});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      backgroundColor: Color(0xffFFF3E4),
      padding: const EdgeInsets.fromLTRB(15, 12, 12, 12),
      child: Row(
        children: [
          if (this.couponModel.type == 1)
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 75),
              child: Text.rich(
                TextSpan(
                  text: "￥",
                  style: TextStyle(fontSize: 12),
                  children: [
                    TextSpan(
                      text: this.couponModel.moneyMoney,
                      style: TextStyle(fontSize: 32),
                    ),
                  ],
                ),
                style: TextStyle(
                  color: DYColors.text_red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (this.couponModel.type == 1)
            Container(
              height: 48,
              padding: const EdgeInsets.only(right: 20, left: 10),
              child: DashedLine(
                dashWidth: 1,
                dashHeight: 3,
                color: Color(0xffCCCCCC),
                direction: Axis.vertical,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.couponModel.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffA6733F),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 2),
                  child: Text(
                    this.couponModel.type == 1
                        ? "满${this.couponModel.fullMoney}可用"
                        : this.couponModel.remark,
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xffA6713F),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    "有效期至" + this.couponModel.expireTime,
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xffA6713F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
