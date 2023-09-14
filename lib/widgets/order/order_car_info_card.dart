import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/order_detail_model.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';

import 'order_car_info_widget.dart';

class OrderCarInfoCard extends StatelessWidget {
  final OrderDetailModel detailModel;
  const OrderCarInfoCard({super.key, required this.detailModel});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.all(Constant.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "洗车信息",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Constant.padding),
            child: Divider(height: 0.5),
          ),
          OrderCarInfoWidget(
            address: this.detailModel.address,
            carModel: this.detailModel.accountCar,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            margin: const EdgeInsets.only(bottom: 20),
            child: Text(
              "期望时间：" +
                  (this.detailModel.isReserve
                      ? this.detailModel.reserveStartTime!
                      : "立即洗车"),
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
          CommonCard(
            radius: 8,
            backgroundColor: DYColors.background,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("联系人"),
                    Expanded(
                      child: Text(
                        "${this.detailModel.contact}  ${this.detailModel.phone}",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text("车辆位置"),
                    Expanded(
                      child: Text(
                        this.detailModel.carLocation.isEmpty
                            ? "未填写"
                            : this.detailModel.carLocation,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text("备注"),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        this.detailModel.comment.isEmpty
                            ? "未填写"
                            : this.detailModel.comment,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
