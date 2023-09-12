import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/title_input_field.dart';
import 'package:xiaoyun_user/widgets/others/check_button.dart';

enum BillType { company, personal }

class BillTitleAddPage extends StatefulWidget {
  @override
  _BillTitleAddPageState createState() => _BillTitleAddPageState();
}

class _BillTitleAddPageState extends State<BillTitleAddPage> {
  BillType _billType = BillType.company;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _dutyNoController = TextEditingController();
  TextEditingController _regAddressController = TextEditingController();
  TextEditingController _openBankController = TextEditingController();
  TextEditingController _regPhoneController = TextEditingController();
  TextEditingController _bankNoController = TextEditingController();

  bool _isDefault = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "我的发票抬头",
      ),
      body: _buildListView(),
    );
  }

  ListView _buildListView() {
    return ListView(
      padding: const EdgeInsets.all(Constant.padding),
      children: [
        CommonCard(
          padding: Constant.horizontalPadding,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    _buildBillTypeBtn(BillType.company),
                    SizedBox(width: 28),
                    _buildBillTypeBtn(BillType.personal),
                  ],
                ),
              ),
              Divider(height: 0.5),
              TitleInputField(
                title: _billType == BillType.company ? "公司名称" : "抬头名称",
                isRequired: true,
                placeholder:
                    _billType == BillType.company ? "请输入公司名称" : "请输入抬头名称",
                hiddenDivider: _billType == BillType.personal,
                controller: _titleController,
              ),
              if (_billType == BillType.company) ..._companyInputWidget(),
            ],
          ),
        ),
        SizedBox(height: 12),
        CommonCard(
          padding: const EdgeInsets.symmetric(
              vertical: 8, horizontal: Constant.padding),
          child: Row(
            children: [
              Text("设为默认抬头"),
              Spacer(),
              CupertinoSwitch(
                activeColor: DYColors.primary,
                value: _isDefault,
                onChanged: (value) {
                  setState(() {
                    _isDefault = !_isDefault;
                  });
                },
              )
            ],
          ),
        ),
        SizedBox(height: 50),
        CommonActionButton(
          title: "保存",
          onPressed: _saveBtnClicked,
        ),
      ],
    );
  }

  List<Widget> _companyInputWidget() {
    List<Widget> inputWidgetList = [];
    inputWidgetList.addAll([
      TitleInputField(
        title: "公司税号",
        isRequired: true,
        placeholder: "请填写纳税人识别号",
        controller: _dutyNoController,
      ),
      TitleInputField(
        title: "注册地址",
        placeholder: "请填写公司注册地址",
        controller: _regAddressController,
      ),
      TitleInputField(
        title: "注册电话",
        placeholder: "请填写公司注册电话",
        controller: _regPhoneController,
      ),
      TitleInputField(
        title: "开户银行",
        placeholder: "请填写公司开户银行",
        controller: _openBankController,
      ),
      TitleInputField(
        title: "银行账号",
        placeholder: "请填写银行账号",
        hiddenDivider: true,
        controller: _bankNoController,
      ),
    ]);
    return inputWidgetList;
  }

  Widget _buildBillTypeBtn(BillType billType) {
    return CheckButton(
      title: billType == BillType.company ? "企业单位" : "个人/非企业单位",
      isChecked: _billType == billType,
      onPressed: () {
        setState(() {
          _billType = billType;
        });
      },
    );
  }

  void _saveBtnClicked() {
    if (_titleController.text.isEmpty) {
      ToastUtils.showInfo("请输入抬头名称");
      return;
    }
    String netPath;
    Map<String, dynamic> params = {
      "isDefault": _isDefault ? 1 : 0,
    };
    if (_billType == BillType.company) {
      netPath = "userBill/addCompany.do";
      if (_dutyNoController.text.isEmpty) {
        ToastUtils.showInfo("请输入公司税号");
        return;
      }
      params["company"] = _titleController.text;
      params["dutyNo"] = _dutyNoController.text;
      if (_regAddressController.text.isNotEmpty) {
        params["regAddress"] = _regAddressController.text;
      }
      if (_regPhoneController.text.isNotEmpty) {
        params["regPhone"] = _regPhoneController.text;
      }
      if (_openBankController.text.isNotEmpty) {
        params["openBank"] = _openBankController.text;
      }
      if (_bankNoController.text.isNotEmpty) {
        params["bankNo"] = _bankNoController.text;
      }
    } else {
      netPath = "userBill/add.do";
      params["uname"] = _titleController.text;
    }
    ToastUtils.showLoading("保存中...");
    HttpUtils.post(
      netPath,
      params: params,
      onSuccess: (resultData) {
        ToastUtils.showSuccess("添加成功");
        Future.delayed(Duration(seconds: 1), () {
          NavigatorUtils.goBackWithParams(context, true);
        });
      },
    );
  }
}
