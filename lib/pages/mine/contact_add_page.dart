import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/common/title_input_field.dart';

import '../../constant/constant.dart';
import '../../models/contact_info_model.dart';

class ContactAddPage extends StatefulWidget {
  final ContactInfo contactInfo;
  const ContactAddPage({Key key, this.contactInfo}) : super(key: key);

  @override
  State<ContactAddPage> createState() => _ContactAddPageState();
}

class _ContactAddPageState extends State<ContactAddPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  bool _isDefault = false;
  int _sexIndex = -1;
  bool _isEditMode = false;

  @override
  void initState() {
    _isEditMode = widget.contactInfo != null;
    if (_isEditMode) {
      _nameController.text = widget.contactInfo.contactName;
      _phoneController.text = widget.contactInfo.contactPhone;
      _addressController.text = widget.contactInfo.address;
      _isDefault = widget.contactInfo.isDefault;
      _sexIndex = widget.contactInfo.sex;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: _isEditMode ? "编辑联系人信息" : "添加联系人信息",
        actions: [
          if (_isEditMode)
            NavigationItem(
              title: "删除",
              textColor: DYColors.text_red,
              onPressed: () {
                DialogUtils.showActionSheetDialog(
                  context,
                  message: "确定要删除该联系信息吗？",
                  dialogItems: [
                    ActionSheetDialogItem(
                      title: "删除",
                      isDestructiveAction: true,
                      onPressed: _deleteAction,
                    ),
                  ],
                );
              },
            )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Constant.padding),
        children: [
          CommonCard(
            padding: const EdgeInsets.symmetric(horizontal: Constant.padding),
            child: Column(
              children: [
                TitleInputField(
                  textAlign: TextAlign.start,
                  hiddenDivider: true,
                  controller: _nameController,
                  title: "联系人",
                  placeholder: "请填写联系人姓名",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 80, top: 5, bottom: 10),
                  child: Row(
                    children: [
                      _genderBtn(isMale: true),
                      SizedBox(width: 10),
                      _genderBtn(isMale: false),
                    ],
                  ),
                ),
                Divider(height: 1),
                TitleInputField(
                  textAlign: TextAlign.start,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  title: "联系电话",
                  placeholder: "请填写联系电话",
                ),
                TitleInputField(
                  textAlign: TextAlign.start,
                  hiddenDivider: true,
                  controller: _addressController,
                  title: "车辆位置",
                  placeholder: "如：X层X区X号车位",
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          CommonCard(
            padding: const EdgeInsets.symmetric(
                horizontal: Constant.padding, vertical: 0),
            child: CommonCellWidget(
              padding: const EdgeInsets.symmetric(vertical: 10),
              title: "设为默认",
              showArrow: false,
              hiddenDivider: true,
              endSolt: CupertinoSwitch(
                value: _isDefault,
                activeColor: DYColors.primary,
                onChanged: (value) {
                  setState(() {
                    _isDefault = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 30),
          CommonActionButton(title: "保存", onPressed: _saveAction),
        ],
      ),
    );
  }

  Widget _genderBtn({bool isMale}) {
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

  void _saveAction() {
    if (_nameController.text.isEmpty) {
      ToastUtils.showInfo("请输入姓名");
      return;
    }
    if (_sexIndex == -1) {
      ToastUtils.showInfo("请先选择性别");
      return;
    }
    if (_phoneController.text.length != 11) {
      ToastUtils.showInfo("请输入11位有效的手机号");
      return;
    }

    if (_addressController.text.isEmpty) {
      ToastUtils.showInfo("请输入车辆位置");
      return;
    }

    Map<String, dynamic> params = {
      "contactName": _nameController.text,
      "contactPhone": _phoneController.text,
      "address": _addressController.text,
      "sex": _sexIndex,
      "isDefault": _isDefault ? 1 : 0,
    };
    if (_isEditMode) {
      params["id"] = widget.contactInfo.id;
    }
    ToastUtils.showLoading("保存中...");
    HttpUtils.post(
      "address/addOrUpdate.do",
      params: params,
      onSuccess: (resultData) {
        ToastUtils.showSuccess("保存成功");
        Future.delayed(Duration(seconds: 1), () {
          NavigatorUtils.goBackWithParams(context, true);
        });
      },
    );
  }

  void _deleteAction() {
    ToastUtils.showLoading("删除中...");
    HttpUtils.get(
      "address/delete.do",
      params: {"id": widget.contactInfo.id},
      onSuccess: (resultData) {
        ToastUtils.showSuccess("删除成功");
        Future.delayed(Duration(seconds: 1), () {
          NavigatorUtils.goBackWithParams(context, true);
        });
      },
    );
  }
}
