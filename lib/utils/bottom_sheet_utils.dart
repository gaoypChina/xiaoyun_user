import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:xiaoyun_user/widgets/others/bottom_sheet_container.dart';

class BottomSheetUtil {
  static show(BuildContext context,
      {@required Widget child, double height = 500}) {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheetContainer(
          height: height,
          child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: child,
          ),
        );
      },
    );
  }
}
