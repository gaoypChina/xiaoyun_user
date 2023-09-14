import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

class HomeActionBtn extends StatelessWidget {
  final String imageName;
  final String title;
  final VoidCallback? onPressed;

  const HomeActionBtn(
      {super.key,
      required this.imageName,
      this.onPressed,
      this.title = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoButton(
        color: Colors.white,
        minSize: 30,
        padding: const EdgeInsets.all(6),
        borderRadius: BorderRadius.circular(15),
        child: Row(
          children: [
            DYLocalImage(
              imageName: imageName,
              size: 24,
            ),
            if (this.title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  title,
                  style: TextStyle(
                    color: DYColors.text_normal,
                    fontSize: 15,
                  ),
                ),
              )
          ],
        ),
        onPressed: this.onPressed,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: DYColors.text_dark_gray.withOpacity(0.2),
            offset: Offset(0, 10),
            blurRadius: 20,
          )
        ],
      ),
    );
  }
}
