import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/models/coupon_model.dart';
import 'package:xiaoyun_user/models/service_phone_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/home/city_page.dart';
import 'package:xiaoyun_user/utils/common_utils.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/sp_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/home/home_action_btn.dart';
import 'package:xiaoyun_user/widgets/home/home_center_marker.dart';
import 'package:xiaoyun_user/widgets/home/home_menu_btn.dart';
import 'package:xiaoyun_user/widgets/home/home_menu_card.dart';
import 'package:xiaoyun_user/widgets/home/home_top_bar.dart';
import 'package:xiaoyun_user/widgets/others/new_user_coupon_dialog.dart';

import '../../routes/routes.dart';
import '../../widgets/others/coupon_info_dialog.dart';
import 'scanner_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  AmapController? _controller;
  double _menuCardHeight = 264;
  String _address = "请选择具体位置";
  String _cityName = "定位中";
  String _locationCity = "";
  bool _isMapMoveEnd = false;
  bool _isChangeMode = false;
  Poi? _currentPoi;
  String? _staffCode;
  String? _deviceId;

  late StreamSubscription _subscription;
  List<ServicePhoneModel> _servicePhoneList = [];

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _subscription = UserEventBus().on<UserStateChangedEvent>().listen((event) {
      bool isRegister = event.isRegister;
      if (isRegister) {
        _loadCouponList();
      }
    });
    _getDeviceId();
  }

  void _getDeviceId() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await _deviceInfo.iosInfo;
      _deviceId = iosDeviceInfo.identifierForVendor??'';
    } else {
      AndroidDeviceInfo androidDeviceInfo = await _deviceInfo.androidInfo;
      _deviceId = androidDeviceInfo.id??'';
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [Permission.location,].request();
    bool serviceStatus = await Permission.location.serviceStatus.isEnabled;
    if (statuses[Permission.location] == PermissionStatus.granted && serviceStatus) {
      Location location = await AmapLocation.instance.fetchLocation(needAddress: true);
      SpUtil.putStringList(Constant.latLng, [
        location.latLng!.latitude.toString(),
        location.latLng!.longitude.toString(),
      ]);
      _cityName = location.city??'';
      _locationCity = _cityName;
      _controller?.showMyLocation(
        MyLocationOption(show: true),
      );
    } else {
      ToastUtils.showError("定位失败\n请打开定位权限");
      _cityName = "定位失败";
      _locationCity = "定位失败";
    }
    setState(() {});
  }

  void _showCouponDialog(List<CouponModel> couponList) {
    DialogUtils.showCustomDialog(
      context: context,
      backgroundColor: Colors.transparent,
      child: NewUserCouponDialog(
        couponList: couponList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Flexible(
              child: Stack(
                children: [
                  _buildAmapView(),
                  _buildHomeTopBar(context),
                  HomeCenterMarker(
                    isEnd: _isMapMoveEnd,
                  ),
                  Positioned(
                    left: Constant.padding,
                    bottom: 40,
                    child: _buildServiceBtn(),
                  ),
                  Positioned(
                    right: Constant.padding,
                    bottom: 40,
                    child: _buildLocationBtn(),
                  )
                ],
              ),
            ),
            SizedBox(height: _menuCardHeight - 25),
          ],
        ),
        Positioned(
          bottom: 0,
          child: _buildHomeMenuCard(),
        ),
      ],
    );
  }

  Widget _buildHomeTopBar(BuildContext context) {
    return HomeTopBar(
      city: _cityName,
      onScanAction: _scanAction,
      onCityPressed: () async {
        String? selectedCity = await NavigatorUtils.showPage(context, CityPage(locationCity: _locationCity));
        if (selectedCity == null || selectedCity == _cityName) return;
        _cityName = selectedCity;
        List poiList = await AmapSearch.instance.searchKeyword(_cityName, city: _cityName, pageSize: 1);
        _currentPoi = poiList.first;
        _controller?.setCenterCoordinate(_currentPoi!.latLng!);},
    );
  }

  Widget _buildHomeMenuCard() {
    return HomeMenuCard(
      address: _address,
      height: _menuCardHeight,
      poi: _currentPoi??Poi(),
      locationCity: _locationCity,
      staffCode: _staffCode,
      menuChanged: (menuType) {
        _menuCardHeight = menuType == HomeMenuType.now ? 264 : 330;
        setState(() {});
      },
      onAddressChanged: (poi) {
        _currentPoi = poi;
        _address = poi.title??'';
        _cityName = poi.cityName??'';
        setState(() {});
        _controller?.setCenterCoordinate(poi.latLng!, animated: false);
        _isChangeMode = true;
        Future.delayed(Duration(milliseconds: 2000), () {
          _isChangeMode = false;
        });
      },
      showNextPageEnd: () {
        setState(() {
          _staffCode = '';
        });
      },
    );
  }

  Widget _buildServiceBtn() {
    return HomeActionBtn(
      imageName: "home_service_icon",
      title: "客服",
      onPressed: () {
        if (_servicePhoneList.isEmpty) {
          _getCustomerPhoneList();
        } else {
          _showPhoneDialog();
        }
      },
    );
  }

  Widget _buildLocationBtn() {
    return HomeActionBtn(
      imageName: "home_location_icon",
      onPressed: () {
        _requestPermission();
      },
    );
  }

  AmapView _buildAmapView() {
    List<String> latLngList = SpUtil.getStringList(Constant.latLng);
    LatLng? latLng;
    if (latLngList.length >= 2) {
      latLng = LatLng(
        double.tryParse(latLngList[0])??0,
        double.tryParse(latLngList[1])??0,
      );
    }
    return AmapView(
      mapType: MapType.Standard,
      showZoomControl: false,
      showCompass: false,
      showScaleControl: false,
      zoomLevel: 15,
      centerCoordinate: latLng,
      maskDelay: Duration(milliseconds: 500),
      onMapCreated: (controller) async {
        _controller = controller;
        _controller!.showCompass(false);
        _controller!.setZoomLevel(15);
        await _controller!.showMyLocation(
          MyLocationOption(
            show: true,
            myLocationType: MyLocationType.Locate,
          ),
        );
        print("onMapCreated ");
        if (latLng != null) {
          _getCurrentAddress(latLng);
        }
      },
      onMapMoveStart: (move) async {
        print("onMapMoveStart");
        if (_isChangeMode) {
          print("onMapMoveStart return");
          return;
        }
        _isMapMoveEnd = false;
        _address = "正在获取位置";

        setState(() {});
      },
      onMapMoveEnd: (move) async {
        print("onMapMoveEnd");

        if (_isChangeMode) {
          print("onMapMoveEnd return");
          return;
        }
        _isMapMoveEnd = true;
        // ReGeocode reGeocode =
        //     await AmapSearch.instance.searchAround(move.coordinate);
        //  List<Poi> poiList = reGeocode.poiList;
        _getCurrentAddress(move.coordinate!);
      },
    );
  }

  void _getCurrentAddress(LatLng coordinate) async {
    List<Poi> poiList = await AmapSearch.instance.searchAround(coordinate);

    if (poiList.isEmpty) {
      setState(() {
        _address = "获取位置信息失败";
        _currentPoi = Poi();
      });
      return;
    }

    setState(() {
      Poi currentPoi = poiList.first;
      _address = currentPoi.title??'';
      _currentPoi = currentPoi;
    });
  }

  void _scanAction() async {
    bool isLogin = SpUtil.getBool(Constant.loginState);
    if (!isLogin) {
      NavigatorUtils.push(context, Routes.login);
      return;
    }
    String code = await NavigatorUtils.showPage(context, ScannerPage());
    if (code.isNotEmpty) {
      _verifyCode(code);
    }
  }

  void _verifyCode(String code) {
    Map<String, dynamic> couponDict;
    try {
      couponDict = jsonDecode(code);
      String type = couponDict["type"] ?? "";
      if (type == "coupon") {
        String couponCode = couponDict["content"];
        _getCouponDetail(couponCode);
      } else {
        ToastUtils.showError("无效的二维码");
      }
    } on FormatException catch (_) {
      _queryStaffInfo(code);
    }
  }

  void _queryStaffInfo(String code) {
    ToastUtils.showLoading("校验中...");
    HttpUtils.get(
      "order/queryStaff.do",
      params: {"staffId": code},
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        DialogUtils.showAlertDialog(
          context,
          message: "扫码成功，赶快去下单吧",
          confirmAction: () {
            setState(() {
              _staffCode = code;
            });
          },
        );
      },
    );
  }

  void _loadCouponList() {
    HttpUtils.get(
      "user/newUserCounponMessage.do",
      onSuccess: (resultData) {
        List<CouponModel> couponList = [];
        List couponJsonList = resultData.data["records"] as List;
        couponJsonList.forEach((element) {
          couponList.add(CouponModel.fromJson(element));
        });
        if (couponList.isNotEmpty) {
          _showCouponDialog(couponList);
        }
      },
    );
  }

  void _getCustomerPhoneList() {
    ToastUtils.showLoading("加载中...");
    HttpUtils.get(
      'user/getCustomerServiceTelephone.do',
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        List phoneList = resultData.data;
        _servicePhoneList =
            phoneList.map((e) => ServicePhoneModel.fromJson(e)).toList();
        if (_servicePhoneList.isEmpty) {
          ToastUtils.showInfo("暂时无法联系客服，请稍后再试");
        } else {
          _showPhoneDialog();
        }
      },
    );
  }

  void _showPhoneDialog() {
    DialogUtils.showActionSheetDialog(
      context,
      dialogItems: _servicePhoneList
          .map(
            (phoneModel) => ActionSheetDialogItem(
              title: "${phoneModel.name} ${phoneModel.phone}",
              onPressed: () {
                CommonUtils.launchTelUrl(phoneModel.phone);
              },
            ),
          )
          .toList(),
    );
  }

  void _showCounponInfoDialog(CouponModel coupon) {
    DialogUtils.showCustomDialog(
      context: context,
      backgroundColor: Colors.transparent,
      child: CouponInfoDialog(
        coupon: coupon,
        onAction: () {
          _receiveCoupon(coupon.couponCode);
        },
      ),
    );
  }

  void _getCouponDetail(String code) {
    if (code.isEmpty) {
      ToastUtils.showInfo("无效的兑换码");
      return;
    }
    HttpUtils.get(
      "userCoupon/getCouponDetail.do",
      params: {"couponCode": code},
      onSuccess: (resultData) {
        CouponModel coupon = CouponModel.fromJson(resultData.data);
        if (coupon.activityStatus == 0) {
          ToastUtils.showError("优惠券不存在");
          return;
        }
        _showCounponInfoDialog(coupon);
      },
    );
  }

  void _receiveCoupon(String code) {
    HttpUtils.get(
      "userCoupon/toReceiveCoupon.do",
      params: {"couponCode": code, "deviceId": _deviceId ?? ""},
      onSuccess: (resultData) {
        ToastUtils.showSuccess("领取成功");
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
