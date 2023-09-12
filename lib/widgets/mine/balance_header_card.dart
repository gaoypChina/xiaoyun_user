import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

import '../../pages/mine/balance_detail_page.dart';
import '../../utils/navigator_utils.dart';

class BalanceHeaderCard extends StatelessWidget {
  final String balanceValue;
  const BalanceHeaderCard({Key key, this.balanceValue = "0.00"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/mine/mine_balance_bg.png'))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "我的余额",
            style: TextStyle(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              this.balanceValue,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CupertinoButton(
            minSize: 0,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "明细",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                DYLocalImage(
                  imageName: "mine_balance_arrow",
                  size: 16,
                )
              ],
            ),
            onPressed: () {
              NavigatorUtils.showPage(context, BalanceDetailPage());
            },
          )
        ],
      ),
    );
  }
}
