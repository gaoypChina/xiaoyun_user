import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

class HomeCenterMarker extends StatelessWidget {
  final bool isEnd;

  const HomeCenterMarker({Key key, this.isEnd = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(bottom: 38),
        child: isEnd
            ? Lottie.asset(
                "assets/location/datouzhen.json",
                height: 50,
                repeat: false,
                frameBuilder: (context, child, composition) {
                  return AnimatedOpacity(
                    child: child,
                    opacity: composition == null ? 0 : 1,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeOut,
                  );
                },
              )
            : DYLocalImage(
                imageName: "home_center_marker",
                height: 38,
              ),
      ),
    );
  }
}
