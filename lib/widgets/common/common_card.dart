import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool clipChild;
  final Color backgroundColor;
  final double radius;

  const CommonCard({
    Key key,
    @required this.child,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.clipChild = false,
    this.backgroundColor = Colors.white,
    this.radius = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(this.radius);
    return Container(
      child: ClipRRect(
        child: this.child,
        borderRadius: this.clipChild ? borderRadius : BorderRadius.circular(0),
      ),
      padding: this.padding,
      margin: this.margin,
      decoration: BoxDecoration(
        color: this.backgroundColor,
        borderRadius: borderRadius,
      ),
    );
  }
}
