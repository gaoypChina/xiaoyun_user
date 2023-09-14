import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/other_fee_model.dart';
import 'package:xiaoyun_user/models/page_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/order/order_other_fee_card.dart';

class OrderOtherFeePage extends StatefulWidget {
  final int orderId;

  const OrderOtherFeePage({super.key, required this.orderId});
  @override
  _OrderOtherFeePageState createState() => _OrderOtherFeePageState();
}

class _OrderOtherFeePageState extends State<OrderOtherFeePage> {
  List<OtherFeeModel> _feeModelList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "订单信息变更",
      ),
      body: _feeModelList.isEmpty ? Container() : _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.separated(
      padding: const EdgeInsets.all(Constant.padding),
      itemBuilder: (context, index) {
        return OrderOtherFeeCard(feeModel: _feeModelList[index]);
      },
      separatorBuilder: (context, index) => SizedBox(height: 15),
      itemCount: _feeModelList.length,
    );
  }

  void _loadData() {
    ToastUtils.showLoading();
    HttpUtils.get(
      "order/getOrderUpdateDetail.do",
      params: {"orderId": widget.orderId},
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        PageModel pageItem = PageModel.fromJson(resultData.data);
        setState(() {
          pageItem.records.forEach((element) {
            _feeModelList.add(OtherFeeModel.fromJson(element));
          });
        });
      },
    );
  }
}
