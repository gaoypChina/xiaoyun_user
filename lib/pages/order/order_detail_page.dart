import 'dart:async';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/order_status_event_bus.dart';
import 'package:xiaoyun_user/models/order_detail_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/order/order_base_info_card.dart';
import 'package:xiaoyun_user/widgets/order/order_car_info_card.dart';
import 'package:xiaoyun_user/widgets/order/order_detail_tool_bar.dart';
import 'package:xiaoyun_user/widgets/order/order_serve_price_card.dart';
import 'package:xiaoyun_user/widgets/order/order_staff_info_card.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  const OrderDetailPage({
    super.key,
    required this.orderId,
  });
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailModel? _detailModel;
  AmapController? _controller;
  late StreamSubscription _subscription;
  Marker? _staffMarker;
  String? _virtualPhone;

  @override
  void initState() {
    super.initState();
    _loadOrderDetail();
    _getVirtualPhone();
    _subscription = OrderStatusEventBus().on<OrderStateChangedEvent>().listen((event) {
      _loadOrderDetail();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    if (_controller != null) {
      _controller!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showMap = _detailModel == null
        ? false
        : (_detailModel!.orderSta == 2 || _detailModel!.orderSta == 3) && !_detailModel!.isCancel;
    double otherFee = _detailModel == null
        ? 0.0
        : double.tryParse(_detailModel!.otherFeePay) ?? 0.0;
    bool isOtherFee = _detailModel == null
        ? false
        : _detailModel!.isOtherFeePay == 3 &&
            otherFee > 0 &&
            !_detailModel!.isCancel;
    bool showToolBar = _detailModel == null
        ? false
        : ((_detailModel!.orderSta < 3 ||
                    (_detailModel!.orderSta == 3 &&
                        _detailModel!.isOtherFeePay == 3)) &&
                _detailModel!.cancelable &&
                !_detailModel!.isCancel) ||
            (_detailModel!.orderSta == 4 &&
                (_detailModel!.afterSalesable ||
                    (!_detailModel!.isEvaluate && _detailModel!.isEvaluable))) ||
            _detailModel!.orderSta == 5 ||
            isOtherFee ||
            _detailModel!.isEvaluate;
    return Scaffold(
      body: _detailModel == null
          ? Container()
          : Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      showMap ? _buildMapSliverAppBar() : _buildSliverAppBar(),
                      _buildSliverList(),
                    ],
                  ),
                ),
                if (showToolBar) OrderDetailToolBar(detailModel: _detailModel!),
              ],
            ),
    );
  }

  Widget _buildSliverList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(Constant.padding, 0, Constant.padding, 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          <Widget>[
            OrderServePriceCard(detailModel: _detailModel!),
            SizedBox(height: 12),
            if (_detailModel!.orderSta > 1 && _detailModel!.staff != null)
              OrderStaffInfoCard(
                orderId: _detailModel!.id,
                staffModel: _detailModel!.staff!,
                virtualPhone: _virtualPhone,
                isRefundStatus: _detailModel!.isRefundStatus,
                isCanceled: _detailModel!.isCancel,
                isFinished: _detailModel!.orderSta == 4 || _detailModel!.orderSta == 5,
                beforePhotoList: _detailModel!.beforePhotoList,
                afterPhotoList: _detailModel!.afterPhotoList,
              ),
            if (_detailModel!.orderSta > 1) SizedBox(height: 12),
            OrderCarInfoCard(
              detailModel: _detailModel!,
            ),
            SizedBox(height: 12),
            OrderBaseInfoCard(
              detailModel: _detailModel!,
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      leading: NavigationItem(
        iconName: "navigation_back_white",
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
      expandedHeight: 128,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.blurBackground],
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xff4ACBFF), DYColors.primary],
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: _detailModel!.orderSta == 4
                    ? Padding(
                        padding: const EdgeInsets.only(right: 50, bottom: 25),
                        child: DYLocalImage(
                          imageName: "order_header_done",
                          width: 88,
                          height: 92,
                        ),
                      )
                    : DYLocalImage(
                        imageName: "order_header_car",
                        width: 172,
                        height: 115,
                      ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Constant.padding, bottom: 20),
                    child: Text(
                      _detailModel!.status,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 26,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: DYColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildMapSliverAppBar() {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: DYColors.app_bar,
      elevation: 0,
      leading: NavigationItem(
        iconName: "navigation_back",
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            _loadOrderDetail();
            if (_detailModel != null) {
              _getStaffLocation();
            }
          },
        ),
      ],
      expandedHeight: MediaQuery.of(context).size.width - ScreenUtil().statusBarHeight,
      pinned: true,
      flexibleSpace: _buildFlexibleSpaceBar(),
    );
  }

  FlexibleSpaceBar _buildFlexibleSpaceBar() {
    List? latLngList = _detailModel!.gps.split(",").toList();
    LatLng? latLng;
    if (latLngList != null && latLngList.isNotEmpty) {
      latLng = LatLng(
        double.tryParse(latLngList[0])??0.0,
        double.tryParse(latLngList[1])??0.0,
      );
    }
    return FlexibleSpaceBar(
      background: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AmapView(
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
                await _controller!.setZoomLevel(15);
                await _controller!.showMyLocation(
                  MyLocationOption(
                    show: true,
                    myLocationType: MyLocationType.Locate,
                  ),
                );
                _controller!.addMarker(
                  MarkerOption(
                    coordinate: latLng!,
                    infoWindowEnabled: false,
                    iconProvider:
                        AssetImage('assets/images/home/home_center_marker.png'),
                  ),
                );
                _getStaffLocation();
              },
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: DYColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
              ),
              padding: const EdgeInsets.only(left: Constant.padding, top: 20),
              child: Row(
                children: [
                  Text(
                    _detailModel!.status,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_detailModel!.orderSta == 2 && _detailModel!.waitNumber > 0)
                    Text("（当前有${_detailModel!.waitNumber}人排队)")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _loadOrderDetail() {
    ToastUtils.showLoading("加载中...");
    HttpUtils.get(
      "order/getDetail.do",
      params: {"orderId": widget.orderId},
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        _detailModel = OrderDetailModel.fromJson(resultData.data);
        setState(() {});
      },
      onError: (msg) {
        NavigatorUtils.goBack(context);
      },
    );
  }

  void _getVirtualPhone() {
    HttpUtils.get(
      "order/getPhoneByOrderId.do",
      params: {"orderId": widget.orderId},
      onSuccess: (resultData) {
        setState(() {
          _virtualPhone = resultData.data["phone"];
        });
      },
    );
  }

  void _getStaffLocation() {
    HttpUtils.post(
      "order/staffgps.do",
      params: {"staffId": _detailModel!.staff?.id},
      onSuccess: (resultData) async {
        double lat = resultData.data["lat"];
        double lng = resultData.data["lng"];
        LatLng coordinate = LatLng(lat, lng);
        _controller?.setCenterCoordinate(coordinate);

        List gpsList = _detailModel!.gps.split(",").toList();
        LatLng destination = LatLng(
          double.tryParse(gpsList.first)??0.0,
          double.tryParse(gpsList.last)??0.0,
        );
        double distance = await AmapService.instance
            .calculateDistance(coordinate, destination);

        if (_staffMarker != null) {
          _staffMarker!.setCoordinate(coordinate);
          _staffMarker!.remove();
        }

        if (_controller != null) {
          _staffMarker = await _controller!.addMarker(
            MarkerOption(
              coordinate: coordinate,
              widget: _buildStaffMarker(distance),
              infoWindowEnabled: false,
              anchorV: 0.5,
            ),
          ) as Marker;
        }
      },
    );
  }

  Widget _buildStaffMarker(double distance) {
    double kmValue = distance / 1000;
    String distanceString = distance > 1000
        ? "${kmValue.toStringAsFixed(2)}km"
        : "${distance.toStringAsFixed(0)}m";
    double time = kmValue / 15 * 60;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: _detailModel!.orderSta == 3
              ? Text(
                  "正在为您服务中",
                  style: TextStyle(
                    fontSize: 12,
                    color: DYColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "距您",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          distanceString,
                          style: TextStyle(
                            fontSize: 12,
                            color: DYColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "预计",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "${time.ceil()}分钟到达",
                          style: TextStyle(
                            fontSize: 12,
                            color: DYColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: 56,
          height: 56,
          child: DYLocalImage(imageName: "order_staff_location"),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Color(0xff25292C).withOpacity(0.3),
                blurRadius: 10,
              )
            ],
          ),
        ),
      ],
    );
  }
}
