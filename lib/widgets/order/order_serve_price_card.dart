import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/order_detail_model.dart';
import 'package:xiaoyun_user/models/project_model.dart';
import 'package:xiaoyun_user/pages/order/order_other_fee_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

import 'order_serve_cell.dart';

class OrderServePriceCard extends StatelessWidget {
  final OrderDetailModel detailModel;

  const OrderServePriceCard({Key key, @required this.detailModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalFee = double.tryParse(this.detailModel.payFeeMoney) ?? 0.0;
    double otherFee = double.tryParse(this.detailModel.otherFeePay) ?? 0.0;
    double otherFeeTotal =
        double.tryParse(this.detailModel.otherFeeTotal) ?? 0.0;
    totalFee += otherFeeTotal;

    List<Widget> serveList =
        List.generate(this.detailModel.orderPriceList.length, (index) {
      ProjectModel projectModel = this.detailModel.orderPriceList[index];
      return OrderServeCell(
        photoImgUrl: projectModel.avatarImgUrl,
        title: projectModel.projectTitle,
        price: projectModel.priceMoney,
        originPrice: "${projectModel.originalPriceMoney}",
      );
    });

    // serveList.add(_buildPriceItem("总价", this.detailModel.priceMoney,
    //     isRed: false, top: 16));

    if (this.detailModel.isStarServe) {
      serveList.add(_buildPriceItem("星级服务", this.detailModel.starFeeMoney));
    }

    if (this.detailModel.couponReduceFee > 0) {
      serveList.add(_buildPriceItem(
          "优惠券", this.detailModel.couponReduceFeeMoney,
          isMinus: true));
    }

    if (this.detailModel.isOtherFeePay != 0) {
      serveList.add(Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                Text(
                  "其它",
                  style: TextStyle(
                    fontSize: 12,
                    color: DYColors.text_normal,
                  ),
                ),
                DYLocalImage(
                  imageName: "order_detail_other",
                  size: 24,
                )
              ],
            ),
            onPressed: () {
              NavigatorUtils.showPage(
                context,
                OrderOtherFeePage(
                  orderId: this.detailModel.id,
                ),
              );
            },
          ),
          Spacer(),
          Text(
            (this.detailModel.otherFeeTotalPrice),
            style: TextStyle(
              fontSize: 12,
              color: DYColors.text_red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ));
    }

    serveList.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: Constant.padding),
      child: Divider(height: 1),
    ));

    serveList.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "已优惠",
          style: TextStyle(color: DYColors.text_gray, fontSize: 14),
        ),
        Text(
          "￥${this.detailModel.discountPrice}",
          style: TextStyle(
            color: DYColors.text_red,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 5),
        Text(
          "小计：",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text.rich(
          TextSpan(text: "￥", style: TextStyle(fontSize: 12), children: [
            TextSpan(
              text: totalFee.toStringAsFixed(2),
              style: TextStyle(fontSize: 16),
            )
          ]),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ));

    double balancePriceValue =
        double.tryParse("${this.detailModel.balancePrice}") ?? 0.0;
    double weChatPayValue =
        double.tryParse("${this.detailModel.wxPayPriceTotal}") ?? 0.0;
    double aliPayValue =
        double.tryParse("${this.detailModel.aliPayPriceTotal}") ?? 0.0;

    String payMoneyStr = "";
    if (this.detailModel.payType == 1 && balancePriceValue == 0) {
      payMoneyStr = "0元支付";
    }
    if (balancePriceValue > 0) {
      payMoneyStr = "余额：￥${this.detailModel.balancePrice}";
    }

    if (aliPayValue > 0) {
      if (balancePriceValue > 0) {
        payMoneyStr += "  ";
      }
      payMoneyStr += "支付宝：￥$aliPayValue";
    }

    if (weChatPayValue > 0) {
      if (balancePriceValue > 0 || aliPayValue > 0) {
        payMoneyStr += "  ";
      }
      payMoneyStr += "微信：￥$weChatPayValue";
    }
    if (payMoneyStr.trim().isNotEmpty)
      serveList.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            payMoneyStr,
            style: TextStyle(fontSize: 12),
          ),
          decoration: BoxDecoration(
            color: DYColors.background,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      );

    if ((this.detailModel.isOtherFeePay == 3 ||
            this.detailModel.isOtherFeePay == 4) &&
        !this.detailModel.isCancel) {
      String msg = this.detailModel.isOtherFeePay == 3 ? "待支付" : "待退回";
      if (otherFee > 0)
        serveList.add(
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "$msg：￥${this.detailModel.otherFeePay}",
              style: TextStyle(
                color: DYColors.text_red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
    }
    serveList.add(SizedBox(height: 20));

    return CommonCard(
      padding: const EdgeInsets.fromLTRB(
          Constant.padding, Constant.padding, Constant.padding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: serveList,
      ),
    );
  }

  Widget _buildPriceItem(
    String title,
    String price, {
    double top = 12,
    bool isRed = true,
    bool isMinus = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontSize: 12)),
          Spacer(),
          Text(
            ((isMinus ? "-" : "") + "￥" + price),
            style: TextStyle(
              fontSize: 12,
              color: isRed ? DYColors.text_red : DYColors.text_normal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
