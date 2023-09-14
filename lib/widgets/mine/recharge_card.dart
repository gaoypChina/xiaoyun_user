import 'package:flutter/material.dart';

import '../../constant/constant.dart';
import '../../models/recharge_price_model.dart';

class RechargeCard extends StatelessWidget {
  final RechargePriceModel priceItem;
  final bool isChecked;
  final Function()? onTap;
  const RechargeCard({super.key, required this.priceItem, this.isChecked = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    double presentedPriceValue = double.tryParse(this.priceItem.presentedPrice) ?? 0.0;
    return GestureDetector(
      child: Container(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "充" + this.priceItem.price,
              style: TextStyle(
                fontSize: 15,
                color: this.isChecked ? DYColors.primary : DYColors.text_gray,
              ),
            ),
            if (presentedPriceValue > 0)
              Text(
                "赠" + this.priceItem.presentedPrice,
                style: TextStyle(
                  fontSize: 13,
                  color: this.isChecked ? DYColors.primary : DYColors.text_gray,
                ),
              ),
          ],
        ),
        decoration: BoxDecoration(
          color: isChecked
              ? DYColors.primary.withOpacity(0.1)
              : DYColors.background,
          border: Border.all(
            color: isChecked ? DYColors.primary : DYColors.background,
            width: isChecked ? 1 : 0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: this.onTap,
    );
  }
}
