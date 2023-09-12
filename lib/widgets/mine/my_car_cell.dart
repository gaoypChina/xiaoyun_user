import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/car_model.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/others/common_dot.dart';

class MyCarCell extends StatelessWidget {
  final CarModel carModel;

  const MyCarCell({Key key, this.carModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonCard(
          padding: const EdgeInsets.symmetric(
              horizontal: Constant.padding, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                this.carModel.carBrandTitle + "  " + this.carModel.code,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    this.carModel.carColourTitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: DYColors.text_gray,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CommonDot(
                      color: Color(0xffCBD0D4),
                      size: 4,
                    ),
                  ),
                  Text(
                    this.carModel.carTypeTitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: DYColors.text_gray,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        if (this.carModel.isDefault)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
            child: Text(
              "默认车辆",
              style: TextStyle(
                fontSize: 11,
                color: DYColors.primary,
              ),
            ),
            decoration: BoxDecoration(
              color: DYColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: DYLocalImage(
            imageName: "mine_car_icon",
            width: 129,
            height: 64,
          ),
        )
      ],
    );
  }
}
