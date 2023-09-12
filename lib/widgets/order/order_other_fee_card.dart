import 'package:flutter/material.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';

import '../../constant/constant.dart';
import '../../models/other_fee_model.dart';
import '../common/common_cell_widget.dart';

class OrderOtherFeeCard extends StatelessWidget {
  final OtherFeeModel feeModel;
  const OrderOtherFeeCard({Key key, @required this.feeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: Constant.horizontalPadding,
      child: Column(
        children: [
          CommonCellWidget(
            title: "变更内容",
            subtitle: this.feeModel.staffUpdateTime,
            showArrow: false,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          CommonCellWidget(
            title: "车辆种类",
            showArrow: false,
            hiddenDivider: true,
            subtitle:
                "${this.feeModel.carType} -> ${this.feeModel.staffUpdateCarType}",
          ),
          CommonCellWidget(
            title: "其它",
            showArrow: false,
            hiddenDivider: true,
            subtitle: (this.feeModel.isAdd ? "加" : "减") +
                "${this.feeModel.otherFeePayPrice}元",
          ),
          CommonCellWidget(
            title: "备注",
            showArrow: false,
            hiddenDivider: true,
            subtitle: this.feeModel.otherComment,
          ),
          CommonCellWidget(
            title: "订单合计",
            showArrow: false,
            hiddenDivider: true,
            subtitle:
                "${this.feeModel.payFeePrice.toStringAsFixed(2)}元 -> ${this.feeModel.staffUpdateOrderMoneyPrice.toStringAsFixed(2)}元",
          ),
        ],
      ),
    );
  }
}
