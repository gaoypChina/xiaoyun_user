import '../../utils/common_utils.dart';
import 'package:flutter/material.dart';

class DYLocalImage extends StatelessWidget {
  final String imageName;
  final String path;
  final double size;
  final double width;
  final double height;
  final BoxFit fit;
  final Color color;

  const DYLocalImage({
    Key key,
    @required this.imageName,
    this.path,
    this.size,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String path = this.path;
    if (path == null) {
      path = this.imageName.split("_").first;
    }
    return Image.asset(
      CommonUtils.getImagePath(this.imageName, path),
      width: this.width ?? this.size,
      height: this.height ?? this.size,
      fit: this.fit,
      color: this.color,
    );
  }
}
