import 'package:flutter/cupertino.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

class CheckButton extends StatelessWidget {
  final bool isChecked;
  final String title;
  final TextStyle style;
  final VoidCallback? onPressed;
  final double iconSize;

  const CheckButton({
    super.key,
    this.isChecked = false,
    this.title = '',
    this.onPressed,
    this.style = const TextStyle(
      fontSize: 14,
      color: DYColors.text_normal,
      fontWeight: FontWeight.normal,
    ),
    this.iconSize = 24,
  });
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      onPressed: this.onPressed,
      child: Row(
        children: [
          DYLocalImage(
            imageName: this.isChecked
                ? "common_check_selected"
                : "common_check_normal",
            size: this.iconSize,
          ),
          SizedBox(width: 4),
          Text(this.title, style: this.style)
        ],
      ),
    );
  }
}
