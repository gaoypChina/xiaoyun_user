import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

import '../../network/http_utils.dart';

class RechargeAgreementPage extends StatefulWidget {
  const RechargeAgreementPage({Key key}) : super(key: key);

  @override
  State<RechargeAgreementPage> createState() => _RechargeAgreementPageState();
}

class _RechargeAgreementPageState extends State<RechargeAgreementPage> {
  String _content = "";

  @override
  void initState() {
    super.initState();
    _loadHtmlContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(title: "充值协议"),
      body: SingleChildScrollView(
        child: Html(data: _content),
      ),
    );
  }

  void _loadHtmlContent() {
    HttpUtils.get(
      "userHome/getRechargeProtocol.do",
      onSuccess: (resultData) {
        setState(() {
          _content = resultData.data["protocol"];
        });
      },
    );
  }
}
