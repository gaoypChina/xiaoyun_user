import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/coupon_model.dart';
import 'package:xiaoyun_user/models/page_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_empty_widget.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/mine/discount_coupon_cell.dart';

class InvalidDiscountCouponPage extends StatefulWidget {
  @override
  _InvalidDiscountCouponPageState createState() =>
      _InvalidDiscountCouponPageState();
}

class _InvalidDiscountCouponPageState extends State<InvalidDiscountCouponPage> {
  List<CouponModel> _couponList = [];
  @override
  void initState() {
    super.initState();
    _loadCouponList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "无效券",
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(Constant.padding),
        itemBuilder: (context, index) {
          if (_couponList.isEmpty) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: CommonEmptyWidget(),
            );
          } else {
            return DiscountCouponCell(
              isInvalid: true,
              couponModel: _couponList[index],
            );
          }
        },
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemCount: _couponList.isEmpty ? 1 : _couponList.length,
      ),
    );
  }

  void _loadCouponList() {
    HttpUtils.get(
      "userCoupon/selectByPage.do",
      params: {"status": 0, "size": 100, "index": 1},
      onSuccess: (resultData) {
        _couponList.clear();
        PageModel pageModel = PageModel.fromJson(resultData.data);
        pageModel.records.forEach((element) {
          _couponList.add(CouponModel.fromJson(element));
        });
        setState(() {});
      },
    );
  }
}
