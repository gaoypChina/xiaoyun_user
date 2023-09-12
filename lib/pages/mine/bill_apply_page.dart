import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/order_bill_model.dart';
import 'package:xiaoyun_user/models/page_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/mine/bill_apply_submit_page.dart';
import 'package:xiaoyun_user/utils/date_picker_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/picker_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/mine/bill_apply_cell.dart';
import 'package:xiaoyun_user/widgets/others/check_button.dart';

class BillApplyPage extends StatefulWidget {
  @override
  _BillApplyPageState createState() => _BillApplyPageState();
}

class _BillApplyPageState extends State<BillApplyPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController = RefreshController();
  DateTime _startTime;
  DateTime _endTime;
  int _currentPage = 1;
  final int _pageSize = 15;
  bool _enableLoad = false;
  List<OrderBillModel> _dataList = [];
  List<OrderBillModel> _selectedList = [];
  bool _isAllChecked = false;
  double _totalMoney = 0.0;
  double _miniMoney = 0.0;
  List<String> _typeList = ["服务", "充值"];
  int _billType = 0;

  @override
  void initState() {
    super.initState();
    _loadDataList();
    _getMiniMoney();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _buildTimeTool(),
        Expanded(
          child: CommonRefresher(
            scrollView: _buildListView(),
            controller: _refreshController,
            showEmpty: _dataList.isEmpty,
            onRefresh: _loadNewDataList,
            onLoad: _enableLoad
                ? () {
                    _currentPage++;
                    _loadDataList();
                  }
                : null,
          ),
        ),
        _buildToolBar(),
      ],
    );
  }

  Widget _buildToolBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          horizontal: Constant.padding, vertical: 12),
      child: SafeArea(
        child: Row(
          children: [
            CheckButton(
              isChecked: _isAllChecked,
              title: "全选",
              onPressed: () {
                _isAllChecked = !_isAllChecked;
                _selectedList = _isAllChecked ? _dataList : [];
                double totalMoney = 0.0;
                _dataList.forEach((billModel) {
                  billModel.isChecked = _isAllChecked;
                  if (_isAllChecked) {
                    totalMoney += billModel.payFee;
                  }
                });
                _totalMoney = totalMoney;
                setState(() {});
              },
            ),
            Spacer(),
            Offstage(
              offstage: _selectedList.isEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "共：",
                      children: [
                        TextSpan(
                          text: "￥" + _totalMoney.toStringAsFixed(2),
                          style: TextStyle(
                            color: DYColors.text_red,
                          ),
                        )
                      ],
                    ),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${_selectedList.length}个订单",
                    style: TextStyle(color: DYColors.text_gray, fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            CommonActionButton(
              title: "下一步",
              disable: false,
              width: 105,
              onPressed: _showNextStep,
            )
          ],
        ),
      ),
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(Constant.padding),
      itemBuilder: (context, index) {
        OrderBillModel billModel = _dataList[index];
        return BillApplyCell(
          billModel: billModel,
          onCheck: () {
            billModel.isChecked = !billModel.isChecked;
            _configureData();
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: _dataList.length,
    );
  }

  Widget _buildTimeTool() {
    return CommonCard(
      margin: const EdgeInsets.fromLTRB(
          Constant.padding, Constant.padding, Constant.padding, 0),
      padding: const EdgeInsets.symmetric(
          horizontal: Constant.padding, vertical: 12),
      child: Row(
        children: [
          Text("筛选"),
          SizedBox(width: 5),
          _buildTimeBtn("开始时间", dateTime: _startTime, isStart: true),
          Container(
            width: 10,
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: DYColors.divider,
          ),
          _buildTimeBtn("结束时间", dateTime: _endTime, isStart: false),
          Spacer(),
          CupertinoButton(
            color: DYColors.background,
            borderRadius: BorderRadius.circular(6),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minSize: 32,
            child: Row(
              children: [
                Text(
                  _typeList[_billType],
                  style: TextStyle(
                    fontSize: 14,
                    color: DYColors.primary,
                  ),
                ),
                DYLocalImage(
                  imageName: "common_arrow_down",
                  size: 16,
                ),
              ],
            ),
            onPressed: () {
              PickerUtils.showPicker(
                context,
                _typeList,
                index: _billType,
                confirmCallback: (selectedIndex) {
                  setState(() {
                    _billType = selectedIndex;
                  });
                  _refreshController.requestRefresh();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBtn(String placeholder,
      {DateTime dateTime, bool isStart = true}) {
    return CupertinoButton(
      color: DYColors.background,
      minSize: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      borderRadius: BorderRadius.circular(6),
      child: Text(
        dateTime != null
            ? formatDate(dateTime, [yyyy, '-', mm, '-', dd])
            : placeholder,
        style: TextStyle(
          fontSize: 14,
          color: dateTime != null
              ? DYColors.text_normal
              : DYColors.text_light_gray,
        ),
      ),
      onPressed: () {
        _showDatePicker(isStart);
      },
    );
  }

  void _showNextStep() async {
    if (_selectedList.isEmpty) {
      ToastUtils.showInfo("请选择要开票的订单");
      return;
    }
    if (_totalMoney < _miniMoney) {
      ToastUtils.showInfo("最小开票金额为${_miniMoney.toStringAsFixed(2)}元");
      return;
    }
    bool needRefresh = await NavigatorUtils.showPage(
      context,
      BillApplySubmitPage(
        totalMoney: _totalMoney.toStringAsFixed(2),
        orderIds: _selectedList.map((e) => e.id).toList().join(","),
        billType: _billType,
      ),
    );
    if (needRefresh != null && needRefresh) {
      _loadNewDataList();
    }
  }

  void _getMiniMoney() {
    HttpUtils.get(
      "userBill/selMinBillMoney.do",
      onSuccess: (resultData) {
        _miniMoney = double.tryParse(resultData.data["minMoney"]) ?? 0.0;
      },
    );
  }

  void _loadNewDataList() {
    _selectedList = [];
    _totalMoney = 0;
    _isAllChecked = false;
    _currentPage = 1;
    _loadDataList();
  }

  void _configureData() {
    double totalMoney = 0.0;
    bool isAllChecked = true;
    List<OrderBillModel> selectedList = [];
    _dataList.forEach((billModel) {
      if (billModel.isChecked) {
        totalMoney += billModel.payFee;
        selectedList.add(billModel);
      } else {
        isAllChecked = false;
      }
    });
    _selectedList = selectedList;
    _totalMoney = totalMoney;
    _isAllChecked = isAllChecked;
    setState(() {});
  }

  void _showDatePicker(bool isStart) {
    DatePickerUtils.showDatePicker(
      context,
      maxTime: DateTime.now(),
      onConfirm: (time) {
        if (isStart && _endTime != null) {
          if (time.isAfter(_endTime)) {
            ToastUtils.showInfo("开始时间不可晚于结束时间");
            return;
          }
        }
        if (!isStart && _startTime != null) {
          if (time.isBefore(_startTime)) {
            ToastUtils.showInfo("结束时间不可早于开始时间");
            return;
          }
        }
        if (isStart) {
          _startTime = time;
        } else {
          _endTime = time;
        }
        setState(() {});
        _loadNewDataList();
      },
    );
  }

  void _loadDataList() {
    Map<String, dynamic> params = {
      "index": _currentPage,
      "size": _pageSize,
      "billType": _billType,
    };
    if (_startTime != null) {
      params["staDate"] = formatDate(_startTime, [yyyy, '-', mm, '-', dd]);
    }
    if (_endTime != null) {
      params["endDate"] = formatDate(_endTime, [yyyy, '-', mm, '-', dd]);
    }
    HttpUtils.get(
      "userBill/selectOrderList.do",
      params: params,
      onSuccess: (resultData) {
        PageModel pageModel = PageModel.fromJson(resultData.data);
        if (_currentPage == 1) {
          _dataList.clear();
          _enableLoad = pageModel.pages > 1;
        }
        pageModel.records.forEach((json) {
          _dataList.add(OrderBillModel.fromJson(json));
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

  @override
  bool get wantKeepAlive => true;
}
