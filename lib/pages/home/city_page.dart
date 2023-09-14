import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/city_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/home/city_content_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';

class CityPage extends StatefulWidget {
  final String locationCity;

  const CityPage({super.key, required this.locationCity});

  @override
  State<StatefulWidget> createState() {
    return _CityPageState();
  }
}

class _CityPageState extends State<CityPage> {
  late List<CityModel> _cityList;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _cityList = [];
    _searchController = TextEditingController();
    _loadCityList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DYAppBar(
        showBack: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        titleWidget: _buildSearchField(),
        actions: [
          NavigationItem(
            title: "取消",
            onPressed: () {
              NavigatorUtils.goBack(context);
            },
          ),
        ],
      ),
      body: CityContentPage(
        cityList: _cityList,
        locationCity: widget.locationCity,
        searchKeywords: _searchController.text,
        onSelected: (city) {
          NavigatorUtils.goBackWithParams(context, city.name);
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.only(left: Constant.padding),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 36,
      child: DYTextField(
        placeholder: "请输入您所在城市",
        textInputAction: TextInputAction.search,
        controller: _searchController,
        onChanged: (value) {
          setState(() {});
        },
      ),
      decoration: BoxDecoration(
        color: DYColors.search_bar,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void _loadCityList() async {
    ToastUtils.showLoading("加载中...");
    HttpUtils.get(
      "approve/cityList.do",
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        List cityJsonList = resultData.data as List;
        cityJsonList.forEach((element) {
          _cityList.add(CityModel.fromJson(element));
        });
        SuspensionUtil.sortListBySuspensionTag(_cityList);
        SuspensionUtil.setShowSuspensionStatus(_cityList);
        setState(() {});
      },
    );
  }
}
