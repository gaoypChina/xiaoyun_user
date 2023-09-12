import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class ServiceDetailPage extends StatefulWidget {
  final String content;
  const ServiceDetailPage({
    Key key,
    this.content = "",
  }) : super(key: key);

  @override
  _ServiceDetailPageState createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(title: "服务详情"),
      body: SingleChildScrollView(
        child: Html(
          data: widget.content,
          style: {
            "img": Style(
              width: MediaQuery.of(context).size.width,
            )
          },
          onImageTap: (url, context, attributes, element) {},
        ),
      ),
    );
  }
}
