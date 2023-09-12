import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/car_model.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/others/common_dot.dart';

class OrderCarInfoWidget extends StatelessWidget {
  final String address;
  final bool isSelectMode;
  final Function onPressed;
  final CarModel carModel;

  const OrderCarInfoWidget(
      {Key key,
      this.address,
      this.isSelectMode = false,
      this.onPressed,
      @required this.carModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String carInfo =
        "${this.carModel.carColourTitle} · ${this.carModel.carTypeTitle}";
    if (this.carModel.isJersey) {
      carInfo += " · 有车衣";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CommonDot(color: DYColors.yellowDot),
            SizedBox(width: 8),
            Expanded(
              child: Text(address),
            ),
          ],
        ),
        GestureDetector(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: Constant.padding, top: 20),
            child: Row(
              children: [
                DYLocalImage(
                  imageName: "order_car",
                  size: 40,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${this.carModel.carBrandTitle}  ${this.carModel.code}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        carInfo,
                        style: TextStyle(
                          fontSize: 11,
                          color: DYColors.text_gray,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelectMode)
                  DYLocalImage(imageName: "common_right_arrow", size: 24),
              ],
            ),
          ),
          onTap: this.onPressed,
        ),
      ],
    );
  }
}
