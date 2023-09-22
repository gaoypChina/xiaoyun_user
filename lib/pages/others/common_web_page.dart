import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class CommonWebPage extends StatefulWidget {
  final String title;
  final String urlStr;

  const CommonWebPage({super.key, this.title = "", required this.urlStr});

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<CommonWebPage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController =WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            ToastUtils.showLoading();
          },
          onPageStarted: (String url) {
            ToastUtils.showLoading();
          },
          onPageFinished: (String url) {
            ToastUtils.dismiss();
          },
          onWebResourceError: (WebResourceError error) {
            ToastUtils.showError(error.description);
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.urlStr));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: widget.title,
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: WebViewWidget(
            controller: _webViewController,
          ),
        ),
      ),
    );
  }
}
