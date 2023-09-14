import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DYNetworkImage extends StatelessWidget {
  final String imageUrl;
  final Widget? placeholder;
  final double? size;
  final double? width;
  final double? height;
  final BoxFit fit;

  const DYNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeholder,
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: this.imageUrl,
      placeholder: (context, url) =>
          this.placeholder ??
          Container(
            color: Color(0xffE7E7E7),
          ),
      errorWidget: (context, url, error) =>
          this.placeholder ??
          Container(
            color: Color(0xffE7E7E7),
          ),
      fit: this.fit,
      width: this.width ?? this.size,
      height: this.height ?? this.size,
    );
  }
}
