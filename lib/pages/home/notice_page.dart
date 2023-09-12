import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/notice_model.dart';
import 'package:xiaoyun_user/models/page_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/order/order_detail_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
// import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/home/notice_cell.dart';

import '../../utils/toast_utils.dart';
import '../../widgets/common/navigation_item.dart';

// import 'chat_list_page.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  RefreshController _refreshController = RefreshController();
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _enableLoad = false;
  List<NoticeModel> _dataList = [];

  @override
  void initState() {
    super.initState();
    _loadDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DYAppBar(
          title: "消息中心",
          actions: [
            // NavigationItem(
            //   title: "聊天",
            //   onPressed: () {
            //     NavigatorUtils.showPage(
            //       context,
            //       ChatListPage(),
            //     );
            //   },
            // )
            NavigationItem(
              title: "一键已读",
              onPressed: _markAllRead,
            )
          ],
        ),
        body: CommonRefresher(
          controller: _refreshController,
          scrollView: _buildListView(),
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
        ));
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(Constant.padding),
      itemBuilder: (context, index) {
        NoticeModel noticeModel = _dataList[index];
        return GestureDetector(
          child: NoticeCell(noticeModel: noticeModel),
          onTap: () {
            if (!noticeModel.isRead) {
              _markRead(noticeModel);
            }
            if (noticeModel.messageChildType > 5) return;
            NavigatorUtils.showPage(
              context,
              OrderDetailPage(
                orderId: noticeModel.orderId,
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: _dataList.length,
    );
  }

  void _markRead(NoticeModel noticeModel) {
    HttpUtils.get(
      "user/readMessageById.do",
      params: {"id": noticeModel.id},
      onSuccess: (resultData) {
        setState(() {
          noticeModel.isRead = true;
        });
      },
    );
  }

  void _markAllRead() {
    ToastUtils.showLoading();
    HttpUtils.get(
      "user/readMessage.do",
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        _currentPage = 1;
        _loadDataList();
      },
    );
  }

  void _loadDataList() {
    HttpUtils.get(
      "user/userMessageCenter.do",
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
          _dataList.add(NoticeModel.fromJson(json));
        });
        _refreshController.refreshCompleted(
            resetFooterState: _currentPage == 1);
        _refreshController.loadComplete();
        if (_dataList.length == pageModel.total) {
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
