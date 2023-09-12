import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'common_empty_widget.dart';

class CommonRefresher extends StatelessWidget {
  final bool showEmpty;
  final RefreshController controller;
  final Widget scrollView;
  final VoidCallback onRefresh;
  final VoidCallback onLoad;
  final String emptyTips;
  final bool isWaterDrop;
  final bool enablePullDown;

  const CommonRefresher({
    Key key,
    this.showEmpty = false,
    this.controller,
    @required this.scrollView,
    this.onRefresh,
    this.onLoad,
    this.emptyTips = '暂无数据',
    this.isWaterDrop = false,
    this.enablePullDown = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: this.onLoad != null,
      enablePullDown: this.enablePullDown,
      controller: controller,
      child: showEmpty
          ? CommonEmptyWidget(
              emptyTips: emptyTips,
            )
          : scrollView,
      onRefresh: onRefresh,
      onLoading: onLoad,
      header: isWaterDrop
          ? WaterDropHeader()
          : ClassicHeader(
              idleText: '下拉刷新',
              completeText: '刷新成功',
              releaseText: '松开刷新',
              refreshingText: '正在刷新数据中...',
            ),
      footer: isWaterDrop
          ? WaterDropHeader()
          : ClassicFooter(
              idleText: '上拉加载更多',
              loadingText: '加载中...',
              canLoadingText: '松开加载更多',
              noDataText: '拉到底啦，没有啦～',
            ),
    );
  }
}
