import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:shimmer/shimmer.dart';

class SliderBar extends StatefulWidget {
  final double width;
  final double height;
  final Function()? onSuccess;
  const SliderBar({
    super.key,
    this.width = 300,
    this.onSuccess,
    this.height = 45
  })
      : assert(width != 0 && width != double.infinity);

  @override
  SliderBarState createState() => SliderBarState();
}

class SliderBarState extends State<SliderBar> {
  double _left = 0.0;
  bool _success = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Color(0xff00A2FF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Shimmer.fromColors(
            baseColor: Color(0xff00A2FF),
            highlightColor: Colors.white,
            enabled: !_success,
            child: Center(
              child: Text(
                "请按住滑块，拖动到最右边",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            width: _left == 0 ? 0 : _left + 4,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
              color: DYColors.primary.withAlpha(_success ? 255 : 200),
            ),
            child: Offstage(
              offstage: !_success,
              child: Center(
                child: Text(
                  "验证通过",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            left: _left,
            child: GestureDetector(
              child: Container(
                width: widget.height,
                height: widget.height,
                child: Icon(
                  _success ? Icons.done : Icons.navigate_next,
                  color: DYColors.primary,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                if (_success) return;
                setState(() {
                  _left += details.delta.dx;
                });
              },
              onHorizontalDragEnd: (details) {
                if (_left >= widget.width - widget.height) {
                  setState(() {
                    _left = widget.width - widget.height;
                    _success = true;
                    widget.onSuccess?.call();
                  });
                } else {
                  setState(() {
                    _left = 0;
                    _success = false;
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void resetWidget() {
    setState(() {
      _success = false;
      _left = 0;
    });
  }
}
