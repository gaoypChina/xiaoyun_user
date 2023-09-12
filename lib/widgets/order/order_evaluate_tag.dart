import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class OrderEvaluateTag extends StatelessWidget {
  final String title;
  final bool isChecked;
  final Function onClicked;

  const OrderEvaluateTag(
      {Key key, this.title, this.isChecked = false, this.onClicked})
      : super(key: key);

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
