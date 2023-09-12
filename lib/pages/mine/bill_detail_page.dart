import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/bill_history_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_info_cell.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/others/common_dot.dart';

class BillDetailPage extends StatefulWidget {
  final int id;

  const BillDetailPage({Key key, @required this.id}) : super(key: key);

  @override
  _BillDetailPageState createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  final gradient = LinearGradient(
    colors: [Color(0xff4ACBFF), Color(0xff00A2FF)],
  );

  bool _isOpen = false;
  BillHistoryDetailModel _detailModel;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        gradient: gradient,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleWidget: Text(
          "发票详情",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        leading: NavigationItem(
          iconName: "navigation_back_white",
          onPressed: () {
            NavigatorUtils.goBack(context);
          },
        ),
      ),
      body: _detailModel == null ? Container() : _buildScrollView(),
    );
  }

  Widget _buildScrollView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeaderView(),
        ),
        SliverPadding(
          padding: Constant.horizontalPadding,
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                CommonCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Constant.padding),
                  child: Column(
                    children: [
                      CommonInfoCell(
                        title: _detailModel.headType == 1 ? "公司名称" : "抬头名称",
                        subtitle: _detailModel.billTitle,
                      ),
                      if (_detailModel.headType == 1)
                        CommonInfoCell(
                          title: "公司税号",
                          subtitle: _detailModel.dutyNo,
                        ),
                      if (_isOpen && _detailModel.headType == 1)
                        _buildHiddenInfo(),
                      CommonInfoCell(
                        title: "发票金额",
                        subtitle: "${_detailModel.priceMoney}元",
                      ),
                      CommonInfoCell(
                        title: "申请时间",
                        subtitle: _detailModel.createTime,
                        hiddenDivider: true,
                      ),
                      if (_detailModel.headType == 1)
                        CupertinoButton(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isOpen ? "收起" : "展开更多信息",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: DYColors.text_gray,
                                ),
                              ),
                              Icon(
                                _isOpen
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                size: 24,
                                color: DYColors.text_gray,
                              )
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              _isOpen = !_isOpen;
                            });
                          },
                        )
                    ],
                  ),
                ),
                SizedBox(height: 12),
                CommonCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Constant.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonInfoCell(
                        title: "接收邮箱",
                        subtitle: _detailModel.email,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: Constant.padding),
                        child: Text("含${_detailModel.no.length}个订单"),
                      ),
                      ..._orderNoList(),
                      SizedBox(height: 16),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _orderNoList() {
    return List.generate(
      _detailModel.no.length,
      (index) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            CommonDot(
              color: DYColors.yellowDot,
            ),
            SizedBox(width: 8),
            Text(
              _detailModel.no[index],
              style: TextStyle(
                color: DYColors.text_gray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHiddenInfo() {
    return Column(
      children: [
        CommonInfoCell(
          title: "注册地址",
          subtitle:
              _detailModel.regAddress.isEmpty ? "无" : _detailModel.regAddress,
        ),
        CommonInfoCell(
          title: "注册电话",
          subtitle: _detailModel.regPhone.isEmpty ? "无" : _detailModel.regPhone,
        ),
        CommonInfoCell(
          title: "开户银行",
          subtitle: _detailModel.openBank.isEmpty ? "无" : _detailModel.openBank,
        ),
        CommonInfoCell(
          title: "银行账号",
          subtitle: _detailModel.bankNo.isEmpty ? "无" : _detailModel.bankNo,
        ),
      ],
    );
  }

  Container _buildHeaderView() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: Constant.padding, bottom: 30),
            child: Text(
              _detailModel.status == 1 ? "已开票" : "待开票",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 25,
            decoration: BoxDecoration(
              color: DYColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _loadDetail() {
    HttpUtils.get(
      "userBill/detail.do",
      params: {"id": widget.id},
      onSuccess: (resultData) {
        _detailModel = BillHistoryDetailModel.fromJson(resultData.data);
        setState(() {});
      },
    );
  }
}
