import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/pages/others/agreement_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "关于",
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Constant.padding),
              children: [
                CommonCard(
                  padding: Constant.horizontalPadding,
                  child: Column(
                    children: [
                      CommonCellWidget(
                        title: "用户协议",
                        onClicked: () {
                          _showAgreement("用户协议", 4);
                        },
                      ),
                      CommonCellWidget(
                        title: "隐私政策",
                        onClicked: () {
                          _showAgreement("隐私政策", 5);
                        },
                      ),
                      Offstage(
                        offstage:Platform.isIOS,
                        child: CommonCellWidget(
                          title: "第三方信息共享清单",
                          titleWidth: 180,
                          onClicked: () {
                            _showAgreement("第三方信息共享清单", 10);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  '版本号：V${_packageInfo.version} Build${_packageInfo.buildNumber}',
                  style: TextStyle(
                    fontSize: 12,
                    color: DYColors.text_gray,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showAgreement(String title, int type) {
    NavigatorUtils.showPage(
      context,
      AgreementPage(
        title: title,
        type: type,
      ),
    );
  }
}
