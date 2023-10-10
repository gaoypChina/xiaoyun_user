import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';

export 'package:awesome_dialog/awesome_dialog.dart';

class DialogUtils {
  static showAlertDialog(
      BuildContext context, {
        DialogType dialogType = DialogType.noHeader,
        String title = "温馨提示",
        String message = "",
        Widget? body,
        String btnCancelText = "取消",
        String btnOkText = "确定",
        void Function()? cancelAction,
        void Function()? confirmAction,
        bool autoDismiss = true,
        Function(DismissType type)? onDismissCallback,
  }) {
    AwesomeDialog(
      context: context,
      padding: const EdgeInsets.all(16),
      dialogType: dialogType,
      animType: AnimType.scale,
      title: title,
      desc: message,
      autoDismiss: autoDismiss,
      onDismissCallback: onDismissCallback,
      btnCancel: cancelAction != null
          ? CupertinoButton(
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(15),
              minSize: 0,
              color: Color(0xffDAE2E9),
              child: Text(
                btnCancelText,
                style: TextStyle(fontSize: 14, color: DYColors.text_normal),
              ),
              onPressed: () {
                Navigator.pop(context);
                cancelAction();
              },
            )
          : null,
      body: body,
      buttonsBorderRadius: BorderRadius.circular(15),
      btnCancelText: btnCancelText,
      btnOkText: btnOkText,
      btnOkColor: DYColors.primary,
      btnCancelOnPress: cancelAction,
      btnOkOnPress: confirmAction,
      dismissOnTouchOutside: false,
    )..show();
  }

  static showActionSheetDialog(
    BuildContext context, {
    String? message,
    required List<ActionSheetDialogItem> dialogItems,
  }) async {
    var result = await showCupertinoModalPopup<int>(
      context: context,
      builder: (BuildContext cxt) {
        return CupertinoActionSheet(
          title: message == null ? null : Text(message),
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              "取消",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              Navigator.pop(cxt, 0);
            },
          ),
          actions: dialogItems.map((dialogItem) {
            return CupertinoActionSheetAction(
              child: Text(
                dialogItem.title,
                style: TextStyle(
                  color: dialogItem.isDestructiveAction ? Colors.red : Colors.blue,
                  fontSize: 16,
                ),
              ),
              isDestructiveAction: dialogItem.isDestructiveAction,
              onPressed: () {
                Navigator.pop(cxt, dialogItem.result);
                if (dialogItem.onPressed != null) {
                  dialogItem.onPressed?.call();
                }
              },
            );
          }).toList(),
        );
      },
    );
    return result;
  }

  static Future showCustomDialog({
    required BuildContext context,
    required Widget child,
    Color backgroundColor = Colors.white,
    bool barrierDismissible = false,
    EdgeInsets insetPadding = const EdgeInsets.all(0),
  }) async {
    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black38, // 自定义遮罩颜色
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: _buildMaterialDialogTransitions,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(
          builder: (context) {
            return Dialog(
              insetPadding: insetPadding,
              backgroundColor: backgroundColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: child,
            );
          },
        );
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return pageChild;
          }),
        );
      },
    );
  }

  static Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // 使用缩放动画
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}

class ActionSheetDialogItem {
  String title;
  bool isDestructiveAction;
  int result;
  Function? onPressed;

  ActionSheetDialogItem({
    this.title = '',
    this.isDestructiveAction = false,
    this.result = 0,
    this.onPressed,
  });
}
