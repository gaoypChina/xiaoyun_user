import 'package:flutter/material.dart';
import 'package:xiaoyun_user/pages/mine/bill_apply_page.dart';
import 'package:xiaoyun_user/pages/mine/bill_history_page.dart';
import 'package:xiaoyun_user/pages/mine/bill_title_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/others/top_tab_bar.dart';

class BillPage extends StatefulWidget {
  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "发票",
        actions: [
          NavigationItem(
            title: "发票抬头",
            onPressed: () {
              NavigatorUtils.showPage(context, BillTitlePage());
            },
          )
        ],
        bottom: TopTabBar(
          controller: _tabController,
          tabs: ["申请开票", "开票历史"],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BillApplyPage(),
          BillHistoryPage(),
        ],
      ),
    );
  }
}
