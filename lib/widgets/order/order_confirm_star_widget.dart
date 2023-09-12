import 'package:flutter/cupertino.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

class OrderConfirmStarWidget extends StatelessWidget {
  final bool isStarServe;
  final String price;
  final Function(bool) onChanged;

  const OrderConfirmStarWidget(
      {Key key, this.isStarServe, this.onChanged, this.price})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: DYLocalImage(
              imageName: "order_star_level",
              size: 68,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constant.padding, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DYLocalImage(
                            imageName: "order_star",
                            size: 19,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "星级服务",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 27, top: 4),
                        child: Text(
                          "享优先派单服务",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: "￥",
                    style: TextStyle(fontSize: 12),
                    children: [
                      TextSpan(
                        text: this.price,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                  style: TextStyle(
                    color: DYColors.text_red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12),
                CupertinoSwitch(
                  activeColor: DYColors.primary,
                  value: this.isStarServe,
                  onChanged: this.onChanged,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
