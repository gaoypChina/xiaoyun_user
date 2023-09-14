import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/evaluate_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

import '../../widgets/common/common_local_image.dart';
import '../../widgets/order/order_evaluate_tag.dart';

class OrderCommentDetailPage extends StatefulWidget {
  final int? orderId;
  const OrderCommentDetailPage({super.key, this.orderId});

  @override
  State<OrderCommentDetailPage> createState() => _OrderCommentDetailPageState();
}

class _OrderCommentDetailPageState extends State<OrderCommentDetailPage> {
  EvaluateModel? _evaluateModel;
  List<String> _tagList = [];

  @override
  void initState() {
    super.initState();
    _getCommentDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(title: "评价详情"),
      body: _evaluateModel == null
          ? Container()
          : Container(
              width: double.infinity,
              child: CommonCard(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: RatingBar(
                        itemSize: 32,
                        initialRating: _evaluateModel!.evaluateStar.toDouble(),
                        ignoreGestures: true,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                        ratingWidget: RatingWidget(
                          empty: DYLocalImage(
                            imageName: "order_evaluate_star_empty",
                          ),
                          half: DYLocalImage(
                            imageName: "order_evaluate_star_empty",
                          ),
                          full: DYLocalImage(
                            imageName: "order_evaluate_star_full",
                          ),
                        ),
                        onRatingUpdate: (double value) {},
                      ),
                    ),
                    SizedBox(height: 15),
                    if (_tagList.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _tagWidgetList(),
                        ),
                      ),
                    CommonCard(
                      backgroundColor: DYColors.normal_bg,
                      padding: const EdgeInsets.all(15),
                      radius: 12,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          _evaluateModel!.evaluationContent.isEmpty
                              ? "未填写"
                              : _evaluateModel!.evaluationContent,
                          style: TextStyle(
                            fontSize: 13,
                            color: DYColors.text_gray,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        _evaluateModel!.evaluationTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: DYColors.text_light_gray,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> _tagWidgetList() {
    return _tagList.map<Widget>((title) {
      return OrderEvaluateTag(
        title: title,
      );
    }).toList();
  }

  void _getCommentDetail() {
    ToastUtils.showLoading("加载中...");
    HttpUtils.get(
      "order/evaluationDetail.do",
      params: {"id": widget.orderId},
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        setState(() {
          _evaluateModel = EvaluateModel.fromJson(resultData.data);
          _tagList = _evaluateModel!.evaluateTags.split(",");
        });
      },
    );
  }
}
