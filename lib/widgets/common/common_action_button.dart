import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class CommonActionButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? margin;
  final double width;
  final double height;
  final Color titleColor;
  final Color bgColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool disable;
  final double radius;

  const CommonActionButton({
    super.key,
    required this.title,
    this.onPressed,
    this.margin,
    this.width = double.infinity,
    this.height = 50,
    this.titleColor = Colors.white,
    this.bgColor = DYColors.primary,
    this.fontSize = 16,
    this.disable = false,
    this.radius = 16,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      margin: this.margin,
      height: this.height,
      child: CupertinoButton(
        color: this.bgColor,
        disabledColor: DYColors.primary.withOpacity(0.4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        borderRadius: BorderRadius.circular(this.radius),
        child: Text(
          this.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: this.titleColor,
            fontSize: this.fontSize,
            fontWeight: this.fontWeight,
          ),
        ),
        onPressed: this.disable ? null : this.onPressed,
      ),
    );
  }
}
