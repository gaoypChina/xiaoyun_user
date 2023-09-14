import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/car_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/mine/car_add_page.dart';
import 'package:xiaoyun_user/routes/route_export.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/mine/my_car_cell.dart';
import 'package:xiaoyun_user/widgets/others/bottom_button_bar.dart';

class MyCarPage extends StatefulWidget {
  final bool isSelectModel;

  const MyCarPage({super.key, this.isSelectModel = false});
  @override
  _MyCarPageState createState() => _MyCarPageState();
}

class _MyCarPageState extends State<MyCarPage> {
  late RefreshController _refreshController;

  List<CarModel> _carList = [];
  @override
  void initState() {
    super.initState();
    _loadCarList();
    _refreshController = RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "我的车库",
      ),
      body: Column(
        children: [
          Expanded(
            child: CommonRefresher(
              controller: _refreshController,
              scrollView: _buildListView(),
              onRefresh: _loadCarList,
              showEmpty: _carList.isEmpty,
            ),
          ),
          BottomButtonBar(
            title: "添加车辆",
            onPressed: () async {
              bool needRefresh = await NavigatorUtils.push(context, Routes.addCar);
              if (needRefresh) {
                _loadCarList();
              }
            },
          )
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(Constant.padding),
      itemBuilder: (context, index) {
        CarModel carModel = _carList[index];
        return GestureDetector(
          child: MyCarCell(carModel: carModel),
          onTap: () async {
            if (widget.isSelectModel) {
              NavigatorUtils.goBackWithParams(context, carModel);
              return;
            }
            bool needRefresh = await NavigatorUtils.showPage(
              context,
              CarAddPage(
                isEdit: true,
                carModel: carModel,
              ),
            );
            if (needRefresh) {
              _loadCarList();
            }
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: _carList.length,
    );
  }

  void _loadCarList() {
    ToastUtils.showLoading("加载中...");
    HttpUtils.get(
      "car/selectByPage.do",
      params: {"index": 1, "size": 100},
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        _refreshController.refreshCompleted();
        _carList.clear();
        List dataJsonList = resultData.data["records"] as List;
        dataJsonList.forEach((element) {
          _carList.add(CarModel.fromJson(element));
        });
        setState(() {});
      },
      onError: (msg) {
        ToastUtils.dismiss();
        _refreshController.refreshCompleted();
      },
    );
  }
}
