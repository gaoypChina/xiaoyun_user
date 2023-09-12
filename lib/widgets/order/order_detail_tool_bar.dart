import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/order_detail_model.dart';
import 'package:xiaoyun_user/pages/home/pay_page.dart';
import 'package:xiaoyun_user/pages/order/after_sale_detail_page.dart';
import 'package:xiaoyun_user/pages/order/order_cancel_page.dart';
import 'package:xiaoyun_user/pages/order/order_comment_detail_pgae.dart';
import 'package:xiaoyun_user/pages/order/order_evaluate_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';

import '../../pages/order/apply_after_sale_page.dart';
import 'order_action_btn.dart';

class OrderDetailToolBar extends StatelessWidget {
  final OrderDetailModel detailModel;

  const OrderDetailToolBar({
    Key key,
    this.detailModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double otherFee = double.tryParse(this.detailModel.otherFeePay) ?? 0.0;
    bool isOtherFee = this.detailModel.isOtherFeePay == 3 &&
        otherFee > 0 &&
        !this.detailModel.isCancel;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          horizontal: Constant.padding, vertical: 12),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if ((this.detailModel.orderSta < 3 ||
                    (this.detailModel.orderSta == 3 &&
                        this.detailModel.isOtherFeePay == 3)) &&
                this.detailModel.cancelable)
              OrderActionBtn(
                title: "取消订单",
                onPressed: () {
                  NavigatorUtils.showPage(
                    context,
                    OrderCancelPage(orderNo: this.detailModel.no),
                  );
                },
              ),
            if (this.detailModel.orderSta == 4 &&
                this.detailModel.afterSalesable)
              OrderActionBtn(
                title: "申请售后",
                onPressed: () {
                  NavigatorUtils.showPage(
                    context,
                    ApplyAfterSalePage(
                      orderId: this.detailModel.id,
                    ),
                  );
                },
              ),
            if (!this.detailModel.isEvaluate &&
                this.detailModel.orderSta == 4 &&
                this.detailModel.isEvaluable)
              OrderActionBtn(
                title: "评价",
                onPressed: () {
                  NavigatorUtils.showPage(
                    context,
                    OrderEvaluatePage(
                      orderId: this.detailModel.id,
                    ),
                  );
                },
              ),
            if (this.detailModel.isEvaluate)
              OrderActionBtn(
                title: "查看评价",
                onPressed: () {
                  NavigatorUtils.showPage(
                    context,
                    OrderCommentDetailPage(
                      orderId: this.detailModel.id,
                    ),
                  );
                },
              ),
            if (this.detailModel.orderSta == 5)
              OrderActionBtn(
                title: "售后详情",
                onPressed: () {
                  NavigatorUtils.showPage(
                    context,
                    AfterSaleDetailPage(
                      orderId: this.detailModel.id,
                    ),
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
                      orderNo: this.detailModel.no,
                      money: this.detailModel.otherFeePay,
                      orderId: this.detailModel.id,
                      isOtherFee: true,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
