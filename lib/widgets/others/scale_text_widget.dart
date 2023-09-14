import 'package:flutter/material.dart';
import 'dart:math' as math;

class NoScaleTextWidget extends StatelessWidget {
  final Widget? child;
  const NoScaleTextWidget({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return MaxScaleTextWidget(
      max: 1.0,
      child: child,
    );
  }
}

class MaxScaleTextWidget extends StatelessWidget {
  final double max;
  final Widget? child;

  const MaxScaleTextWidget({
    super.key,
    this.max = 1.0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    var scale = math.min(max, data.textScaleFactor);
    return MediaQuery(
      data: data.copyWith(textScaleFactor: scale),
      child: child??Container(),
    );
  }
}
