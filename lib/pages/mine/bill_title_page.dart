import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/bill_title_model.dart';
import 'package:xiaoyun_user/models/page_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/mine/bill_title_add_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/mine/bill_title_cell.dart';
import 'package:xiaoyun_user/widgets/others/bottom_button_bar.dart';

class BillTitlePage extends StatefulWidget {
  final bool isCheckMode;

  const BillTitlePage({Key key, this.isCheckMode = false}) : super(key: key);
  @override
  _BillTitlePageState createState() => _BillTitlePageState();
}

class _BillTitlePageState extends State<BillTitlePage> {
  List<BillTitleModel> _titleList = [];
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _loadBillTitleList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "发票抬头",
      ),
      body: Column(
        children: [
          Expanded(
            child: CommonRefresher(
              controller: _refreshController,
              scrollView: _buildListView(),
              onRefresh: _loadBillTitleList,
              showEmpty: _titleList.isEmpty,
            ),
          ),
          BottomButtonBar(
            title: "添加发票抬头",
            onPressed: () async {
              bool needRefresh =
                  await NavigatorUtils.showPage(context, BillTitleAddPage());
              if (needRefresh != null && needRefresh) {
                _loadBillTitleList();
              }
            },
          ),
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(Constant.padding),
      itemBuilder: (context, index) {
        BillTitleModel titleModel = _titleList[index];
        return GestureDetector(
          child: BillTitleCell(
            title: titleModel.title,
            isDefault: titleModel.isDefault,
            onDeleteAction: () {
              _deleteAction(index);
            },
          ),
          onTap: () {
            if (widget.isCheckMode) {
              NavigatorUtils.goBackWithParams(context, titleModel);
            }
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: _titleList.length,
    );
  }

  void _deleteAction(int index) {
    BillTitleModel titleModel = _titleList[index];
    HttpUtils.post(
      "userBill/delete.do",
      params: {"id": titleModel.id},
      onSuccess: (resultData) {
        ToastUtils.showSuccess("删除成功");
        _titleList.removeAt(index);
        setState(() {});
      },
    );
  }

  void _loadBillTitleList() {
    HttpUtils.get(
      "userBill/selectByPage.do",
      params: {"size": 100, "index": 1},
      onSuccess: (resultData) {
        _refreshController.refreshCompleted();
        _titleList.clear();
        PageModel pageModel = PageModel.fromJson(resultData.data);
        pageModel.records.forEach((element) {
          _titleList.add(BillTitleModel.fromJson(element));
        });
        setState(() {});
      },
      onError: (msg) {
        _refreshController.refreshCompleted();
      },
    );
  }
}
