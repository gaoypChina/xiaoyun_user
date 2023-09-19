import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class UniteAccountSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UniteAccountSettingPageState();
  }
}

class UniteAccountSettingPageState extends State<UniteAccountSettingPage> {
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
                  subtitle: '徐大侠',
                  onClicked: ()  {

                  },
                ),
                CommonCellWidget(
                  title: '性别',
                  subtitle: '男',
                  onClicked: () {

                  },
                ),
                CommonCellWidget(
                  title: '手机号码',
                  subtitle: '15167100622',
                  onClicked: ()  {

                  },
                ),
                CommonCellWidget(
                  title: '身份证',
                  subtitle: '362330199904145333',
                  onClicked: () {

                  },
                ),
                CommonCellWidget(
                  title: '邮箱',
                  subtitle: '1025882793@qq.com',
                  onClicked: ()  {

                  },
                ),
                CommonCellWidget(
                  title: '银行卡',
                  subtitle: '1202021809000101288',
                  onClicked: () {

                  },
                ),
                CommonCellWidget(
                  title: '开户行',
                  subtitle: '杭州银行',
                  onClicked: () {

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

              },
            ),
          )
        ],
      ),
    );
  }
}