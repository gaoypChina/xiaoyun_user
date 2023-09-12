import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class CommonDot extends StatelessWidget {
  final Color color;
  final double size;

  const CommonDot({Key key, this.color = DYColors.primary, this.size = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: this.size,
        height: this.size,
        color: this.color,
      ),
    );
  }
}
