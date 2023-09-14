import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

class AddressCell extends StatelessWidget {
  final String name;
  final String address;

  const AddressCell({super.key, required this.name, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Constant.padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DYLocalImage(
            imageName: "address_icon",
            path: "home",
            size: 24,
          ),
          SizedBox(width: 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    this.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  this.address,
                  style: TextStyle(
                    fontSize: 12,
                    color: DYColors.text_gray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
