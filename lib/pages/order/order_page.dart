import 'package:flutter/material.dart';
import 'package:xiaoyun_user/pages/order/order_list_page.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/others/top_tab_bar.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final List<String> _tabs = ["全部", "待分配", "待服务", "已完成", "售后"];
  final List<int> _statusList = [0, 1, 2, 4, 5];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: DYAppBar(
        title: "订单",
        showBack: false,
        titleWidget: TopTabBar(
          tabs: _tabs,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(
          _tabs.length,
          (index) => OrderListPage(
            status: _statusList[index],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
