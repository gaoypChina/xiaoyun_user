import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';

import 'common_text_field.dart';

class TitleInputField extends StatelessWidget {
  final String title;
  final bool isRequired;
  final String placeholder;
  final TextEditingController controller;
  final TextStyle style;
  final bool hiddenDivider;
  final double height;
  final TextInputType keyboardType;
  final Widget endSlot;
  final TextAlign textAlign;
  final double titleWidth;
  final int maxLength;
  final bool obscureText;
  final Color inputColor;
  final bool readOnly;

  const TitleInputField({
    Key key,
    this.title,
    this.placeholder,
    this.controller,
    this.style = const TextStyle(
      fontSize: 14,
      color: DYColors.text_normal,
    ),
    this.hiddenDivider = false,
    this.height = 45,
    this.keyboardType = TextInputType.text,
    this.endSlot,
    this.textAlign = TextAlign.end,
    this.titleWidth = 80,
    this.maxLength,
    this.obscureText = false,
    this.inputColor = const Color(0xff333333),
    this.readOnly = false,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: this.titleWidth,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    this.title,
                    style: this.style,
                  ),
                ),
                if (this.isRequired)
                  Text(
                    "*",
                    style: TextStyle(
                      fontSize: 14,
                      color: DYColors.text_red,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: DYTextField(
              textAlign: this.textAlign,
              controller: this.controller,
              placeholder: this.placeholder,
              keyboardType: this.keyboardType,
              clearButtonMode: OverlayVisibilityMode.never,
              color: inputColor,
              readOnly: this.readOnly,
              maxLength: this.maxLength,
              obscureText: this.obscureText,
            ),
          ),
          if (this.endSlot != null) this.endSlot,
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: hiddenDivider
            ? Border.all(style: BorderStyle.none)
            : Border(
                bottom: BorderSide(color: DYColors.divider, width: 0.5),
              ),
      ),
    );
  }
}
