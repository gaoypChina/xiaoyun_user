import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/service_project_model.dart';
import 'package:xiaoyun_user/models/store_show_entity.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/home/address_page.dart';
import 'package:xiaoyun_user/pages/order/confirm_order_page.dart';
import 'package:xiaoyun_user/routes/route_export.dart';
import 'package:xiaoyun_user/utils/bottom_sheet_utils.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/sp_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/home/store_selection_widget.dart';
import 'package:xiaoyun_user/widgets/others/common_dot.dart';

import 'home_menu_btn.dart';
import 'home_select_btn.dart';
import 'service_selection_widget.dart';
import 'appointment_time_widget.dart';

class HomeMenuCard extends StatefulWidget {
  final Poi poi;
  final String? address;
  final double? height;
  final String? staffCode;
  final Function(HomeMenuType menuType)? menuChanged;
  final Function(Poi poi)? onAddressChanged;
  final Function()? showNextPageEnd;
  final String locationCity;

  const HomeMenuCard({
    super.key,
    required this.poi,
    this.height,
    this.menuChanged,
    this.onAddressChanged,
    this.showNextPageEnd,
    this.address,
    required this.locationCity,
    this.staffCode,
  });

  @override
  _HomeMenuCardState createState() => _HomeMenuCardState();
}

class _HomeMenuCardState extends State<HomeMenuCard> {
  HomeMenuType _menuType = HomeMenuType.now;
  late String _address;
  Poi? _currentPoi;
  String? _dateTimeStr;
  ///门店名称
  String? _storeName;
  DateTime? _startDate;

  List<ServiceProjectModel> _projectList = [];
  List<ServiceProjectModel> _selectedProjectList = [];
  List<StoreShowEntity> _storeList = [];
  List<StoreShowEntity> _selectStoreList = [];

  @override
  void didUpdateWidget(covariant HomeMenuCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _address = widget.address??'';
    _currentPoi = widget.poi;
  }

  @override
  void initState() {
    super.initState();
    _address = widget.address??'';
    _currentPoi = widget.poi;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: ScreenUtil().screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: Constant.padding, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeMenuBtn(
            menuType: _menuType,
            menuBtnClicked: (menuType) {
              _menuType = menuType;
              setState(() {});
              widget.menuChanged?.call(menuType);
            },
          ),
          SizedBox(height: Constant.padding),
          _buildAddressBtn(context),
          // ///地址选择
          // Offstage(
          //   offstage: _menuType == HomeMenuType.storeService,
          //   child: _buildAddressBtn(context),
          // ),
          // ///门店选择
          // Offstage(
          //   offstage: _menuType == HomeMenuType.callService,
          //   child: HomeSelectBtn(
          //     placeholder: "请选择门店",
          //     value: _selectStoreList.isEmpty
          //         ? ""
          //         : _selectStoreList.map((project) => project.name).toList().join("/"),
          //     onPressed: _showStoreView,
          //   ),
          // ),
          // Offstage(
          //   offstage: _menuType == HomeMenuType.callService,
          //   child:  SizedBox(height: Constant.padding),
          // ),
          ///选择服务项目
          HomeSelectBtn(
            placeholder: "请选择服务项目",
            value: _selectedProjectList.isEmpty
                ? ""
                : _selectedProjectList
                    .map((project) => project.title)
                    .toList()
                    .join("/"),
            onPressed: _showServeView,
          ),
          if (_menuType == HomeMenuType.appointment)
            Padding(
              padding: const EdgeInsets.only(top: Constant.padding),
              child: HomeSelectBtn(
                placeholder: "请选择预约时间段",
                value: _dateTimeStr == null ? "" : _dateTimeStr??'',
                onPressed: _getAppointmentTime,
              ),
            ),
          SizedBox(height: 30),
          CommonActionButton(
            title: "下一步",
            onPressed: _nextStepAction,
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: DYColors.text_dark_gray.withOpacity(0.06),
            offset: Offset(0, -10),
            blurRadius: 20,
          )
        ],
      ),
    );
  }

  Widget _buildAddressBtn(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: CupertinoButton(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          children: [
            CommonDot(color: DYColors.yellowDot),
            SizedBox(width: Constant.padding),
            Expanded(
              child: Text(
                _address,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: DYColors.text_normal,
                ),
              ),
            ),
            DYLocalImage(
              imageName: "home_address_arrow",
              size: 24,
            ),
          ],
        ),
        onPressed: () async {
          if (_currentPoi == null) {
            ToastUtils.showError("获取位置信息失败");
            return;
          }
          Poi? poi = await NavigatorUtils.showPage(
            context,
            AddressPage(
              cityName: _currentPoi?.cityName,
              latLng: _currentPoi?.latLng,
              locationCity: widget.locationCity,
            ),
          );
          if (poi == null) return;
          _address = poi.title??'';
          _currentPoi = poi;
          setState(() {

          });
          widget.onAddressChanged?.call(poi);},
      ),
    );
  }

  void _showServeView() async {
    bool isLogin = SpUtil.getBool(Constant.loginState);
    if (!isLogin) {
      NavigatorUtils.push(context, Routes.login);
      return;
    }
    await _loadServiceList();
    BottomSheetUtil.show(
      context,
      child: ServiceSelectionWidget(
        projectList: _projectList,
        onConfirmed: (selectedProjectList) {
          _selectedProjectList = selectedProjectList;
          setState(() {});
        },
      ),
    );
  }

  void _showStoreView() async {
    bool isLogin = SpUtil.getBool(Constant.loginState);
    if (!isLogin) {
      NavigatorUtils.push(context, Routes.login);
      return;
    }
    await _loadStoreList();
    BottomSheetUtil.show(
      context,
      child: StoreSelectionWidget(
        storeList: _storeList,
        onConfirmed: (selectedStoreList) {
          _selectStoreList = selectedStoreList;
          setState(() {});
        },
      ),
    );
  }

  void _showTimeView(String startTime, String endTime, int earliestTime) {
    BottomSheetUtil.show(
      context,
      height: 360,
      child: AppointmentTimeWidget(
        startTime: startTime,
        endTime: endTime,
        earliestTime: earliestTime,
        confirmTimeCallback: (dateTimeStr, startDate) {
          _dateTimeStr = dateTimeStr;
          _startDate = startDate;
          setState(() {});
        },
      ),
    );
  }

  void _nextStepAction() {
    if (_currentPoi == null) {
      ToastUtils.showInfo("请选择位置或等待定位完成");
      return;
    }
    if (_selectedProjectList.isEmpty) {
      ToastUtils.showInfo("请选择服务项目");
      return;
    }
    if (_menuType == HomeMenuType.appointment && _dateTimeStr == null) {
      ToastUtils.showInfo("请选择预约时间段");
      return;
    }
    // if (_menuType == HomeMenuType.storeService && _selectStoreList.isEmpty) {
    //   ToastUtils.showInfo("请选择门店");
    //   return;
    // }
    bool isLogin = SpUtil.getBool(Constant.loginState);
    if (!isLogin) {
      NavigatorUtils.push(context, Routes.login);
      return;
    }

    _getStation();
  }

  void _showNextPage() {
    NavigatorUtils.showPage(
      context,
      ConfirmOrderPage(
        poi: _currentPoi,
        projectList: _selectedProjectList,
        isAppointment: _menuType == HomeMenuType.appointment,
        appointmentTime: _dateTimeStr,
        startDate: _startDate,
        staffCode: widget.staffCode,
      ),
    );
    widget.showNextPageEnd?.call();
  }

  void _getStation() {
    ToastUtils.showLoading();

    HttpUtils.get(
      "user/getStation.do",
      params: {
        "province": _currentPoi?.provinceName,
        "city": _currentPoi?.cityName,
        "area": _currentPoi?.adName,
      },
      onSuccess: (resultData) {
        bool result = resultData.data;
        if (result) {
          _loadCarCount();
        } else {
          ToastUtils.dismiss();
          DialogUtils.showAlertDialog(
            context,
            message: "当前地址暂未开通服务，敬请期待~",
            btnOkText: "知道啦",
            confirmAction: () {},
          );
        }
      },
    );
  }

  void _getAppointmentTime() {
    ToastUtils.showLoading("加载中...");
    HttpUtils.get(
      "home/getAppointmentTime.do",
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        var data = resultData.data;
        _showTimeView(
            data["startTime"], data["endTime"], data["appointmentTime"]);
      },
    );
  }

  void _loadCarCount() {
    HttpUtils.get(
      "home/userCarCount.do",
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        int count = resultData.data;
        if (count > 0) {
          _showNextPage();
        } else {
          DialogUtils.showAlertDialog(
            context,
            message: "系统检测到您还没有添加您的爱车，需要填加车辆才能进行下一步哦~",
            btnCancelText: "取消",
            cancelAction: () {},
            btnOkText: "去添加",
            confirmAction: () {
              NavigatorUtils.push(context, Routes.addCar);
            },
          );
        }
      },
    );
  }

  Future _loadServiceList() {
    ToastUtils.showLoading("加载中...");
    return HttpUtils.get(
      "home/projectList.do",
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        _projectList.clear();
        List dataJsonList = resultData.data as List;
        dataJsonList.forEach((element) {
          _projectList.add(ServiceProjectModel.fromJson(element));
        });
      },
    );
  }

  Future _loadStoreList()  {
    ToastUtils.showLoading('加载中');
    return Future.delayed(Duration(seconds: 1),(){
      ToastUtils.dismiss();
      _storeList.clear();
      for(int i = 0; i < 10; i++) {
        StoreShowEntity storeShowEntity = StoreShowEntity();
        storeShowEntity.id = i;
        storeShowEntity.name = i % 2 == 0 ? '鲸轿养车世贸店':'鲸轿养车滨江店';
        storeShowEntity.address = '西湖区曙光路122号2冬浙江君澜大饭店停车场B1(距离8.89KM)';
        storeShowEntity.phone = '18668222523';
        storeShowEntity.isChecked = false;
        _storeList.add(storeShowEntity);
      }
    });
  }
}
