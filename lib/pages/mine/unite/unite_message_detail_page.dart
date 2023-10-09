import 'package:flutter/material.dart';
import 'package:xiaoyun_user/models/unite_message_detail_entity.dart';
import 'package:xiaoyun_user/network/apis.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/result_data.dart';
import 'package:xiaoyun_user/utils/color_util.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class UniteMessageCenterDetailPage extends StatefulWidget {
  final String messageId;
  const UniteMessageCenterDetailPage({super.key, required this.messageId});
  @override
  State<StatefulWidget> createState() {
    return UniteMessageCenterDetailPageState();
  }
}

class UniteMessageCenterDetailPageState extends State<UniteMessageCenterDetailPage> {

  late UniteMessageDetailEntity _model;

  @override
  void initState() {
    super.initState();
    _model = UniteMessageDetailEntity();
  }

  void _loadMessageData() {
    HttpUtils.get(Apis.uniteMessageDetail,params: {
      'id':widget.messageId
    },onSuccess: (ResultData resultData) {
      if(resultData.data == null) {
        return;
      }
      setState(() {
        _model = UniteMessageDetailEntity.fromJson(resultData.data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: '消息详情',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16
          ),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  _model.title??'',
                  style: TextStyle(
                      fontSize: 24,
                      color: HexColor('#25292C'),
                      fontWeight: FontWeight.bold)
                  ,),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                      _model.createTime??'',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 12,
                          color: HexColor('#999999')
                      )
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Text(_model.content??'',),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageDetailModel {
  String? createTime = '';
  String? title = '';
  String? content = '';
}