import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_local_image.dart';

class NavigationItem extends StatelessWidget {
  // 第一种： 纯文本
  final String title;
  final Color textColor;
  // 第二种： 复杂子组件
  final Widget child; //设置 child 之后 title 和 textColor 将会失效

  // 第三种：IconButton，icon 为图片路径
  final String iconName;
  final double iconSize;

  final Function onPressed;

  const NavigationItem({
    Key key,
    this.title,
    this.textColor = const Color(0xff333333),
    this.child,
    this.iconName,
    this.onPressed,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.iconName != null
        ? IconButton(
            icon: DYLocalImage(
              imageName: this.iconName,
              size: this.iconSize,
            ),
            onPressed: this.onPressed,
          )
        : CupertinoButton(
            minSize: 44,
            padding: const EdgeInsets.all(15),
            child: this.child != null
                ? this.child
                : Text(
                    title,
                    style: TextStyle(
                      color: this.textColor,
                      fontSize: 14,
                    ),
                  ),
            onPressed: onPressed,
          );
  }
}
