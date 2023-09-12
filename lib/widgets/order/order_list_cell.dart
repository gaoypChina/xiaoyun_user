import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/order_model.dart';
import 'package:xiaoyun_user/pages/home/pay_page.dart';
import 'package:xiaoyun_user/pages/order/after_sale_detail_page.dart';
import 'package:xiaoyun_user/pages/order/order_cancel_page.dart';
import 'package:xiaoyun_user/pages/order/order_effect_page.dart';
import 'package:xiaoyun_user/pages/order/order_evaluate_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/order/order_action_btn.dart';
import 'package:xiaoyun_user/widgets/others/common_dot.dart';

class OrderListCell extends StatelessWidget {
  final OrderModel orderModel;

  const OrderListCell({
    Key key,
    @required this.orderModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalFee = double.tryParse(this.orderModel.priceMoney) ?? 0.0;
    double otherFee = double.tryParse(this.orderModel.otherFeePay) ?? 0.0;
    // if (this.orderModel.isOtherFeePay != 0) {
    //   if (this.orderModel.isOtherFeePay == 1 ||
    //       this.orderModel.isOtherFeePay == 3) {
    //     totalFee += otherFee;
    //   } else {
    //     totalFee -= otherFee;
    //   }
    // }
    bool isOtherFee = this.orderModel.isOtherFeePay == 3 &&
        otherFee > 0 &&
        !this.orderModel.isCancel;
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
                  Text(this.orderModel.isOtherFeePay != 3 ? "实付:" : "需付:"),
                  Text(
                    "￥" + totalFee.toStringAsFixed(2),
                    style: TextStyle(
                      color: DYColors.text_red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isOtherFee)
                    Text(
                      "(待支付:${this.orderModel.otherFeePay})",
                      style: TextStyle(fontSize: 12, color: DYColors.text_gray),
                    ),
                  Spacer(),
                  if (this.orderModel.orderSta > 3)
                    OrderActionBtn(
                      title: "查看效果图",
                      onPressed: () {
                        NavigatorUtils.showPage(
                          context,
                          OrderEffectPage(orderId: this.orderModel.id),
                        );
                      },
                    ),
                  if (!this.orderModel.isPay && !this.orderModel.isCancel)
                    OrderActionBtn(
                      title: "取消订单",
                      onPressed: () {
                        NavigatorUtils.showPage(
                          context,
                          OrderCancelPage(
                            orderNo: this.orderModel.no,
                          ),
                        );
                      },
                    ),
                  if (!this.orderModel.isEvaluate &&
                      this.orderModel.orderSta == 4 &&
                      this.orderModel.isOtherFeePay != 3 &&
                      this.orderModel.isEvaluable)
                    OrderActionBtn(
                      title: "评价",
                      onPressed: () {
                        NavigatorUtils.showPage(
                          context,
                          OrderEvaluatePage(
                            orderId: this.orderModel.id,
                          ),
                        );
                      },
                    ),
                  if (this.orderModel.orderSta == 5)
                    OrderActionBtn(
                      title: "售后详情",
                      onPressed: () {
                        NavigatorUtils.showPage(
                          context,
                          AfterSaleDetailPage(orderId: this.orderModel.id),
                        );
                      },
                    ),
                  if (isOtherFee)
                    OrderActionBtn(
                      title: "支付",
                      btnType: ActionBtnType.primary,
                      onPressed: () {
                        NavigatorUtils.showPage(
                          context,
                          PayPage(
                            orderNo: this.orderModel.no,
                            money: this.orderModel.otherFeePay,
                            orderId: this.orderModel.id,
                            isOtherFee: true,
                          ),
                        );
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
