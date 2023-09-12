import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/upload_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/photo_picker_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_text_view.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/others/multi_photo_widget.dart';

class ReportPage extends StatefulWidget {
  final String userId;
  const ReportPage({Key key, @required this.userId}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController _descController = TextEditingController();

  List<Asset> _photoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(title: "投诉"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildListView(),
            ),
            CommonActionButton(
              margin: const EdgeInsets.all(Constant.padding),
              title: "提交",
              onPressed: _submitAction,
            ),
          ],
        ),
      ),
    );
  }

  ListView _buildListView() {
    return ListView(
      padding: const EdgeInsets.all(Constant.padding),
      children: [
        CommonCard(
          padding: const EdgeInsets.all(Constant.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "投诉原因",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Constant.padding),
                child: Divider(height: 1),
              ),
              CommonTextView(
                placeholder: "请描述投诉该洗车工的原因",
                controller: _descController,
                maxLines: 6,
              )
            ],
          ),
        ),
        CommonCard(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(Constant.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "上传凭证",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: Constant.padding, bottom: 10),
                child: Divider(height: 1),
              ),
              MultiPhotoWidget(
                photoList: _photoList,
                maxPhoto: 3,
                choosePhotoAction: _choosePhotos,
                deleteAction: (index) {
                  _photoList.removeAt(index);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _choosePhotos() async {
    FocusScope.of(context).requestFocus(FocusNode());
    List<Asset> photoList = await PhotoPickerUtils.pickMultiPhotos(
      maxImages: 3,
      selectedAssets: _photoList,
    );
    if (photoList != null) {
      _photoList = photoList;
      setState(() {});
    }
  }

  void _submitAction() async {
    if (_descController.text.isEmpty) {
      ToastUtils.showInfo("请描述投诉该洗车工的原因");
      return;
    }
    if (_photoList.isEmpty) {
      ToastUtils.showInfo("请上传凭证");
      return;
    }
    Map<String, dynamic> params = {
      "content": _descController.text,
      "userId": widget.userId
    };
    if (_photoList.isNotEmpty) {
      ToastUtils.showLoading("上传中...");
      await UploadUtils.uploadMutiPhoto(_photoList, (photoModelList) {
        ToastUtils.dismiss();
        params["imgs"] = photoModelList.map((e) => e.id).toList().join(",");
      }, (msg) {
        return;
      });
    }

    ToastUtils.showLoading("提交中...");

    HttpUtils.post(
      "user/complaint.do",
      params: params,
      onSuccess: (resultData) {
        ToastUtils.showSuccess("提交成功，感谢您的反馈！\n我们会尽快核实并处理");
        Future.delayed(Duration(seconds: 1)).then(
          (value) => NavigatorUtils.goBack(context),
        );
      },
    );
  }
}
