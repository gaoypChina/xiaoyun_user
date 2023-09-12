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
import 'package:xiaoyun_user/widgets/common/title_input_field.dart';
import 'package:xiaoyun_user/widgets/others/multi_photo_widget.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _descController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  List<Asset> _photoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(title: "意见反馈"),
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
                "请详细描述您的问题",
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
                placeholder: "请描述您 遇到的问题，我们将努力改进",
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
        CommonCard(
          padding: const EdgeInsets.symmetric(
              horizontal: Constant.padding, vertical: 10),
          child: TitleInputField(
            placeholder: "请输入您的联系方式",
            title: "联系方式",
            controller: _contactController,
            hiddenDivider: true,
          ),
        )
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
      ToastUtils.showInfo("请详细描述您的问题");
      return;
    }
    if (_contactController.text.isEmpty) {
      ToastUtils.showInfo("请输入您的联系方式\n以便我们能够联系到您~");
      return;
    }
    Map<String, dynamic> params = {
      "opinionDescribe": _descController.text,
      "contact": _contactController.text
    };
    if (_photoList.isNotEmpty) {
      ToastUtils.showLoading("上传中...");
      await UploadUtils.uploadMutiPhoto(_photoList, (photoModelList) {
        ToastUtils.dismiss();
        params["credentialsImgIds"] =
            photoModelList.map((e) => e.id).toList().join(",");
      }, (msg) {
        return;
      });
    }

    ToastUtils.showLoading("提交中...");

    HttpUtils.post(
      "user/feedBack.do",
      params: params,
      onSuccess: (resultData) {
        ToastUtils.showSuccess("提交成功，感谢您的反馈！");
        Future.delayed(Duration(seconds: 1)).then(
          (value) => NavigatorUtils.goBack(context),
        );
      },
    );
  }
}
