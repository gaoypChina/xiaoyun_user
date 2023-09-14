import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/order_status_event_bus.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/upload_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/photo_picker_utils.dart';
import 'package:xiaoyun_user/utils/picker_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/common_text_view.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/others/multi_photo_widget.dart';

class ApplyAfterSalePage extends StatefulWidget {
  final int orderId;

  const ApplyAfterSalePage({super.key, required this.orderId});

  @override
  _ApplyAfterSalePageState createState() => _ApplyAfterSalePageState();
}

class _ApplyAfterSalePageState extends State<ApplyAfterSalePage> {
  TextEditingController _controller = TextEditingController();
  List<String> _reasonList = [];
  List<Asset> _photoList = [];

  String _reason = "";

  @override
  void initState() {
    super.initState();
    _getReasonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "申请售后",
      ),
      body: ListView(
        padding: const EdgeInsets.all(Constant.padding),
        children: [
          CommonCard(
            padding: Constant.horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonCellWidget(
                  title: "售后原因",
                  subtitle: _reason.isEmpty ? "请选择" : _reason,
                  subtitleStyle: TextStyle(
                      color: _reason.isEmpty
                          ? DYColors.text_gray
                          : DYColors.text_normal),
                  onClicked: _pickReason,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: Constant.padding, bottom: 12),
                  child: Text("问题描述"),
                ),
                CommonTextView(
                  placeholder: "补充详细信息以便平台能更快的为您处理",
                  controller: _controller,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Constant.padding),
                  child: Text("上传图片"),
                ),
                MultiPhotoWidget(
                  photoList: _photoList,
                  choosePhotoAction: _choosePhotos,
                  deleteAction: (index) {
                    _photoList.removeAt(index);
                    setState(() {});
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(height: 30),
          CommonActionButton(
            title: "提交",
            onPressed: _submitAction,
          ),
        ],
      ),
    );
  }

  void _choosePhotos() async {
    FocusScope.of(context).requestFocus(FocusNode());
    List<Asset> photoList = await PhotoPickerUtils.pickMultiPhotos(
      maxImages: 6,
      selectedAssets: _photoList,
    );
    if (photoList != null) {
      _photoList = photoList;
      setState(() {});
    }
  }

  void _pickReason() {
    PickerUtils.showPicker(
      context,
      _reasonList,
      confirmCallback: (selectedIndex) {
        setState(() {
          _reason = _reasonList[selectedIndex];
        });
      },
    );
  }

  void _getReasonList() {
    HttpUtils.post(
      "order/queryCopy.do",
      params: {"copyType": "refund"},
      onSuccess: (resultData) {
        _reasonList = resultData.data.map<String>((e) => e.toString()).toList();
        setState(() {});
      },
    );
  }

  void _submitAction() async {
    if (_reason.isEmpty) {
      ToastUtils.showInfo("请选择售后原因");
      return;
    }
    Map<String, dynamic> params = {
      "reason": _reason,
      "orderId": widget.orderId,
      "comment": _controller.text,
    };

    if (_photoList.isNotEmpty) {
      ToastUtils.showLoading("上传中...");
      await UploadUtils.uploadMutiPhoto(_photoList, (photoModelList) {
        ToastUtils.dismiss();
        params["photo"] = photoModelList.map((e) => e.id).toList().join(",");
      }, (msg) {
        return;
      });
    }

    ToastUtils.showLoading("提交中...");
    HttpUtils.post(
      "order/applyPetition.do",
      params: params,
      onSuccess: (resultData) {
        ToastUtils.showSuccess("提交成功");
        Future.delayed(Duration(seconds: 1)).then((value) {
          OrderStatusEventBus().fire(OrderStateChangedEvent());
          NavigatorUtils.goBack(context);
        });
      },
    );
  }
}
