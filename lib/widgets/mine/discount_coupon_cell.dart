import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/coupon_model.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/others/dash_line.dart';

class DiscountCouponCell extends StatefulWidget {
  final Color bgColor;
  final CouponModel couponModel;
  final bool isInvalid;

  const DiscountCouponCell({
    super.key,
    this.bgColor = Colors.white,
    required this.couponModel,
    this.isInvalid = false,
  });

  @override
  State<DiscountCouponCell> createState() => _DiscountCouponCellState();
}

class _DiscountCouponCellState extends State<DiscountCouponCell> {
  bool _remarkOpen = false;

  @override
  Widget build(BuildContext context) {
    String invalidIcon = "mine_coupon_invalid";
    if (widget.couponModel.status == 1) {
      invalidIcon = "mine_coupon_used";
    }
    TextStyle style = TextStyle(
      fontSize: 12,
      color: DYColors.text_gray,
    );
    bool exceedMaxLines = _textExceedMaxLines(widget.couponModel.remark, style,
        MediaQuery.of(context).size.width - 84);
    return Stack(
      children: [
        CommonCard(
          backgroundColor: widget.bgColor,
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.couponModel.type == 1)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 90),
                          child: Text.rich(
                            TextSpan(
                              text: "￥",
                              style: TextStyle(fontSize: 14),
                              children: [
                                TextSpan(
                                  text: widget.couponModel.moneyMoney,
                                  style: TextStyle(fontSize: 40),
                                ),
                              ],
                            ),
                            style: TextStyle(
                              color: widget.isInvalid
                                  ? Color(0xffFFCAD5)
                                  : DYColors.text_red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 10),
                          child: Text(
                            "满${widget.couponModel.fullMoney}可用",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  if (widget.couponModel.type == 1)
                    Container(
                      height: 48,
                      padding: const EdgeInsets.only(right: 25, left: 10),
                      child: DashedLine(
                        dashWidth: 1,
                        dashHeight: 3,
                        color: Color(0xffCCCCCC),
                        direction: Axis.vertical,
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.couponModel.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "有效期至" + widget.couponModel.expireTime,
                          style: TextStyle(
                            fontSize: 11,
                            color: DYColors.text_gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.couponModel.remark.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),
              if (widget.couponModel.remark.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.couponModel.remark,
                        overflow: TextOverflow.ellipsis,
                        maxLines: _remarkOpen ? 5 : 1,
                        style: style,
                      ),
                    ),
                    if (exceedMaxLines)
                      GestureDetector(
                        child: Container(
                          width: 20,
                          height: 20,
                          child: Icon(
                            _remarkOpen ? Icons.expand_less : Icons.expand_more,
                            color: DYColors.text_gray,
                            size: 16,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _remarkOpen = !_remarkOpen;
                          });
                        },
                      ),
                  ],
                ),
            ],
          ),
        ),
        if (widget.isInvalid)
          Positioned(
            top: 0,
            right: 0,
            child: DYLocalImage(imageName: invalidIcon, size: 68),
          ),
      ],
    );
  }

  bool _textExceedMaxLines(String text, TextStyle textStyle, double maxWidth) {
    TextSpan textSpan = TextSpan(text: text, style: textStyle);
    TextPainter textPainter = TextPainter(
        text: textSpan, maxLines: 1, textDirection: TextDirection.ltr);
    textPainter.layout(maxWidth: maxWidth);
    if (textPainter.didExceedMaxLines) {
      return true;
    }
    return false;
  }
}
