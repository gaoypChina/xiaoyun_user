import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class DYTextField extends StatelessWidget {
  final bool autoFocus;
  final TextInputType keyboardType;
  final String placeholder;
  final FocusNode focusNode;
  final TextAlign textAlign;
  final bool obscureText;
  final double fontSize;
  final Color color;
  final int maxLength;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final OverlayVisibilityMode clearButtonMode;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final Function onTap;
  final bool readOnly;
  final List<TextInputFormatter> inputFormatter;

  const DYTextField({
    Key key,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.placeholder,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.obscureText = false,
    this.fontSize = 14,
    this.color = const Color(0xff333333),
    this.controller,
    this.textInputAction = TextInputAction.done,
    this.clearButtonMode = OverlayVisibilityMode.editing,
    this.onSubmitted,
    this.maxLength,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.inputFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      textAlign: this.textAlign,
      autofocus: this.autoFocus,
      focusNode: this.focusNode,
      obscureText: this.obscureText,
      controller: this.controller,
      placeholder: this.placeholder,
      textInputAction: this.textInputAction,
      keyboardType: this.keyboardType,
      clearButtonMode: this.clearButtonMode,
      inputFormatters: _getInputFormatters(),
      padding: const EdgeInsets.symmetric(vertical: 6),
      maxLength: this.maxLength,
      readOnly: this.readOnly,
      // cursorColor: Color(0xff999999),

      style: TextStyle(
        fontSize: this.fontSize,
        color: this.color,
      ),
      placeholderStyle: TextStyle(
        fontSize: this.fontSize,
        color: DYColors.text_light_gray,
        textBaseline: TextBaseline.alphabetic,
      ),
      onTap: this.onTap,
      onSubmitted: this.onSubmitted,
      onChanged: this.onChanged,
      // enableInteractiveSelection: false,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.none),
      ),
    );
  }

  List<TextInputFormatter> _getInputFormatters() {
    if (this.keyboardType == TextInputType.number ||
        this.keyboardType == TextInputType.phone) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    return this.inputFormatter;
  }
}
