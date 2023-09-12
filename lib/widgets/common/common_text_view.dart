import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class CommonTextView extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final int maxLines;
  final EdgeInsets margin;
  final bool enabled;

  const CommonTextView({
    Key key,
    this.controller,
    this.placeholder = "请输入",
    this.maxLines = 8,
    this.margin,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: this.controller,
        maxLines: this.maxLines,
        enabled: this.enabled,
        style: TextStyle(
          color: DYColors.text_normal,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: this.placeholder,
          hintStyle: TextStyle(
            color: DYColors.text_light_gray,
            textBaseline: TextBaseline.alphabetic,
            fontSize: 14,
            height: defaultTargetPlatform == TargetPlatform.android ? 1.2 : 1.0,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: DYColors.background,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
