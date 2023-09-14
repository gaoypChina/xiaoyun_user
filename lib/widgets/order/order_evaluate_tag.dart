import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class OrderEvaluateTag extends StatelessWidget {
  final String title;
  final bool isChecked;
  final GestureTapCallback? onClicked;

  const OrderEvaluateTag(
      {super.key, this.title = '', this.isChecked = false, this.onClicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: this.isChecked ? DYColors.primary : DYColors.text_gray,
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: this.isChecked ? DYColors.primary : DYColors.divider,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onTap: this.onClicked,
    );
  }
}
