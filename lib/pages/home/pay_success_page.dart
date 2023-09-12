import 'package:flutter/material.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

import '../order/order_detail_page.dart';

class PaySuccessPage extends StatefulWidget {
  final int orderId;
  final bool isRecharge;
  const PaySuccessPage({Key key, this.orderId, this.isRecharge = false})
      : super(key: key);

  @override
  State<PaySuccessPage> createState() => _PaySuccessPageState();
}

class _PaySuccessPageState extends State<PaySuccessPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: DYAppBar(title: "支付成功"),
        body: _buildListView(context),
      ),
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return false;
      },
    );
  }

  ListView _buildListView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5),
          child: DYLocalImage(
            imageName: "order_pay_success",
            fit: BoxFit.contain,
            size: 52,
          ),
        ),
        Text(
          "支付成功!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 24),
        if (!widget.isRecharge)
          CommonCard(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      width: 60,
                      height: 6,
                      color: Colors.amberAccent,
                    ),
                    Text(
                      "温馨提示",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text("1. 请保持电话畅通，以便服务人员及时联系到您；"),
                SizedBox(height: 5),
                Text("2. 若出现排队情况，综合所在地的原因，可能未能按照约定时间完成您的服务；"),
                SizedBox(height: 5),
                Text("3. 若范围内没有服务人员，您的订单可能会被取消。"),
              ],
            ),
          ),
        SizedBox(height: 30),
        Container(
          alignment: Alignment.center,
          child: CommonActionButton(
            title: "完成",
            width: 150,
            height: 50,
            onPressed: () {
              if (widget.isRecharge) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (ctx) => OrderDetailPage(orderId: widget.orderId),
                  ),
                  (route) => route.isFirst,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
