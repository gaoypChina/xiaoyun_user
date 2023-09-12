import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/balance_model.dart';

class BalanceCell extends StatelessWidget {
  final BalanceModel balanceItem;
  const BalanceCell({Key key, @required this.balanceItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String flow = this.balanceItem.flow == 1 ? "+" : "-";
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${this.balanceItem.title}",
                        style: TextStyle(fontSize: 16),
                      ),
                      if (this.balanceItem.type > 1 &&
                          this.balanceItem.type != 4)
                        TextSpan(
                          text: "-${this.balanceItem.orderId}",
                          style: TextStyle(
                            fontSize: 15,
                            color: DYColors.text_gray,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Text(
                flow + this.balanceItem.moneyPrice,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: this.balanceItem.flow == 1
                      ? DYColors.text_red
                      : DYColors.text_normal,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  this.balanceItem.createTime ?? "--",
                  style: TextStyle(color: DYColors.text_gray),
                ),
              ),
              Text(
                "余额：" + this.balanceItem.balancePrice,
                style: TextStyle(color: DYColors.text_gray),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Divider(height: 1),
          )
        ],
      ),
    );
  }
}
