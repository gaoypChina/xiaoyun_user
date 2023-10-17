import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/unite_setting_entity.dart';
import 'package:xiaoyun_user/network/apis.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/result_data.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class UniteAccountSettingPage extends StatefulWidget {
  final bool isChangeInfo;

  const UniteAccountSettingPage({super.key,this.isChangeInfo = false});

  @override
  State<StatefulWidget> createState() {
    return UniteAccountSettingPageState();
  }
}

class UniteAccountSettingPageState extends State<UniteAccountSettingPage> {
  UniteSettingEntity? _settingEntity;
  late String _sexStr;
  late TextEditingController _realNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _idCardController;
  late TextEditingController _emailController;
  late TextEditingController _bankCardController;
  late TextEditingController _bankNameController;

  @override
  void initState() {
    super.initState();
    _sexStr = '未知';
    _realNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _idCardController = TextEditingController();
    _emailController = TextEditingController();
    _bankCardController = TextEditingController();
    _bankNameController = TextEditingController();
    if (widget.isChangeInfo) {
      _loadSettingData();
    }
  }

  ///获取账号信息
  void _loadSettingData() {
    ToastUtils.showLoading('加载中');
    HttpUtils.get(Apis.uniteAccountInfo,onSuccess: (ResultData resultData) {
      ToastUtils.dismiss();
      if (resultData.data == null) {
        return;
      }
      _settingEntity = UniteSettingEntity.fromJson(resultData.data);
      if (_settingEntity!.sex != 0) {
        _sexStr = _settingEntity!.sex == 1 ? '男':'女';
      }
      _realNameController.text = _settingEntity!.realName??'';
      _phoneNumberController.text = _settingEntity!.mobile??'';
      _idCardController.text = _settingEntity!.idCard??'';
      _emailController.text = _settingEntity!.email??'';
      _bankCardController.text = _settingEntity!.bankCard??'';
      _bankNameController.text = _settingEntity!.bankName??'';
      setState(() {});
    });
  }

  ///修改设置信息
  void _changeSettingInfo() {
    if (_realNameController.text.isEmpty) {
      ToastUtils.showText('姓名不能为空');
      return;
    }

    if (!RegexUtil.isMobileSimple(_phoneNumberController.text)) {
      ToastUtils.showText('请输入11位有效的手机号');
      return;
    }

    if (!RegexUtil.isIDCard(_idCardController.text)) {
      ToastUtils.showText('身份证号码不正确');
      return;
    }

    if (!RegexUtil.isEmail(_emailController.text)) {
      ToastUtils.showText('邮箱地址不正确');
      return;
    }

    if (_bankCardController.text.isEmpty) {
      ToastUtils.showText('银行卡号不能为空');
      return;
    }

    if (_bankNameController.text.isEmpty) {
      ToastUtils.showText('开户行名称不能为空');
      return;
    }

    Map<String,dynamic>? dataMap;
    dataMap = {'real_name':_realNameController.text};
    int sex = 0;
    if (_sexStr != '未知') {
      sex = _sexStr == '男' ? 1:2;
    }
    dataMap = {'sex':sex};
    dataMap = {'mobile':_phoneNumberController.text};
    dataMap = {'id_card':_idCardController.text};
    dataMap = {'email':_emailController.text};
    dataMap = {'bank_name':_bankCardController.text};
    dataMap = {'bank_card':_bankCardController.text};

    HttpUtils.post(
        Apis.uniteChangeAccountInfo,
        params: dataMap,
        onSuccess: (ResultData resultData){
          _loadSettingData();
        });
  }


  /// 性别选择
  void _showSexSheetDialog() {
    DialogUtils.showActionSheetDialog(
      context,
      message: "请选择性别",
      dialogItems: [
        ActionSheetDialogItem(
          title: "男",
          onPressed: () {
            setState(() {
              _sexStr = '男';
            });
          },
        ),
        ActionSheetDialogItem(
          title: "女",
          onPressed: () {
            setState(() {
              _sexStr = '女';
            });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: '账号设置',
        actions: [
          TextButton(
              onPressed: _changeSettingInfo,
              child: Text(
                '保存',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue
                ),
              )
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Constant.padding),
        children: [
          CommonCard(
            padding: Constant.horizontalPadding,
            child: Column(
              children: [
                CommonCellWidget(
                  title: '真实姓名',
                  subtitleWidget: DYTextField(
                    textAlign: TextAlign.right,
                    controller: _realNameController,
                    clearButtonMode: OverlayVisibilityMode.never,
                  ),
                ),
                CommonCellWidget(
                  title: '性别',
                  subtitle: _sexStr,
                  onClicked: () {
                    _showSexSheetDialog();
                  },
                ),
                CommonCellWidget(
                  title: '手机号码',
                  subtitleWidget: DYTextField(
                    textAlign: TextAlign.right,
                    controller: _phoneNumberController,
                    clearButtonMode: OverlayVisibilityMode.never,
                  ),
                ),
                CommonCellWidget(
                  title: '身份证',
                  subtitleWidget: DYTextField(
                    textAlign: TextAlign.right,
                    controller: _idCardController,
                    clearButtonMode: OverlayVisibilityMode.never,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                CommonCellWidget(
                  title: '邮箱',
                  subtitleWidget: DYTextField(
                    textAlign: TextAlign.right,
                    controller: _emailController,
                    clearButtonMode: OverlayVisibilityMode.never,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                CommonCellWidget(
                  title: '银行卡',
                  subtitleWidget: DYTextField(
                    textAlign: TextAlign.right,
                    controller: _bankCardController,
                    clearButtonMode: OverlayVisibilityMode.never,
                    keyboardType: TextInputType.number,
                  ),
                ),
                CommonCellWidget(
                  title: '开户行',
                  subtitleWidget: DYTextField(
                    textAlign: TextAlign.right,
                    controller: _bankNameController,
                    clearButtonMode: OverlayVisibilityMode.never,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15,),
          CommonCard(
            padding: Constant.horizontalPadding,
            child:  CommonCellWidget(
              title: '相关协议',
              onClicked: () {
                NavigatorUtils.goWebViewPage(context, '相关协议', 'https://www.baidu.com');
              },
            ),
          )
        ],
      ),
    );
  }
}