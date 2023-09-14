import 'package:flutter/material.dart';
import '../../constant/constant.dart';

const double _kTabHeight = 46.0;

class TopTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<String> tabs;
  final Function(int index)? onTap;
  final bool isScrollable;

  const TopTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.onTap,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        isScrollable: isScrollable,
        labelColor: DYColors.text_normal,
        unselectedLabelColor: DYColors.text_normal,
        labelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        controller: controller,
        indicator: CustomIndicator(
          indicatorHeight: 3,
          indicatorColor: DYColors.primary,
        ),
        labelPadding: isScrollable
            ? const EdgeInsets.symmetric(horizontal: 15)
            : const EdgeInsets.all(0),
        tabs: tabs.map((e) => Tab(text: e)).toList(),
        onTap: this.onTap,
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(_kTabHeight);
  }
}

class CustomIndicator extends Decoration {
  final double indicatorHeight;
  final double indicatorWidth;
  final Color indicatorColor;

  CustomIndicator({
    this.indicatorHeight = 4,
    this.indicatorWidth = 20,
    this.indicatorColor = const Color(0xff1967d2),
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomIndicator decoration;

  _CustomPainter(this.decoration) : assert(decoration != null);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    Rect rect;

    rect = Offset(offset.dx + (configuration.size?.width ??0)/ 2 - decoration.indicatorWidth * 0.5, (configuration.size?.height??0 - decoration.indicatorHeight)) & Size(decoration.indicatorWidth, decoration.indicatorHeight);

    final Paint paint = Paint();
    paint.color = decoration.indicatorColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          rect, Radius.circular(decoration.indicatorHeight * 0.5)),
      paint,
    );
  }
}
