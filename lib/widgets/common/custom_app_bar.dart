import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class DYAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final String backImage;
  final bool automaticallyImplyLeading;
  final double titleSpacing;
  final Color backgroundColor;
  final Gradient? gradient;
  final bool showBack;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final SystemUiOverlayStyle? systemOverlayStyle;

  DYAppBar({
    this.title = "",
    this.titleWidget,
    this.backImage = "assets/images/navigation/navigation_back.png",
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = false,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.backgroundColor = DYColors.app_bar,
    this.showBack = true,
    this.centerTitle = true,
    this.bottom,
    this.gradient,
    this.systemOverlayStyle,
  });

  Widget build(BuildContext context) {
    Widget? _leading = this.leading;
    if (this.showBack && this.leading == null) {
      _leading = IconButton(
        icon: Image.asset(
          this.backImage,
          width: 24,
          height: 24,
        ),
        onPressed: () {
          Navigator.of(context).maybePop();
        },
      );
    }
    return Container(
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: this.titleSpacing,
        title: this.titleWidget != null ? titleWidget : Text(this.title),
        centerTitle: this.centerTitle,
        leading: _leading,
        actions: this.actions,
        automaticallyImplyLeading: this.automaticallyImplyLeading,
        bottom: this.bottom,
        systemOverlayStyle: this.systemOverlayStyle,
      ),
      decoration: BoxDecoration(
        color: this.backgroundColor,
        gradient: this.gradient != null ? this.gradient : null,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0));
}
