import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/car_brand_model.dart';
import 'package:xiaoyun_user/models/car_model.dart';
import 'package:xiaoyun_user/models/car_property_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/upload_utils.dart';
import 'package:xiaoyun_user/pages/mine/car_brand_list_page.dart';
import 'package:xiaoyun_user/utils/bottom_sheet_utils.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/photo_picker_utils.dart';
import 'package:xiaoyun_user/utils/picker_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_network_image.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/mine/car_province_widget.dart';
import 'package:xiaoyun_user/widgets/others/bottom_button_bar.dart';
import 'package:xiaoyun_user/widgets/others/check_button.dart';
import 'package:xiaoyun_user/widgets/others/common_dot.dart';

enum CarType { normal, newEnergy }

class CarAddPage extends StatefulWidget {
  final bool isEdit;
  final CarModel? carModel;

  const CarAddPage({super.key, this.isEdit = false, this.carModel});

  @override
  _CarAddPageState createState() => _CarAddPageState();
}

class _CarAddPageState extends State<CarAddPage> {
  TextEditingController _numberController = TextEditingController();
  TextEditingController _otherNoController = TextEditingController();

  List<CarPropertyModel> _colorList = [];
  CarPropertyModel? _selectedColor;
  List<CarPropertyModel> _typeList = [];
  CarPropertyModel? _selectedType;
  CarBrandModel? _selectedBrand;

  String _province = "浙";
  bool _isDefault = true;
  bool _isJersey = false;
  bool _isMainlandCar = true;

  File? _carPhoto;
  String? _carPhotoUrl;
  int _photoId = 0;
  bool _isNewEnergy = false;
  int _codeType = 1;

  @override
  void initState() {
    super.initState();
    _loadCarColorList();
    _loadCarTypeList();

    if (widget.isEdit) {
      _configureDatas();
    }
  }

  void _configureDatas() {
    _codeType = widget.carModel!.codeType;

    _selectedBrand = CarBrandModel(
        brandId: widget.carModel!.carBrandId??0,
        title: widget.carModel!.carBrandTitle);
    _selectedColor = CarPropertyModel(id: widget.carModel!.carColourId??0, title: widget.carModel!.carColourTitle);
    _selectedType = CarPropertyModel(id: widget.carModel!.carTypeId, title: widget.carModel!.carTypeTitle);
    _carPhotoUrl = widget.carModel!.photoImgUrl;
    _photoId = widget.carModel!.photo??0;
    _isDefault = widget.carModel!.isDefault;
    _isJersey = widget.carModel!.isJersey;
    _isMainlandCar = _codeType != 3;
    if (_isMainlandCar) {
      _province = widget.carModel!.code.substring(0, 1);
      _numberController.text = widget.carModel!.code.substring(1);
      _isNewEnergy = _numberController.text.length >= 7;
    } else {
      _otherNoController.text = widget.carModel!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: widget.isEdit ? "编辑车辆" : "添加车辆",
        actions: [
          if (widget.isEdit)
            NavigationItem(
              title: "删除",
              onPressed: () {
                DialogUtils.showActionSheetDialog(
                  context,
                  message: "确定要删除该车辆吗？",
                  dialogItems: [
                    ActionSheetDialogItem(
                      title: "删除",
                      isDestructiveAction: true,
                      onPressed: () {
                        _deleteCurrentCar();
                      },
                    ),
                  ],
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildListView(),
          ),
          BottomButtonBar(
            title: "保存",
            onPressed: _saveBtnClicked,
          )
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView(
      padding: const EdgeInsets.all(Constant.padding),
      children: [
        _buildCarPlateWidget(),
        SizedBox(height: 12),
        _buildCarInfoSelectWidget(),
        SizedBox(height: 12),
        _buildSetDefaultWidget(),
        SizedBox(height: 10),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 4, 0),
              child: Text(
                "*",
                style: TextStyle(
                  fontSize: 14,
                  color: DYColors.text_red,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "不同车型的价格存在差异，请务必正确选择您的车辆类型",
                style: TextStyle(fontSize: 12, color: DYColors.text_gray),
              ),
            ),
          ],
        )
      ],
    );
  }

  CommonCard _buildSetDefaultWidget() {
    return CommonCard(
      padding: Constant.horizontalPadding,
      child: CommonCellWidget(
        padding: const EdgeInsets.symmetric(vertical: 10),
        title: "设为默认",
        hiddenDivider: true,
        showArrow: false,
        endSolt: CupertinoSwitch(
          activeColor: DYColors.primary,
          value: _isDefault,
          onChanged: (value) {
            setState(() {
              _isDefault = !_isDefault;
            });
          },
        ),
      ),
    );
  }

  Widget _buildCarInfoSelectWidget() {
    return CommonCard(
      padding: Constant.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonCellWidget(
            title: "车辆品牌",
            subtitle: _selectedBrand == null ? "请选择" : _selectedBrand?.title??'',
            subtitleStyle: TextStyle(
              color: _selectedBrand == null
                  ? DYColors.text_gray
                  : DYColors.text_normal,
            ),
            onClicked: () async {
              CarBrandModel selectedBrand = await NavigatorUtils.showPage(context, CarBrandListPage());
              if (selectedBrand != null) {
                setState(() {
                  _selectedBrand = selectedBrand;
                });
              }
            },
          ),
          CommonCellWidget(
            title: "车辆颜色",
            subtitle: _selectedColor == null ? "请选择" : _selectedColor?.title??'',
            subtitleStyle: TextStyle(
              color: _selectedColor == null
                  ? DYColors.text_gray
                  : DYColors.text_normal,
            ),
            onClicked: () {
              PickerUtils.showPicker(
                context,
                _colorList.map((e) => e.title).toList(),
                confirmCallback: (selectedIndex) {
                  _selectedColor = _colorList[selectedIndex];
                  setState(() {});
                },
              );
            },
          ),
          CommonCellWidget(
            title: "车辆类型",
            subtitle: _selectedType == null ? "请选择" : _selectedType?.title??'',
            subtitleStyle: TextStyle(
              color: _selectedType == null
                  ? DYColors.text_gray
                  : DYColors.text_normal,
            ),
            onClicked: () {
              PickerUtils.showPicker(
                context,
                _typeList.map((e) => e.title).toList(),
                confirmCallback: (selectedIndex) {
                  _selectedType = _typeList[selectedIndex];
                  setState(() {});
                },
              );
            },
          ),
          CommonCellWidget(
            padding: const EdgeInsets.symmetric(vertical: 10),
            title: "是否有车衣",
            showArrow: false,
            endSolt: CupertinoSwitch(
              activeColor: DYColors.primary,
              value: _isJersey,
              onChanged: (value) {
                setState(() {
                  _isJersey = !_isJersey;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Constant.padding),
            child: Row(
              children: [
                Text("车辆图片"),
                Text(
                  "(非必填)",
                  style: TextStyle(color: DYColors.text_gray),
                ),
                Spacer(),
                if (_carPhoto != null || _carPhotoUrl != null)
                  InkWell(
                    child: Text("删除"),
                    onTap: () {
                      setState(() {
                        _carPhoto = null;
                        _carPhotoUrl = null;
                        _photoId = 0;
                      });
                    },
                  ),
              ],
            ),
          ),
          GestureDetector(
            child: _buildPhotoWidget(),
            onTap: () async {
              File? photoFile = await PhotoPickerUtils.pickPhoto(context, maxWidth: 1280);
              if (photoFile != null) {
                setState(() {
                  _carPhoto = photoFile;
                });
                _uploadCarPhoto();
              }
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPhotoWidget() {
    if (_carPhoto != null) {
      return Image.file(_carPhoto!);
    }
    if (_carPhotoUrl != null && _carPhotoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: DYNetworkImage(imageUrl: _carPhotoUrl!),
      );
    }
    return DYLocalImage(
        imageName: "mine_car_photo_add", width: 100, height: 60);
  }

  Widget _buildCarPlateWidget() {
    return CommonCard(
      padding: Constant.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "车牌号码",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Row(
            children: [
              CheckButton(
                isChecked: _isMainlandCar,
                title: "内地车牌",
                onPressed: () {
                  if (_isMainlandCar) return;
                  setState(() {
                    _isMainlandCar = true;
                  });
                },
              ),
              SizedBox(width: 8),
              CheckButton(
                isChecked: !_isMainlandCar,
                title: "港澳车牌",
                onPressed: () {
                  if (!_isMainlandCar) return;
                  setState(() {
                    _isMainlandCar = false;
                  });
                },
              ),
            ],
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.only(top: Constant.padding),
            child: IndexedStack(
              index: _isMainlandCar ? 0 : 1,
              children: [
                _buildMainlandLicensePlate(),
                _buildOtherLicensePlater(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherLicensePlater() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: Constant.padding),
      height: 40,
      child: DYTextField(
        controller: _otherNoController,
        inputFormatter: [UpperCaseTextFormatter()],
        placeholder: "请输入车牌号",
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: DYColors.divider,
        ),
      ),
    );
  }

  Widget _buildMainlandLicensePlate() {
    double itemWH = 60.w;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoButton(
          minSize: itemWH,
          padding: const EdgeInsets.all(0),
          color: DYColors.background,
          child: Text(
            _province,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: DYColors.text_normal,
            ),
          ),
          onPressed: () {
            double itemHeight = (MediaQuery.of(context).size.width -
                    Constant.padding * 2 -
                    80) /
                9 /
                0.8;
            BottomSheetUtil.show(
              context,
              height: itemHeight * 4 + 40,
              child: CarProvinceWidget(
                onClicked: (value) {
                  _province = value;
                  setState(() {});
                },
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
          child: CommonDot(color: DYColors.primary, size: 4),
        ),
        Expanded(
          child: Stack(
            children: [
              Offstage(
                offstage: _isNewEnergy,
                child: Container(
                  width: itemWH,
                  height: itemWH,
                  margin: EdgeInsets.only(left: itemWH * 6 + 5 * 6),
                  alignment: Alignment.center,
                  child: Text(
                    "新",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[200],
                    ),
                  ),
                ),
              ),
              PinCodeTextField(
                appContext: context,
                controller: _numberController,
                length: 7,
                animationType: AnimationType.fade,
                mainAxisAlignment: MainAxisAlignment.start,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: itemWH,
                  fieldWidth: itemWH,
                  activeColor: _isNewEnergy ? Colors.green : Colors.blue,
                  inactiveColor: DYColors.background,
                  fieldOuterPadding: const EdgeInsets.only(right: 5),
                ),
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: false,
                onCompleted: (value) {},
                beforeTextPaste: (text) {
                  //禁止粘贴
                  return false;
                },
                onChanged: (value) {
                  setState(() {
                    _isNewEnergy = value.length == 7;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _uploadCarPhoto() async {
    ToastUtils.showLoading("上传中...");
    PhotoModel? photoModel = await UploadUtils.uploadPhoto(_carPhoto!);
    ToastUtils.dismiss();
    if (photoModel != null) {
      _photoId = photoModel.id;
    }
  }

  void _loadCarTypeList() {
    ToastUtils.showLoading();
    HttpUtils.get(
      "car/typeList.do",
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        List dataJsonList = resultData.data as List;
        dataJsonList.forEach((element) {
          _typeList.add(CarPropertyModel.fromJson(element));
        });
      },
    );
  }

  void _loadCarColorList() {
    HttpUtils.get(
      "car/colourList.do",
      onSuccess: (resultData) {
        List dataJsonList = resultData.data as List;
        dataJsonList.forEach((element) {
          _colorList.add(CarPropertyModel.fromJson(element));
        });
      },
    );
  }

  void _deleteCurrentCar() {
    ToastUtils.showLoading("删除中...");
    HttpUtils.get(
      "car/delete.do",
      params: {"id": widget.carModel?.id},
      onSuccess: (resultData) {
        ToastUtils.showSuccess("删除成功");
        Future.delayed(Duration(seconds: 1), () {
          NavigatorUtils.goBackWithParams(context, true);
        });
      },
    );
  }

  void _saveBtnClicked() {
    if (_numberController.text.isEmpty && _isMainlandCar ||
        _otherNoController.text.isEmpty && !_isMainlandCar) {
      ToastUtils.showInfo("请输入车牌号");
      return;
    }
    if (_numberController.text.length != 6 &&
        _numberController.text.length != 7 &&
        _isMainlandCar) {
      ToastUtils.showInfo("请输入正确的车牌号");
      return;
    }
    if (_selectedBrand == null) {
      ToastUtils.showInfo("请选择车辆品牌");
      return;
    }
    if (_selectedColor == null) {
      ToastUtils.showInfo("请选择车辆颜色");
      return;
    }
    if (_selectedType == null) {
      ToastUtils.showInfo("请选择车辆类型");
      return;
    }
    ToastUtils.showLoading("保存中...");

    if (_isMainlandCar) {
      _codeType = _numberController.text.length == 6 ? 1 : 2;
    } else {
      _codeType = 3;
    }
    String carNo = _isMainlandCar
        ? _province + _numberController.text
        : _otherNoController.text;

    Map<String, dynamic> params = {
      "codeType": _codeType,
      "carBrandId": _selectedBrand?.brandId,
      "carColourId": _selectedColor?.id,
      "carTypeId": _selectedType?.id,
      "code": carNo,
      "isDefault": _isDefault ? 1 : 0,
      "isJersey": _isJersey ? 1 : 0,
    };
    if (widget.isEdit) {
      params["id"] = widget.carModel!.id;
    }
    params["photo"] = _photoId;
      HttpUtils.post(
      "car/addOrUpdate.do",
      params: params,
      onSuccess: (resultData) {
        ToastUtils.showSuccess("保存成功");
        Future.delayed(Duration(seconds: 1), () {
          NavigatorUtils.goBackWithParams(context, true);
        });
      },
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
