import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/order_status_event_bus.dart';
import 'package:xiaoyun_user/models/order_detail_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_network_image.dart';
import 'package:xiaoyun_user/widgets/common/common_text_view.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/order/order_evaluate_tag.dart';

class OrderEvaluatePage extends StatefulWidget {
  final int orderId;

  const OrderEvaluatePage({Key key, @required this.orderId}) : super(key: key);
  @override
  _OrderEvaluatePageState createState() => _OrderEvaluatePageState();
}

class _OrderEvaluatePageState extends State<OrderEvaluatePage> {
  List<OrderTagItem> _tagList = [];
  int _evaluateStar = 5;
  StaffModel _staff;
  String _completeTime = "";
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStaffInfo();
    _getTagList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "评价",
      ),
      body: ListView(
        padding: const EdgeInsets.all(Constant.padding),
        children: [
          CommonCard(
            padding: const EdgeInsets.symmetric(
                horizontal: Constant.padding, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: _staff == null || _staff.avatarImgUrl.isEmpty
                          ? DYLocalImage(
                              imageName: "common_staff_header",
                              size: 48,
                            )
                          : DYNetworkImage(
                              imageUrl: _staff.avatarImgUrl,
                              size: 48,
                            ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _staff == null ? "" : _staff.uname,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "$_completeTime完成",
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: Constant.padding, bottom: 20),
                  child: Divider(height: 1),
                ),
                Center(
                  child: RatingBar(
                    itemSize: 32,
                    initialRating: 5,
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
                    onRatingUpdate: (double value) {
                      _evaluateStar = value.toInt();
                    },
                  ),
                ),
                SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _tagWidgetList(),
                ),
                SizedBox(height: 20),
                CommonTextView(
                  placeholder: "请输入评价内容",
                  controller: _controller,
                )
              ],
            ),
          ),
          SizedBox(height: 50),
          CommonActionButton(
            title: "提交",
            onPressed: _submitAction,
          ),
        ],
      ),
    );
  }

  List<Widget> _tagWidgetList() {
    return _tagList.map<Widget>((e) {
      return OrderEvaluateTag(
        title: e.title,
        isChecked: e.isChecked,
        onClicked: () {
          setState(() {
            e.isChecked = !e.isChecked;
          });
        },
      );
    }).toList();
  }

  void _loadStaffInfo() {
    HttpUtils.get(
      "order/getStaffUser.do",
      params: {"orderId": widget.orderId},
      onSuccess: (resultData) {
        _staff = StaffModel.fromJson(resultData.data);
        _completeTime = resultData.data["completeTime"];
        setState(() {});
      },
    );
  }

  void _getTagList() {
    HttpUtils.post(
      "order/queryCopy.do",
      params: {"copyType": "tags"},
      onSuccess: (resultData) {
        resultData.data.forEach((element) {
          _tagList.add(OrderTagItem(title: element.toString()));
        });
        setState(() {});
      },
    );
  }

  void _submitAction() {
    List<OrderTagItem> _selectedTags =
        _tagList.where((element) => element.isChecked).toList();
    String evaluateTags = _selectedTags.map((e) => e.title).toList().join(",");
    Map<String, dynamic> params = {
      "id": widget.orderId,
      "evaluateStar": _evaluateStar,
      "evaluateTags": evaluateTags,
    };
    if (_controller.text.isNotEmpty) {
      params["content"] = _controller.text;
    }
    ToastUtils.showLoading("提交中...");
    HttpUtils.post(
      "order/evaluation.do",
      params: params,
      onSuccess: (resultData) {
        ToastUtils.showSuccess("评价成功");
        Future.delayed(Duration(seconds: 1)).then((value) {
          OrderStatusEventBus().fire(OrderStateChangedEvent());
          NavigatorUtils.goBack(context);
        });
      },
    );
  }
}

class OrderTagItem {
  String title;
  bool isChecked;
  OrderTagItem({this.title, this.isChecked = false});
}
