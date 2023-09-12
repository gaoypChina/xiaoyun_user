import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/bill_history_model.dart';
import 'package:xiaoyun_user/models/page_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/mine/bill_detail_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/mine/bill_history_cell.dart';

class BillHistoryPage extends StatefulWidget {
  @override
  _BillHistoryPageState createState() => _BillHistoryPageState();
}

class _BillHistoryPageState extends State<BillHistoryPage> {
  RefreshController _refreshController = RefreshController();
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _enableLoad = false;
  List<BillHistoryModel> _dataList = [];

  @override
  void initState() {
    super.initState();
    _loadDataList();
  }

  @override
  Widget build(BuildContext context) {
    return CommonRefresher(
      scrollView: _buildListView(),
      controller: _refreshController,
      showEmpty: _dataList.isEmpty,
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
        BillHistoryModel historyModel = _dataList[index];
        return GestureDetector(
          child: BillHistoryCell(
            historyModel: historyModel,
          ),
          onTap: () {
            NavigatorUtils.showPage(
              context,
              BillDetailPage(id: historyModel.id),
            );
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: _dataList.length,
    );
  }

  void _loadDataList() {
    HttpUtils.get(
      "userBill/orderBillPage.do",
      params: {
        "index": _currentPage,
        "size": _pageSize,
      },
      onSuccess: (resultData) {
        PageModel pageModel = PageModel.fromJson(resultData.data);
        if (_currentPage == 1) {
          _dataList.clear();
          _enableLoad = pageModel.pages > 1;
        }
        pageModel.records.forEach((json) {
          _dataList.add(BillHistoryModel.fromJson(json));
        });
        _refreshController.refreshCompleted(
            resetFooterState: _currentPage == 1);
        _refreshController.loadComplete();
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
