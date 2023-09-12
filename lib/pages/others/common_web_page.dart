import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class CommonWebPage extends StatefulWidget {
  final String title;
  final String urlStr;

  const CommonWebPage({Key key, this.title = "", this.urlStr})
      : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<CommonWebPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: widget.title,
      ),
      body: WebView(
        gestureNavigationEnabled: true,
        initialUrl: widget.urlStr,
        onPageStarted: (url) {
          ToastUtils.showLoading("加载中...");
        },
        onPageFinished: (url) {
          ToastUtils.dismiss();
        },
      ),
    );
  }
}
