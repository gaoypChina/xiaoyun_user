import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/after_sale_order.dart';
import 'package:xiaoyun_user/models/page_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/order/after_sale_detail_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/order/after_sale_cell.dart';

class AfterSaleListPage extends StatefulWidget {
  final int status;

  const AfterSaleListPage({super.key, this.status = 0});

  @override
  _AfterSaleListPageState createState() => _AfterSaleListPageState();
}

class _AfterSaleListPageState extends State<AfterSaleListPage> {
  RefreshController _refreshController = RefreshController();
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _enableLoad = false;
  List<AfterSaleOrder> _orderList = [];

  @override
  void initState() {
    super.initState();
    _loadDataList();
  }

  @override
  Widget build(BuildContext context) {
    return CommonRefresher(
      controller: _refreshController,
      scrollView: _buildListView(),
      showEmpty: _orderList.isEmpty,
      emptyTips: "暂无相关订单",
      onRefresh: () {
        _currentPage = 1;
        _loadDataList();
      },
      onLoad: _enableLoad
          ? () {
              _currentPage++;
              _loadDataList();
            }
          : null,
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(Constant.padding),
      itemBuilder: (context, index) {
        AfterSaleOrder orderModel = _orderList[index];
        return GestureDetector(
          child: AfterSaleCell(
            orderModel: orderModel,
            onRepeal: () {
              _repealAction(orderModel.id);
            },
          ),
          onTap: () {
            NavigatorUtils.showPage(
              context,
              AfterSaleDetailPage(orderId: orderModel.id),
            ).then((value) {
              if (value != null && value) {
                _refreshController.requestRefresh();
              }
            });
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: _orderList.length,
    );
  }

  void _repealAction(int orderId) {
    HttpUtils.get(
      "order/cancelPetition.do",
      params: {"orderId": orderId},
      onSuccess: (resultData) {
        ToastUtils.showSuccess("撤销成功");
        Future.delayed(Duration(seconds: 1)).then(
          (value) => _refreshController.requestRefresh(),
        );
      },
    );
  }

  void _loadDataList() {
    HttpUtils.get(
      "order/customerOrderList.do",
      params: {
        "index": _currentPage,
        "size": _pageSize,
        "status": widget.status
      },
      onSuccess: (resultData) {
        PageModel pageModel = PageModel.fromJson(resultData.data);
        if (_currentPage == 1) {
          _orderList.clear();
          _enableLoad = pageModel.pages > 1;
        }
        pageModel.records.forEach((json) {
          _orderList.add(AfterSaleOrder.fromJson(json));
        });
        _refreshController.refreshCompleted(
            resetFooterState: _currentPage == 1);
        _refreshController.loadComplete();
        if (_orderList.length == pageModel.total) {
          _refreshController.loadNoData();
        }

        if (!mounted) return;
        setState(() {});
      },
      onError: (msg) {
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
      },
    );
  }
}
