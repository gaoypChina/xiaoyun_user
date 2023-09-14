import 'package:flutter/cupertino.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/others/common_dot.dart';

class HomeSelectBtn extends StatelessWidget {
  final String placeholder;
  final String value;
  final VoidCallback? onPressed;

  const HomeSelectBtn({
    super.key,
    this.placeholder = "",
    this.value = "",
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: CupertinoButton(
        color: DYColors.normal_bg,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            CommonDot(),
            SizedBox(width: Constant.padding),
            Expanded(
              child: Text(
                value.isEmpty ? placeholder : value,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16,
                  color:
                      value.isEmpty ? DYColors.text_gray : DYColors.text_normal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}
