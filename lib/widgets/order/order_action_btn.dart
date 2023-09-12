import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';

enum ActionBtnType { outline, primary }

class OrderActionBtn extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final double fontSize;
  final double marginLeft;
  final Function onPressed;

  final ActionBtnType btnType;

  const OrderActionBtn({
    Key key,
    @required this.title,
    @required this.onPressed,
    this.width = 80,
    this.height = 28,
    this.fontSize = 12,
    this.btnType = ActionBtnType.outline,
    this.marginLeft = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      margin: EdgeInsets.only(left: this.marginLeft),
      child: CupertinoButton(
        padding: const EdgeInsets.all(0),
        minSize: 0,
        color: this.btnType == ActionBtnType.outline
            ? Colors.white
            : DYColors.primary,
        borderRadius: BorderRadius.circular(8),
        child: Text(
          this.title,
          style: TextStyle(
            fontSize: this.fontSize,
            color: this.btnType == ActionBtnType.outline
                ? DYColors.text_normal
                : Colors.white,
          ),
        ),
        onPressed: this.onPressed,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: this.btnType == ActionBtnType.outline
              ? DYColors.text_normal
              : DYColors.primary,
          width: 0.5,
        ),
      ),
    );
  }
}
