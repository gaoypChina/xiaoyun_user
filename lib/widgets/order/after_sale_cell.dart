import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/after_sale_order.dart';
import 'package:xiaoyun_user/pages/order/after_sale_detail_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/others/common_dot.dart';

import 'order_action_btn.dart';

class AfterSaleCell extends StatelessWidget {
  final AfterSaleOrder orderModel;
  final Function onRepeal;

  const AfterSaleCell({Key key, this.orderModel, this.onRepeal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonCard(
          padding: const EdgeInsets.symmetric(
              horizontal: Constant.padding, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                this.orderModel.status,
                style: TextStyle(color: DYColors.text_gray),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  CommonDot(),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      this
                          .orderModel
                          .orderPriceList
                          .map((e) => e.projectTitle)
                          .toList()
                          .join(" "),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CommonDot(),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "期望时间：" +
                            (this.orderModel.isReserve
                                ? this.orderModel.reserveStartTime
                                : "立即洗车"),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  CommonDot(color: DYColors.yellowDot),
                  SizedBox(width: 8),
                  Expanded(child: Text(this.orderModel.no)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Constant.padding),
                child: Divider(height: 1),
              ),
              Row(
                children: [
                  Text("实付："),
                  Expanded(
                    child: Text(
                      "￥${this.orderModel.priceMoney}",
                      style: TextStyle(
                        color: DYColors.text_red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  OrderActionBtn(
                    title: this.orderModel.orderSta == 1 ? "撤销申请" : "售后详情",
                    onPressed: () {
                      if (this.orderModel.orderSta == 1) {
                        this.onRepeal();
                      } else {
                        NavigatorUtils.showPage(
                          context,
                          AfterSaleDetailPage(orderId: this.orderModel.id),
                        );
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: DYLocalImage(imageName: "order_list_car", size: 82),
        ),
      ],
    );
  }
}
