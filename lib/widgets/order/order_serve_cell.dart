import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import '../common/common_local_image.dart';
import '../common/common_network_image.dart';

class OrderServeCell extends StatelessWidget {
  final String photoImgUrl;
  final String title;
  final String originPrice;
  final String price;

  const OrderServeCell({
    super.key,
    required this.photoImgUrl,
    this.title = '',
    this.originPrice = "",
    this.price = "",
  });
  @override
  Widget build(BuildContext context) {
    double originPrice = double.tryParse(this.originPrice) ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: DYNetworkImage(
              size: 40,
              imageUrl: this.photoImgUrl,
              placeholder: DYLocalImage(
                imageName: "common_placeholder_small",
                size: 40,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(this.title),
            ),
          ),
          if (originPrice > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "￥${this.originPrice}",
                style: TextStyle(
                  fontSize: 12,
                  color: DYColors.text_gray,
                  decoration: TextDecoration.lineThrough,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
          Text(
            "￥",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            this.price,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
