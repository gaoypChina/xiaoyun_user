import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/car_model.dart';
import 'package:xiaoyun_user/models/confirm_order_model.dart';
import 'package:xiaoyun_user/models/contact_info_model.dart';
import 'package:xiaoyun_user/models/coupon_model.dart';
import 'package:xiaoyun_user/models/service_project_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/home/pay_page.dart';
import 'package:xiaoyun_user/pages/mine/contact_info_page.dart';
import 'package:xiaoyun_user/pages/mine/my_car_page.dart';
import 'package:xiaoyun_user/utils/bottom_sheet_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';

import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/title_input_field.dart';
import 'package:xiaoyun_user/widgets/home/appointment_time_widget.dart';
import 'package:xiaoyun_user/widgets/home/confirm_base_info_card.dart';
import 'package:xiaoyun_user/widgets/home/discount_coupon_widget.dart';
import 'package:xiaoyun_user/widgets/order/order_serve_cell.dart';
import 'package:xiaoyun_user/widgets/others/check_button.dart';

import 'package:auto_size_text/auto_size_text.dart';

class ConfirmOrderPage extends StatefulWidget {
  final Poi? poi;
  final List<ServiceProjectModel> projectList;
  final bool isAppointment;
  final String? appointmentTime;
  final DateTime? startDate;
  final String? staffCode;

  const ConfirmOrderPage({
    super.key,
    this.poi,
    required this.projectList,
    this.isAppointment = false,
    this.appointmentTime,
    this.startDate,
    this.staffCode,
  });
  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  bool _isStarServe = false;
  CarModel? _currentCar;
  ConfirmOrderModel? _orderGroupInfo;
  CouponModel? _selectedCoupon;
  late String _appointmentDate;
  late DateTime _startDate;
  int _expectTime = 1;
  List<CouponModel> _couponList = [];
  int _sexIndex = -1;
  bool _saveInfo = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _markController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appointmentDate = widget.appointmentTime??'';
    _startDate = widget.startDate??DateTime.now();
    _calculatePrice();
    _calculateCouponList();
    if (!widget.isAppointment) {
      _expectOrderTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "确认订单",
        gradient: LinearGradient(
          colors: [
            DYColors.primary.withOpacity(0.4),
            DYColors.primary.withOpacity(0.0)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      body: SafeArea(
        child: _orderGroupInfo == null
            ? Container()
            : Column(
                children: [
                  Expanded(
                    child: _buildListView(),
                  ),
                  _buildToolBar(context),
                ],
              ),
      ),
    );
  }

  Widget _buildToolBar(BuildContext context) {
    return CommonCard(
      margin: const EdgeInsets.all(Constant.padding),
      padding: const EdgeInsets.fromLTRB(20, 4, 4, 4),
      backgroundColor: DYColors.text_normal,
      child: Row(
        children: [
          Text.rich(
            TextSpan(text: "合计：￥", children: [
              TextSpan(
                text: _orderGroupInfo!.payFee,
                style: TextStyle(fontSize: 24),
              )
            ]),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          CommonActionButton(
            title: "提交订单",
            width: 120,
            height: 44,
            radius: 12,
            onPressed: _submitAction,
          )
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView(
      // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(Constant.padding),
      children: [
        _buildTipsWidget(),
        SizedBox(height: 12),
        _buildBaseInfoWidget(),
        SizedBox(height: 12),
        // OrderConfirmStarWidget(
        //   isStarServe: _isStarServe,
        //   price: _orderGroupInfo.allStarFee,
        //   onChanged: (value) {
        //     setState(() {
        //       _isStarServe = !_isStarServe;
        //       _selectedCoupon = null;
        //     });
        //     _calculatePrice();
        //     _calculateCouponList();
        //   },
        // ),
        // SizedBox(height: 12),
        _buildServiceWidget(),
        SizedBox(height: 12),
        _buildInputWidget(),
        SizedBox(height: 12),
        CommonCard(
          padding: const EdgeInsets.symmetric(
              horizontal: Constant.padding, vertical: 4),
          child: TitleInputField(
            title: "备注",
            placeholder: "备注内容（选填）",
            controller: _markController,
            hiddenDivider: true,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildTipsWidget() {
    return CommonCard(
      radius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      backgroundColor: Color(0xffF8EDCF),
      child: Row(
        children: [
          DYLocalImage(
            imageName: "order_confirm_tips",
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: AutoSizeText(
              "不同车型服务价格存在差异，请正确选择您的车型",
              style: TextStyle(color: Color(0xffF0AF00), fontSize: 13),
              maxLines: 1,
              minFontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputWidget() {
    return CommonCard(
      padding:
          const EdgeInsets.symmetric(horizontal: Constant.padding, vertical: 4),
      child: Column(
        children: [
          TitleInputField(
            title: "联系人",
            placeholder: "请填写姓名",
            hiddenDivider: true,
            controller: _nameController,
            textAlign: TextAlign.start,
            endSlot: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: DYColors.divider,
                  width: 0.5,
                ),
              ),
              child: CupertinoButton(
                minSize: 0,
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 12,
                      color: DYColors.text_gray,
                    ),
                    SizedBox(width: 3),
                    Text(
                      "常用",
                      style: TextStyle(
                        fontSize: 10,
                        color: DYColors.text_gray,
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  ContactInfo contactInfo = await NavigatorUtils.showPage(
                    context,
                    ContactInfoPage(isSelectMode: true),
                  );
                  setState(() {
                    _phoneController.text = contactInfo.contactPhone;
                    _nameController.text = contactInfo.contactName;
                    _locationController.text = contactInfo.address;
                    _sexIndex = contactInfo.sex;
                  });
                                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 80, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _genderBtn(isMale: true),
                SizedBox(width: 10),
                _genderBtn(isMale: false),
              ],
            ),
          ),
          Divider(height: 1),
          TitleInputField(
            title: "联系电话",
            placeholder: "请填写联系人电话",
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            textAlign: TextAlign.start,
          ),
          TitleInputField(
            title: "车辆位置",
            placeholder: "如：X层X区X号车位",
            controller: _locationController,
            textAlign: TextAlign.start,
          ),
          CheckButton(
            isChecked: _saveInfo,
            title: "保存至我的常用联系人",
            iconSize: 20,
            style: TextStyle(
              fontSize: 12,
              color: _saveInfo ? DYColors.text_normal : DYColors.text_gray,
            ),
            onPressed: () {
              setState(() {
                _saveInfo = !_saveInfo;
              });
            },
          )
        ],
      ),
    );
  }

  Widget _genderBtn({bool isMale = true}) {
    bool isSelected = isMale ? _sexIndex == 0 : _sexIndex == 1;
    return CommonActionButton(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      width: 50,
      height: 24,
      radius: 4,
      bgColor: isSelected ? DYColors.primary : DYColors.normal_bg,
      titleColor: isSelected ? Colors.white : DYColors.text_gray,
      title: isMale ? "先生" : "女士",
      onPressed: () {
        setState(() {
          _sexIndex = isMale ? 0 : 1;
        });
      },
    );
  }

  Widget _buildServiceWidget() {
    List<Widget> children =
        List.generate(_orderGroupInfo!.projects.length, (index) {
      ServiceProjectModel projectModel = _orderGroupInfo!.projects[index];
      return OrderServeCell(
        photoImgUrl: projectModel.photoImgUrl,
        title: projectModel.title,
        originPrice: "${projectModel.originalPriceMoney}" ?? "",
        price: projectModel.priceMoney ?? "",
      );
    });
    children.add(Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Divider(height: 1),
    ));
    children.add(
      CommonCellWidget(
        title: "优惠券",
        subtitle: _selectedCoupon != null
            ? "-￥${_orderGroupInfo!.couponPrice}"
            : (_couponList.isEmpty ? "暂无可用" : "${_couponList.length}张可用"),
        titleStyle: TextStyle(fontSize: 12),
        subtitleStyle: TextStyle(
          fontSize: 12,
          fontWeight:
              _selectedCoupon != null ? FontWeight.w500 : FontWeight.normal,
          color:
              _selectedCoupon != null ? DYColors.text_red : DYColors.text_gray,
        ),
        onClicked: () {
          if (_couponList.isEmpty) {
            ToastUtils.showInfo("暂无可用优惠券");
            return;
          }
          BottomSheetUtil.show(
            context,
            child: DiscountCouponWidget(
              couponList: _couponList,
              onConfirmed: (couponModel) {
                _selectedCoupon = couponModel;
                setState(() {});
                _calculatePrice();
              },
            ),
          );
        },
      ),
    );

    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Constant.padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(_orderGroupInfo!.discountPrice > 0)
            Text(
              "已优惠",
              style: TextStyle(color: DYColors.text_gray),
            ),
            if(_orderGroupInfo!.discountPrice > 0)
            Text(
              "￥${_orderGroupInfo!.discountPrice}",
              style: TextStyle(
                color: DYColors.text_red,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text("  小计："),
            Text(
              "￥",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              _orderGroupInfo!.payFee??'0.0',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );

    return CommonCard(
      padding:
          const EdgeInsets.symmetric(horizontal: Constant.padding, vertical: 4),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildBaseInfoWidget() {
    return ConfirmBaseInfoCard(
      currentCar: _currentCar!,
      poi: widget.poi,
      isAppointment: widget.isAppointment,
      appointmentDate: _appointmentDate,
      expectTime: _expectTime,
      showTimeView: _getAppointmentTime,
      onCarClicked: () async {
        CarModel carModel = await NavigatorUtils.showPage(
          context,
          MyCarPage(isSelectModel: true),
        );
        setState(() {
          _currentCar = carModel;
          _selectedCoupon = null;
        });
        _calculatePrice();
        _calculateCouponList();
            },
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
          _appointmentDate = dateTimeStr;
          setState(() {});
          _startDate = startDate;
        },
      ),
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

  void _expectOrderTime() {
    HttpUtils.get(
      "order/expectOrderTime.do",
      params: {
        "gps": "${widget.poi?.latLng?.latitude},${widget.poi?.latLng?.longitude}",
      },
      onSuccess: (resultData) {
        _expectTime = resultData.data;
        setState(() {});
      },
    );
  }

  void _calculatePrice() {
    String ids = widget.projectList.map((e) => e.id).toList().join(",");

    Map<String, dynamic> params = {
      "projectIds": ids,
      "starfeeStatus": _isStarServe ? "1" : "0"
    };
    params["carId"] = _currentCar?.id;
    params["accountCouponId"] = _selectedCoupon?.id;
    ToastUtils.showLoading("加载中...");
    HttpUtils.get(
      "order/getProjectListPriceByCar.do",
      params: params,
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        _orderGroupInfo = ConfirmOrderModel.fromJson(resultData.data);

        setState(() {
          _currentCar = _orderGroupInfo!.car;
          _nameController.text = _orderGroupInfo!.contact??'';
          _phoneController.text = _orderGroupInfo!.phone??'';
          _locationController.text = _orderGroupInfo!.address??'';
          _sexIndex = _orderGroupInfo!.sex;
        });
      },
      onError: (msg) {
        // Future.delayed(Duration(seconds: 1))
        //     .then((value) => NavigatorUtils.goBack(context));
      },
    );
  }

  void _calculateCouponList() {
    String ids = widget.projectList.map((e) => e.id).toList().join(",");

    Map<String, dynamic> params = {
      "projectIds": ids,
      "starfeeStatus": _isStarServe ? "1" : "0"
    };
    params["carId"] = _currentCar?.id;
      HttpUtils.get(
      "order/getProjectListPriceByCar.do",
      params: params,
      onSuccess: (resultData) {
        ConfirmOrderModel orderGroupInfo =
            ConfirmOrderModel.fromJson(resultData.data);
        _couponList = orderGroupInfo.couponList;
        if (_couponList.isEmpty) {
          _selectedCoupon = null;
        }
        setState(() {});
      },
      onError: (msg) {
        // Future.delayed(Duration(seconds: 1))
        //     .then((value) => NavigatorUtils.goBack(context));
      },
    );
  }

  void _submitAction() {
    if (_nameController.text.isEmpty) {
      ToastUtils.showInfo("请输入联系人姓名");
      return;
    }
    if (_sexIndex == -1) {
      ToastUtils.showInfo("请选选择性别");
      return;
    }
    if (_phoneController.text.length != 11) {
      ToastUtils.showInfo("请输入11位有效的手机号");
      return;
    }
    if (_locationController.text.isEmpty) {
      ToastUtils.showInfo("请输入车辆位置");
      return;
    }

    if (_saveInfo) {
      _saveAddress();
    } else {
      _submitToNet();
    }
  }

  void _saveAddress() {
    Map<String, dynamic> params = {
      "contactName": _nameController.text,
      "contactPhone": _phoneController.text,
      "address": _locationController.text,
      "sex": _sexIndex,
    };
    ToastUtils.showLoading("保存中...");
    HttpUtils.post(
      "address/addOrUpdate.do",
      params: params,
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        _submitToNet();
      },
    );
  }

  void _submitToNet() {
    String ids = widget.projectList.map((e) => e.id).toList().join(",");

    Map<String, dynamic> params = {
      "accountCarId": _currentCar?.id,
      "address": '${widget.poi?.provinceName}' + '${widget.poi?.cityName}' + '${widget.poi?.adName}' + '${widget.poi?.title}',
      "contact": _nameController.text,
      "gps": "${widget.poi?.latLng?.latitude},${widget.poi?.latLng?.longitude}",
      "isReserve": widget.isAppointment ? 1 : 0,
      "phone": _phoneController.text,
      "projectFee": _orderGroupInfo!.projectFee,
      "projectIds": ids,
      "carLocation": _locationController.text,
      "starfeeStatus": _isStarServe ? 1 : 0,
      "sex": _sexIndex,
    };
    if (widget.isAppointment) {
      List<String> format = [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss];
      String start = formatDate(_startDate, format);
      DateTime endTime = _startDate.add(Duration(minutes: 30));
      String end = formatDate(endTime, format);
      params["reserveStartTime"] = start;
      params["reserveEndTime"] = end;
    }
    if (_markController.text.isNotEmpty) {
      params["comment"] = _markController.text;
    }
    params["accountCouponId"] = _selectedCoupon?.id;
    if (widget.staffCode != null) {
      params["staffId"] = widget.staffCode;
    }

    ToastUtils.showLoading("提交中...");
    HttpUtils.post(
      "order/create.do",
      params: params,
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        var data = resultData.data;
        NavigatorUtils.showPage(
          context,
          PayPage(
            orderNo: data["orderNum"],
            money: data["orderPrice"],
            orderId: data["id"],
          ),
        );
      },
    );
  }
}
