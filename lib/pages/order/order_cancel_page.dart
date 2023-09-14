import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/order_status_event_bus.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/picker_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/common_text_view.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class OrderCancelPage extends StatefulWidget {
  final String orderNo;

  const OrderCancelPage({super.key, required this.orderNo});

  @override
  _OrderCancelPageState createState() => _OrderCancelPageState();
}

class _OrderCancelPageState extends State<OrderCancelPage> {
  TextEditingController _commentController = TextEditingController();
  String _reason = "";
  List<String> _reasonList = ["其它原因"];

  @override
  void initState() {
    super.initState();
    _getCancelReasonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "取消订单",
      ),
      body: ListView(
        padding: const EdgeInsets.all(Constant.padding),
        children: [
          CommonCard(
            padding: Constant.horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonCellWidget(
                  title: "取消原因",
                  subtitle: _reason.isEmpty ? "请选择" : _reason,
                  subtitleStyle: TextStyle(
                      color: _reason.isEmpty
                          ? DYColors.text_gray
                          : DYColors.text_normal),
                  onClicked: _pickReason,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: Constant.padding, bottom: 12),
                  child: Text("原因描述"),
                ),
                CommonTextView(
                  placeholder: "补充详细信息...",
                  controller: _commentController,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(height: 50),
          CommonActionButton(
            title: "确认取消",
            onPressed: _submitBtnClicked,
          ),
        ],
      ),
    );
  }

  void _pickReason() {
    PickerUtils.showPicker(
      context,
      _reasonList,
      confirmCallback: (selectedIndex) {
        setState(() {
          _reason = _reasonList[selectedIndex];
        });
      },
    );
  }

  void _getCancelReasonList() {
    HttpUtils.post(
      "order/queryCopy.do",
      params: {"copyType": "cancel"},
      onSuccess: (resultData) {
        _reasonList = resultData.data.map<String>((e) => e.toString()).toList();
        setState(() {});
      },
    );
  }

  void _submitBtnClicked() {
    if (_reason.isEmpty) {
      ToastUtils.showInfo("请选择取消原因");
      return;
    }
    ToastUtils.showLoading("取消中...");
    HttpUtils.post(
      "order/cancelOrder.do",
      params: {
        "cancelReason": _reason,
        "comment": _commentController.text,
        "orderNo": widget.orderNo
      },
      onSuccess: (resultData) {
        ToastUtils.showSuccess("取消成功");
        Future.delayed(Duration(seconds: 1)).then((value) {
          OrderStatusEventBus().fire(OrderStateChangedEvent());
          NavigatorUtils.goBack(context);
        });
      },
    );
  }
}
