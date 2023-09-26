import 'package:flutter/material.dart';
import 'package:xiaoyun_user/utils/color_util.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class UniteMessageCenterDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UniteMessageCenterDetailPageState();
  }
}

class UniteMessageCenterDetailPageState extends State<UniteMessageCenterDetailPage> {
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
                  '标题',
                  style: TextStyle(
                      fontSize: 24,
                      color: HexColor('#25292C'),
                      fontWeight: FontWeight.bold)
                  ,),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                      '2023-8-26 18:39',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 12,
                          color: HexColor('#999999')
                      )
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Text('尊敬的用户，恭喜您成为鲸轿合伙人，xxx尊敬的用户，恭喜您成为鲸轿合伙人，xxx尊敬的用户，恭喜您成为鲸轿合伙人，xxx尊敬的用户，恭喜您成为鲸轿合伙人，xxx!!!!!'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}