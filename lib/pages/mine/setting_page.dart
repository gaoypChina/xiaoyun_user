import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/user_event_bus.dart';
import 'package:xiaoyun_user/models/user_model_entity.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/upload_utils.dart';
import 'package:xiaoyun_user/pages/mine/about_page.dart';
import 'package:xiaoyun_user/pages/mine/account_safe_page.dart';
import 'package:xiaoyun_user/pages/mine/modify_nickname_page.dart';
import 'package:xiaoyun_user/pages/mine/modify_phone_pwd_page.dart';
import 'package:xiaoyun_user/utils/date_picker_utils.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/photo_picker_utils.dart';
import 'package:xiaoyun_user/utils/sp_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_network_image.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  File? _photoFile;
  UserModelEntity? _userInfo;
  String _sexDesc = '保密';
  bool _hasPwd = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "账号设置",
      ),
      body: _buildListView(),
    );
  }

  ListView _buildListView() {
    return ListView(
      padding: const EdgeInsets.all(Constant.padding),
      children: [
        if (_userInfo != null)
          CommonCard(
            padding: Constant.horizontalPadding,
            child: Column(
              children: [
                CommonCellWidget(
                  title: "头像",
                  endSolt: _buildUserHeader(),
                  onClicked: _choosePhoto,
                ),
                CommonCellWidget(
                  title: "昵称",
                  subtitle: _userInfo!.nickname??"未设置",
                  onClicked: () async {
                    String? nickName = await NavigatorUtils.showPage(context, ModifyNicknamePage());
                    if (nickName != null) {
                      _userInfo!.nickname = nickName;
                      setState(() {});
                    }
                  },
                ),
                CommonCellWidget(
                  title: "性别",
                  subtitle: _sexDesc,
                  onClicked: () {
                    DialogUtils.showActionSheetDialog(
                      context,
                      message: "请选择性别",
                      dialogItems: [
                        ActionSheetDialogItem(
                          title: "男",
                          onPressed: () {
                            _sexDesc = '男';
                            _updateUserInfo({"sex": 1, "type": 2});
                          },
                        ),
                        ActionSheetDialogItem(
                          title: "女",
                          onPressed: () {
                            _sexDesc = '女';
                            _updateUserInfo({"sex": 2, "type": 2});
                          },
                        )
                      ],
                    );
                  },
                ),
                CommonCellWidget(
                  title: "生日",
                  subtitle: _userInfo!.birthday ?? "保密",
                  onClicked: () {
                    _showDatePicker();
                  },
                ),
                CommonCellWidget(
                  title: "手机号码",
                  subtitle: _userInfo!.phone??'未设置',
                  hiddenDivider: true,
                  onClicked: () {
                    NavigatorUtils.showPage(context, ModifyPhonePwdPage());
                  },
                ),
              ],
            ),
          ),
        SizedBox(height: 12),
        CommonCard(
          padding: Constant.horizontalPadding,
          child: Column(
            children: [
              CommonCellWidget(
                title: "账号安全",
                onClicked: () {
                  NavigatorUtils.showPage(
                    context,
                    AccountSafePage(hasPwd: _hasPwd),
                  );
                },
              ),
              CommonCellWidget(
                title: "关于",
                hiddenDivider: true,
                onClicked: () {
                  NavigatorUtils.showPage(context, AboutPage());
                },
              )
            ],
          ),
        ),
        SizedBox(height: 60),
        CommonActionButton(
          bgColor: Colors.white,
          title: "退出登录",
          titleColor: DYColors.text_red,
          onPressed: () {
            DialogUtils.showActionSheetDialog(
              context,
              message: "确定要退出当前登录吗？",
              dialogItems: [
                ActionSheetDialogItem(
                  title: "退出",
                  isDestructiveAction: true,
                  onPressed: () {
                    SpUtil.putBool(Constant.loginState, false);
                    UserEventBus().fire(UserStateChangedEvent(false));
                    JPush().deleteAlias();
                    NavigatorUtils.goBack(context);
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildUserHeader() {
    Widget userDefault = DYLocalImage(
      imageName: "common_user_header",
      size: 45,
    );
    Widget header = userDefault;
    if (_photoFile != null) {
      header = Image.file(
        _photoFile!,
        width: 45,
        height: 45,
        fit: BoxFit.cover,
      );
    } else if (_userInfo!.avatarImgUrl != null &&
        _userInfo!.avatarImgUrl!.isNotEmpty) {
      header = DYNetworkImage(
        imageUrl: _userInfo!.avatarImgUrl!,
        placeholder: userDefault,
        size: 45,
      );
    }
    return ClipOval(
      child: header,
    );
  }

  void _choosePhoto() async {
    File? photoFile = await PhotoPickerUtils.pickPhoto(context, maxWidth: 500);
    if (photoFile == null) return;

    _photoFile = photoFile;
    setState(() {});
    _uploadPhoto();
  }

  void _showDatePicker() {
    DateTime birthday = DateTime.tryParse(_userInfo!.birthday ?? "") ?? DateTime(1985, 6, 15);

    DatePickerUtils.showDatePicker(
      context,
      maxTime: DateTime.now(),
      initialDateTime: birthday,
      onConfirm: (time) {
        _userInfo!.birthday = formatDate(time, [yyyy, '-', mm, '-', dd]);
        _updateUserInfo({"birthDay": _userInfo!.birthday, "type": 1});
      },
    );
  }

  void _uploadPhoto() async {
    ToastUtils.showLoading("上传中...");
    PhotoModel? photoModel = await UploadUtils.uploadPhoto(_photoFile!);
    ToastUtils.dismiss();
    if (photoModel == null) return;
    _updateUserInfo({"avatar": photoModel.id, "type": 3});
  }

  void _loadUserInfo() {
    ToastUtils.showLoading();
    HttpUtils.get(
      "user/userDetail.do",
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        _userInfo = UserModelEntity.fromJson(resultData.data);
        if (_userInfo!.sex == null) {
          _sexDesc = '保密';
        } else {
          if (_userInfo!.sex == 0) {
            _sexDesc = "保密";
          } else if (_userInfo!.sex == 1) {
            _sexDesc = "男";
          } else {
            _sexDesc = "女";
          }
        }

        _hasPwd = ObjectUtil.isNotEmpty(_userInfo!.password);
        setState(() {});
      },
    );
  }

  void _updateUserInfo(Map<String, dynamic> params) {
    ToastUtils.showLoading("保存中...");
    HttpUtils.post(
      "user/updateUser.do",
      params: params,
      onSuccess: (resultData) {
        setState(() {});
        ToastUtils.showSuccess("修改成功");
        int type = params["type"];
        if (type == 3) {
          Future.delayed(Duration(seconds: 1), () {
            UserEventBus().fire(UserStateChangedEvent(true));
          });
        }
      },
    );
  }
}
