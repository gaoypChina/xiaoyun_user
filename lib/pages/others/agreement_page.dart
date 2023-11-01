import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/common_utils.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class AgreementPage extends StatefulWidget {
  final String title;
  final int type;

  const AgreementPage({super.key, this.title = "用户协议", this.type = 1});

  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  String _content = "";

  @override
  void initState() {
    super.initState();
    _loadHtmlContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(title: widget.title),
      body: SingleChildScrollView(
        child: HtmlWidget(
          _content,
          onTapUrl: (urlStr) async {
            if (ObjectUtil.isEmptyString(urlStr)) return false;
            CommonUtils.launchWebUrl(urlStr);
            return true;
          }),
      ),
    );
  }

  void _loadHtmlContent() {
    HttpUtils.get(
      "approve/registeredAgreement.do",
      params: {"cid": widget.type},
      onSuccess: (resultData) {
        setState(() {
          _content = resultData.data["content"];
        });
      },
    );
  }
}
