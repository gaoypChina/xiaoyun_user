import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/order_detail_model.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';

class OrderBaseInfoCard extends StatelessWidget {
  final OrderDetailModel detailModel;

  const OrderBaseInfoCard({super.key, required this.detailModel});
  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.all(Constant.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "订单信息",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Constant.padding, bottom: 8),
            child: Divider(height: 0.5),
          ),
          _buildInfoItem("订单号码", this.detailModel.no),
          _buildInfoItem("下单时间", this.detailModel.createTime),
          ..._buildTimeList(),
        ],
      ),
    );
  }

  List<Widget> _buildTimeList() {
    List<Widget> timeList = [];
    // if (this.detailModel.isCancel != 0) {
    //   timeList.add(
    //     _buildInfoItem("取消时间", this.detailModel.cancelTime),
    //   );
    // }
    if (this.detailModel.orderSta >= 2) {
      timeList.add(
        _buildInfoItem("接单时间", this.detailModel.receiveTime??''),
      );
    }
    if (this.detailModel.orderSta >= 3) {
      timeList.add(
        _buildInfoItem("服务时间", this.detailModel.startTime??''),
      );
    }
    if (this.detailModel.orderSta >= 4) {
      timeList.add(
        _buildInfoItem("完成时间", this.detailModel.completeTime??''),
      );
    }
    return timeList;
  }

  Widget _buildInfoItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title),
          Expanded(
            child: Text(
              subtitle ?? "",
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
