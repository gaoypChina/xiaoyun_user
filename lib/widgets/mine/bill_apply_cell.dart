import 'package:flutter/cupertino.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/order_bill_model.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/others/common_dot.dart';

class BillApplyCell extends StatelessWidget {
  final OrderBillModel billModel;
  final Function onCheck;

  const BillApplyCell({Key key, this.billModel, this.onCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
      child: Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.fromLTRB(Constant.padding, 20, 12, 20),
            minSize: 0,
            child: DYLocalImage(
              imageName: this.billModel.isChecked
                  ? "common_check_selected"
                  : "common_check_normal",
              size: 24,
            ),
            onPressed: this.onCheck,
          ),
          Expanded(
              child: Column(
            children: [
              Row(
                children: [
                  CommonDot(),
                  SizedBox(width: 8),
                  Expanded(child: Text(this.billModel.server)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Row(
                  children: [
                    CommonDot(),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text("完成时间：${this.billModel.completeTime}"),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  CommonDot(
                    color: DYColors.yellowDot,
                  ),
                  SizedBox(width: 8),
                  Expanded(child: Text(this.billModel.no)),
                  Text(
                    "￥${this.billModel.payFee.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 20,
                      color: DYColors.text_red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
