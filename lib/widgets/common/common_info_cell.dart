import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class CommonInfoCell extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool hiddenDivider;
  final Widget? slot;
  final Widget? endSlot;
  final double titleWidth;
  final double verticalPadding;
  final TextStyle subtitleStyle;

  const CommonInfoCell({
    super.key,
    this.title = "",
    this.subtitle = "",
    this.hiddenDivider = false,
    this.slot,
    this.titleWidth = 95,
    this.verticalPadding = 15.0,
    this.endSlot,
    this.subtitleStyle = const TextStyle(
      fontSize: 14,
      color: DYColors.text_normal,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: this.verticalPadding),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: this.titleWidth,
            child: Text(title),
          ),
          slot??Container(),
          Expanded(
            child: Text(
              subtitle,
              textAlign: TextAlign.right,
              style: this.subtitleStyle,
            ),
          ),
          endSlot??Container(),
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
