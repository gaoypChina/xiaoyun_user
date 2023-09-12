import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';

class DividerInputView extends StatelessWidget {
  final Widget slot;
  final String placeholder;
  final TextEditingController controller;
  final bool obscureText;
  final int maxLength;
  final TextInputType keyboardType;
  final FocusNode focusNode;

  const DividerInputView({
    Key key,
    this.slot,
    this.placeholder,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.maxLength,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: <Widget>[
          Expanded(
            child: DYTextField(
              controller: this.controller,
              obscureText: this.obscureText,
              placeholder: this.placeholder,
              keyboardType: this.keyboardType,
              fontSize: 15,
              focusNode: this.focusNode,
              maxLength: this.maxLength,
            ),
          ),
          if (this.slot != null) this.slot,
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: DYColors.divider, width: 1),
        ),
      ),
    );
  }
}
