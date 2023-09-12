import 'package:flutter/material.dart';
import 'package:xiaoyun_user/pages/order/after_sale_list_page.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/others/top_tab_bar.dart';

class AfterSalePage extends StatefulWidget {
  @override
  _AfterSalePageState createState() => _AfterSalePageState();
}

class _AfterSalePageState extends State<AfterSalePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> _tabTitles = ["全部", "待审核", "退款中", "已退款", "已拒绝"];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "售后记录",
        bottom: TopTabBar(
          tabs: _tabTitles,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(
          _tabTitles.length,
          (index) => AfterSaleListPage(status: index),
        ),
      ),
    );
  }
}
