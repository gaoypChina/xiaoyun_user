import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';

import '../../constant/constant.dart';
import '../../models/car_model.dart';
import '../common/common_card.dart';
import '../common/common_cell_widget.dart';
import '../order/order_car_info_widget.dart';

class ConfirmBaseInfoCard extends StatelessWidget {
  final CarModel currentCar;
  final Poi poi;
  final bool isAppointment;
  final String appointmentDate;
  final int expectTime;
  final Function() showTimeView;
  final Function() onCarClicked;
  const ConfirmBaseInfoCard({
    Key key,
    this.currentCar,
    this.poi,
    this.isAppointment = false,
    this.appointmentDate,
    this.showTimeView,
    this.onCarClicked,
    this.expectTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: Constant.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          OrderCarInfoWidget(
            isSelectMode: true,
            carModel: this.currentCar,
            address: this.poi.provinceName +
                this.poi.cityName +
                this.poi.adName +
                this.poi.title,
            onPressed: this.onCarClicked,
          ),
          this.isAppointment
              ? Column(
                  children: [
                    Divider(height: 1),
                    CommonCellWidget(
                      title: "预约时间",
                      subtitle: this.appointmentDate,
                      hiddenDivider: true,
                      onClicked: this.showTimeView,
                    ),
                  ],
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "预计接单时间：大约${this.expectTime}分钟接单",
                    style: TextStyle(
                      fontSize: 11,
                      color: DYColors.primary,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff00A2FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
        ],
      ),
    );
  }
}
