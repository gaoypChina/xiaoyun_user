import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';

class BottomButtonBar extends StatelessWidget {
  final String title;
  final Function onPressed;

  const BottomButtonBar({Key key, this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Constant.padding, vertical: 4),
      child: SafeArea(
        child: CommonActionButton(
          title: this.title,
          onPressed: this.onPressed,
        ),
      ),
    );
  }
}
