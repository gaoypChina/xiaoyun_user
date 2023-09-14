import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/balance_model.dart';
import 'package:xiaoyun_user/models/page_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/picker_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/mine/balance_cell.dart';

class BalanceDetailPage extends StatefulWidget {
  const BalanceDetailPage({super.key});

  @override
  State<BalanceDetailPage> createState() => _BalanceDetailPageState();
}

class _BalanceDetailPageState extends State<BalanceDetailPage> {
  List<String> _typeList = ["全部", "充值", "订单退款", "订单支付", "其他"];
  RefreshController _refreshController = RefreshController();
  List<BalanceModel> _balanceList = [];
  int _menuIndex = -1;
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _enableLoad = false;
  String _type = "全部";

  @override
  void initState() {
    super.initState();
    _loadBalanceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(title: "余额明细"),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("收支类型"),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                child: Row(children: [
                  Text(
                    _type,
                    style: TextStyle(
                      fontSize: 14,
                      color: DYColors.text_normal,
                    ),
                  ),
                  DYLocalImage(
                    imageName: "common_arrow_down",
                    size: 16,
                  ),
                ]),
                onPressed: () {
                  PickerUtils.showPicker(
                    context,
                    _typeList,
                    confirmCallback: (selectedIndex) {
                      if (selectedIndex == 0) {
                        _menuIndex = -1;
                      } else if (selectedIndex == 4) {
                        _menuIndex = 0;
                      } else {
                        _menuIndex = selectedIndex;
                      }
                      setState(() {
                        _type = _typeList[selectedIndex];
                      });
                      _refreshController.requestRefresh();
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: CommonRefresher(
            controller: _refreshController,
            scrollView: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 15),
              itemCount: _balanceList.length,
              itemBuilder: (context, index) {
                return BalanceCell(balanceItem: _balanceList[index]);
              },
            ),
            showEmpty: _balanceList.isEmpty,
            onRefresh: () {
              _currentPage = 1;
              _loadBalanceList();
            },
            onLoad: _enableLoad
                ? () {
                    _currentPage++;
                    _loadBalanceList();
                  }
                : null,
          ),
        )
      ],
    );
  }

  void _loadBalanceList() {
    Map<String, dynamic> params = {"index": _currentPage, "size": _pageSize};
    if (_menuIndex != -1) {
      params["type"] = _menuIndex;
    }
    HttpUtils.get(
      "userHome/getUserBalancePage.do",
      params: params,
      onSuccess: (resultData) {
        PageModel pageModel = PageModel.fromJson(resultData.data);
        if (_currentPage == 1) {
          _balanceList.clear();
          _enableLoad = pageModel.pages > 1;
        }
        pageModel.records.forEach((json) {
          _balanceList.add(BalanceModel.fromJson(json));
        });
        _refreshController.refreshCompleted(
            resetFooterState: _currentPage == 1);
        _refreshController.loadComplete();
        if (_balanceList.length == pageModel.total) {
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
