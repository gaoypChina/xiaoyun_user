import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/models/car_brand_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/others/group_list_index_widget.dart';
import 'package:xiaoyun_user/widgets/others/group_list_item_widget.dart';

import '../../widgets/common/common_empty_widget.dart';

class CarBrandListPage extends StatefulWidget {
  @override
  _CarBrandListPageState createState() => _CarBrandListPageState();
}

class _CarBrandListPageState extends State<CarBrandListPage> {
  List<CarBrandModel> _brandList = [];
  List<CarBrandModel> _searchBrandList = [];
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _loadCarBrandList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DYAppBar(
        title: "选择车型",
      ),
      body: Column(
        children: [
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: CupertinoSearchTextField(
              controller: _searchController,
              itemSize: 16,
              borderRadius: BorderRadius.circular(18),
              placeholder: "请输入品牌名称",
              style: TextStyle(fontSize: 12),
              prefixInsets: const EdgeInsets.fromLTRB(15, 5, 0, 5),
              suffixInsets: const EdgeInsets.only(right: 15),
              onChanged: (value) {
                List<CarBrandModel> _searchList = [];
                _searchList = _brandList
                    .where((brand) =>
                        brand.pinyin.contains(value.toLowerCase()) ||
                        brand.title.contains(value))
                    .toList();
                setState(() {
                  _searchText = value;
                  _searchBrandList = _searchList;
                });
              },
              onSuffixTap: () {
                setState(() {
                  _searchController.text = "";
                  _searchText = "";
                  _searchBrandList = [];
                });
              },
            ),
          ),
          _buildContentWidget(),
        ],
      ),
    );
  }

  Widget _buildContentWidget() {
    int stackIndex = 0;
    if (_searchBrandList.isEmpty && _searchText.isNotEmpty) {
      stackIndex = 0;
    } else if (_searchText.isNotEmpty) {
      stackIndex = 1;
    } else {
      stackIndex = 2;
    }
    return Expanded(
      child: IndexedStack(
        index: stackIndex,
        children: [
          Container(
            child: Center(
                child: CommonEmptyWidget(
              emptyTips: "暂无结果，换个词试试吧",
            )),
          ),
          ListView.separated(
            itemCount: _searchBrandList.length,
            itemBuilder: (cxt, index) {
              CarBrandModel car = _searchBrandList[index];
              return ListTile(
                title: Text(car.title),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                onTap: () {
                  NavigatorUtils.goBackWithParams(context, car);
                },
              );
            },
            separatorBuilder: (cxt, index) => Divider(height: 1),
          ),
          AzListView(
            data: _brandList,
            itemCount: _brandList.length,
            itemBuilder: (BuildContext context, int index) {
              CarBrandModel model = _brandList[index];
              return GroupListItemWidget(
                name: model.title,
                tag: model.getSuspensionTag(),
                onTap: () {
                  NavigatorUtils.goBackWithParams(context, model);
                },
              );
            },
            padding: EdgeInsets.zero,
            susItemBuilder: (BuildContext context, int index) {
              CarBrandModel model = _brandList[index];
              String tag = model.getSuspensionTag();
              return GroupListIndexWidget(tag: tag);
            },
          ),
        ],
      ),
    );
  }

  void _loadCarBrandList() {
    ToastUtils.showLoading("加载中...");
    HttpUtils.get(
      "car/brandList.do",
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        List dataJsonList = resultData.data as List;
        dataJsonList.forEach((element) {
          _brandList.add(CarBrandModel.fromJson(element));
        });
        SuspensionUtil.sortListBySuspensionTag(_brandList);
        SuspensionUtil.setShowSuspensionStatus(_brandList);
        setState(() {});
      },
    );
  }
}
