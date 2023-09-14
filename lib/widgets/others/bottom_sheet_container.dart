import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class BottomSheetContainer extends StatelessWidget {
  final double height;
  final Widget child;

  const BottomSheetContainer(
      {super.key, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Constant.padding),
      constraints: BoxConstraints(
        maxHeight: ScreenUtil().screenHeight - 80,
        minHeight: 200,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: Constant.padding),
              decoration: BoxDecoration(
                color: DYColors.normal_bg,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(
              child: Container(
                height: this.height,
                child: child,
              ),
            )
          ],
        ),
      ),
    );
  }
}
