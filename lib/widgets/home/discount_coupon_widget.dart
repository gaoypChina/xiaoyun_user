import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/coupon_model.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/mine/discount_coupon_cell.dart';

class DiscountCouponWidget extends StatelessWidget {
  final List<CouponModel> couponList;
  final Function(CouponModel? couponModel)? onConfirmed;

  const DiscountCouponWidget({super.key, required this.couponList, this.onConfirmed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              CouponModel couponModel = this.couponList[index];
              return GestureDetector(
                child: DiscountCouponCell(
                  bgColor: DYColors.normal_bg,
                  couponModel: couponModel,
                ),
                onTap: () {
                  this.onConfirmed?.call(couponModel);
                  NavigatorUtils.goBack(context);
                },
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemCount: this.couponList.length,
          ),
        ),
        SizedBox(height: 20),
        CommonActionButton(
          title: "不使用优惠券",
          onPressed: () {
            this.onConfirmed?.call(null);
            NavigatorUtils.goBack(context);
          },
        ),
      ],
    );
  }
}
