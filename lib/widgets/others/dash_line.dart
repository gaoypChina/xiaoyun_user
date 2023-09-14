import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final double dashHeight;
  final double dashWidth;
  final Color color;
  final Axis direction;

  const DashedLine({
    super.key,
    this.dashHeight = 0.5,
    this.dashWidth = 5,
    this.color = Colors.grey,
    this.direction = Axis.horizontal,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = this.direction == Axis.horizontal
          ? constraints.constrainWidth()
          : constraints.constrainHeight();
      final dashCount = (boxWidth /
              (2 *
                  (this.direction == Axis.horizontal ? dashWidth : dashHeight)))
          .floor();
      return Flex(
        children: List.generate(dashCount, (index) {
          return SizedBox(
            width: dashWidth,
            height: dashHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          );
        }),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        direction: this.direction,
      );
    });
  }
}
