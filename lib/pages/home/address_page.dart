import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/city_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/home/city_content_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_empty_widget.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/home/address_cell.dart';
import 'package:xiaoyun_user/widgets/home/address_search_field.dart';

class AddressPage extends StatefulWidget {
  final LatLng? latLng;
  final String? cityName;
  final String locationCity;

  const AddressPage(
      {super.key, this.latLng, this.cityName, required this.locationCity});
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<Poi> _poiList = [];
  late String _cityName;
  bool _cityEditing = false;
  List<CityModel> _cityList = [];

  TextEditingController _cityController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  FocusNode _cityNode = FocusNode();
  FocusNode _addressNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _cityName = widget.cityName??'';
    _cityController.text = _cityName;
    _addressNode.requestFocus();
    _searchAddress(center: widget.latLng);
    _loadCityList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          )
        ],
      ),
      body: _cityEditing ? _buildCityContent() : _buildAddressView(),
    );
  }

  Widget _buildCityContent() {
    return CityContentPage(
      cityList: _cityList,
      locationCity: widget.locationCity,
      searchKeywords: _cityController.text,
      onSelected: (city) {
        _cityName = city.name;
        _cityController.text = city.name;
        _addressNode.requestFocus();
        _cityEditing = false;
        setState(() {});
        _searchAddress(keyword: city.name);
      },
    );
  }

  Widget _buildAddressView() {
    return _poiList.isEmpty
        ? Container(
            child: Center(
              child: CommonEmptyWidget(),
            ),
          )
        : ListView.separated(
            padding: Constant.horizontalPadding,
            separatorBuilder: (context, index) => Divider(height: 0.5),
            itemBuilder: (context, index) {
              Poi poi = _poiList[index];
              return InkWell(
                child: AddressCell(
                  name: poi.title??'',
                  address: '${poi.provinceName}' + '${poi.cityName}' + '${poi.adName}' + '${poi.address}',
                ),
                onTap: () {
                  NavigatorUtils.goBackWithParams(context, poi);
                },
              );
            },
            itemCount: _poiList.length,
          );
  }

  Widget _buildSearchField() {
    return AddressSearchField(
      cityEditing: _cityEditing,
      cityController: _cityController,
      addressController: _addressController,
      cityNode: _cityNode,
      addressNode: _addressNode,
      cityOnTap: () {
        _cityEditing = true;
        _cityController.text = "";
        setState(() {});
      },
      cityOnChanged: (value) {
        setState(() {});
      },
      cityOnSubmit: (value) {
        _cityEditing = false;
        _cityController.text = _cityName;
        setState(() {});
      },
      addressOnTap: () {
        _cityEditing = false;
        _cityController.text = _cityName;
        setState(() {});
      },
      addressOnSubmitted: (value) async {
        if (value.isNotEmpty) {
          _searchAddress(keyword: value);
        }
      },
    );
  }

  void _searchAddress({LatLng? center, String? keyword}) async {
    if (center != null) {
      _poiList = await AmapSearch.instance
          .searchAround(center, city: _cityName, pageSize: 10);
    } else {
      _poiList = await AmapSearch.instance
          .searchKeyword(keyword??'', city: _cityName, pageSize: 10);
      print(_poiList);
    }
    setState(() {});
  }

  void _loadCityList() {
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
