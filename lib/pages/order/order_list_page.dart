import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/order_status_event_bus.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/models/order_model.dart';
import 'package:xiaoyun_user/models/page_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/order/order_detail_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/order/order_list_cell.dart';

class OrderListPage extends StatefulWidget {
  final int status;

  const OrderListPage({Key key, this.status = 0}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController = RefreshController();
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _enableLoad = false;
  List<OrderModel> _orderList = [];
  StreamSubscription _subscription;
  StreamSubscription _loginSubscription;

  @override
  void initState() {
    super.initState();
    _loadDataList();
    _subscription =
        OrderStatusEventBus().on<OrderStateChangedEvent>().listen((event) {
      _currentPage = 1;
      _loadDataList();
    });
    _loginSubscription =
        UserEventBus().on<UserStateChangedEvent>().listen((event) {
      bool isLogin = event.isLogin;
      if (isLogin) {
        _currentPage = 1;
        _loadDataList();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _loginSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      itemCount: _orderList.length,
      itemBuilder: (context, index) {
        OrderModel orderModel = _orderList[index];
        return GestureDetector(
          child: OrderListCell(orderModel: orderModel),
          onTap: () {
            NavigatorUtils.showPage(
              context,
              OrderDetailPage(
                orderId: orderModel.id,
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12),
    );
  }

  void _loadDataList() {
    HttpUtils.get(
      "order/orderList.do",
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
          _orderList.add(OrderModel.fromJson(json));
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

  @override
  bool get wantKeepAlive => true;
}
