import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/bill_history_model.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

class BillHistoryCell extends StatelessWidget {
  final BillHistoryModel historyModel;

  const BillHistoryCell({super.key, required this.historyModel});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.symmetric(
          horizontal: Constant.padding, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.historyModel.defaultName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              DYLocalImage(
                imageName: "mine_bill_time_icon",
                size: 24,
              ),
              SizedBox(width: 2),
              Text(
                this.historyModel.createTime,
                style: TextStyle(
                  color: DYColors.text_gray,
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                "￥${this.historyModel.priceMoney}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: DYColors.text_red,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "${this.historyModel.count}个订单",
                style: TextStyle(
                  fontSize: 12,
                  color: DYColors.text_gray,
                ),
              ),
              Spacer(),
              CommonCard(
                radius: 6,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                backgroundColor: DYColors.primary.withOpacity(0.1),
                child: Text(
                  this.historyModel.status == 1 ? "已开票" : "待开票",
                  style: TextStyle(fontSize: 12, color: DYColors.primary),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
