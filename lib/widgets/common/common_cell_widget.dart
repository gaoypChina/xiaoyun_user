import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

class CommonCellWidget extends StatelessWidget {
  final String? icon;
  final double iconSize;
  final String title;
  final String mark;
  final String subtitle;
  final Widget? subtitleWidget;
  final bool showArrow;
  final bool hiddenDivider;
  final GestureTapCallback? onClicked;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final EdgeInsets padding;
  final Widget? endSolt;
  final double titleWidth;

  const CommonCellWidget({
    this.icon,
    this.iconSize = 20,
    required this.title,
    this.subtitle = "",
    this.showArrow = true,
    this.hiddenDivider = false,
    this.onClicked,
    this.titleStyle = const TextStyle(
      fontSize: 14,
      color: DYColors.text_normal,
    ),
    this.subtitleStyle = const TextStyle(
      fontSize: 14,
      color: DYColors.text_gray,
    ),
    this.padding = const EdgeInsets.symmetric(vertical: Constant.padding),
    this.endSolt,
    this.mark = "",
    this.subtitleWidget,
    this.titleWidth = 90,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InkWell(
        child: Column(
          children: <Widget>[
            Container(
              padding: padding,
              child: Row(
                children: <Widget>[
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: DYLocalImage(
                        imageName: this.icon??'',
                        size: this.iconSize,
                      ),
                    ),
                  SizedBox(
                    width: this.titleWidth,
                    child: Text(
                      title,
                      maxLines: 2,
                      style: this.titleStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (this.mark.isNotEmpty)
                    Text(
                      this.mark,
                      style: TextStyle(
                        fontSize: 15,
                        color: DYColors.text_light_gray,
                      ),
                    ),
                  SizedBox(width: 20),
                  Expanded(
                    child: this.subtitleWidget?? Text(
                            subtitle,
                            textAlign: TextAlign.end,
                            style: this.subtitleStyle,
                          ),
                  ),
                  endSolt??Container(),
                  Offstage(
                    offstage: !showArrow,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: DYLocalImage(
                        imageName: "common_right_arrow",
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: hiddenDivider,
              child: Divider(height: 1),
            ),
          ],
        ),
        onTap: onClicked,
      ),
    );
  }
}
