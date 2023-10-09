import 'package:common_utils/common_utils.dart';
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

enum SettingType {
  ///未知
  unKnown,
  ///真实姓名
  realName,
  ///性别
  sex,
  ///手机号码
  phone,
  ///身份证
  idCard,
  ///邮箱
  email,
  ///银行卡号
  bankNum,
  ///开户行
  bankName;
}

class UniteAccountSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UniteAccountSettingPageState();
  }
}

class UniteAccountSettingPageState extends State<UniteAccountSettingPage> {
  UniteSettingEntity? _settingEntity;
  late SettingType _settingType;
  late TextEditingController _couponController;

  @override
  void initState() {
    super.initState();
    _settingType = SettingType.unKnown;
    _couponController = TextEditingController();
    _loadSettingData();
  }

  ///获取账号信息
  void _loadSettingData() {
    HttpUtils.get(Apis.uniteAccountInfo,onSuccess: (ResultData resultData) {
      setState(() {
        _settingEntity = UniteSettingEntity.fromJson(resultData.data);
      });
    });
  }

  ///修改设置信息
  void _changeSettingInfo(Map<String, dynamic> mapData) {
    HttpUtils.post(
        Apis.uniteChangeAccountInfo,
        params: mapData,
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
            Map<String,dynamic>? dataMap;
            dataMap = {'sex':'1'};
            _changeSettingInfo(dataMap);

          },
        ),
        ActionSheetDialogItem(
          title: "女",
          onPressed: () {
            Map<String,dynamic>? dataMap;
            dataMap = {'sex':'2'};
            _changeSettingInfo(dataMap);
          },
        )
      ],
    );
  }

  void _showSettingAlert(String tipTitle,String placeholder,String currentTitle) {
    _couponController.text = currentTitle;

    DialogUtils.showAlertDialog(
      context,
      title: tipTitle,
      autoDismiss: false,
      onDismissCallback: (type) {},
      body: Column(
        children: [
          Text(
            tipTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: DYColors.text_normal,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: SizedBox(
              height: 40,
              child: DYTextField(
                controller: _couponController,
                placeholder: placeholder
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: DYColors.divider,
              ),
            ),
          ),
        ],
      ),
      cancelAction: () {},
      confirmAction: () {
        if(_couponController.text.isEmpty) {
          ToastUtils.showText('内容不能为空');
          return;
        }
        Map<String,dynamic>? dataMap;
        if (_settingType == SettingType.phone) {
          if (!RegexUtil.isMobileSimple(_couponController.text)) {
            ToastUtils.showText('请输入11位有效的手机号');
            return;
          } else {
            dataMap = {'mobile':_couponController.text};
          }
        }
        if (_settingType == SettingType.idCard) {
          if (!RegexUtil.isIDCard(_couponController.text)) {
            ToastUtils.showText('请输入有效身份证号码');
            return;
          } else {
            dataMap = {'id_card':_couponController.text};
          }
        }
        if (_settingType == SettingType.email) {
          if (!RegexUtil.isEmail(_couponController.text)) {
            ToastUtils.showText('请输入有效邮箱号码');
            return;
          } else {
            dataMap = {'email':_couponController.text};
          }
        }
        if (_settingType == SettingType.realName) {
          dataMap = {'real_name':_couponController.text};
        }
        if (_settingType == SettingType.bankNum) {
          dataMap = {'bank_card':_couponController.text};
        }
        if (_settingType == SettingType.bankName) {
          dataMap = {'bank_name':_couponController.text};
        }
        _changeSettingInfo(dataMap!);
        _couponController.clear();
        NavigatorUtils.goBack(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: '账号设置',
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
                  subtitle: _settingEntity?.realName??'',
                  onClicked: ()  {
                    _settingType = SettingType.realName;
                    _showSettingAlert('修改真实姓名', '请输入名称', _settingEntity?.realName??'');
                  },
                ),
                CommonCellWidget(
                  title: '性别',
                  subtitle: _settingEntity?.sex! == 0 ? '女':'男',
                  onClicked: () {
                    _settingType = SettingType.sex;
                    _showSexSheetDialog();
                  },
                ),
                CommonCellWidget(
                  title: '手机号码',
                  subtitle: _settingEntity?.mobile??'',
                  onClicked: ()  {
                    _settingType = SettingType.phone;
                    _showSettingAlert('修改手机号码', '请输入手机号', _settingEntity?.mobile??'');
                  },
                ),
                CommonCellWidget(
                  title: '身份证',
                  subtitle: _settingEntity?.idCard??'',
                  onClicked: () {
                    _settingType = SettingType.idCard;
                    _showSettingAlert('修改身份证', '请输入身份证号码', _settingEntity?.idCard??'');
                  },
                ),
                CommonCellWidget(
                  title: '邮箱',
                  subtitle: _settingEntity?.email??'',
                  onClicked: ()  {
                    _settingType = SettingType.email;
                    _showSettingAlert('修改邮箱', '请输入邮箱号码', _settingEntity?.email??'');
                  },
                ),
                CommonCellWidget(
                  title: '银行卡',
                  subtitle: _settingEntity?.bankCard??'',
                  onClicked: () {
                    _settingType = SettingType.bankNum;
                    _showSettingAlert('修改银行卡号', '请输入银行卡号', _settingEntity?.bankCard??'');
                  },
                ),
                CommonCellWidget(
                  title: '开户行',
                  subtitle: _settingEntity?.bankName??'',
                  onClicked: () {
                    _settingType = SettingType.bankName;
                    _showSettingAlert('修改开户行', '请输入开户行名称', _settingEntity?.bankName??'');
                  },
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