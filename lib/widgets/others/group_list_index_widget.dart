import 'package:flutter/material.dart';

class GroupListIndexWidget extends StatelessWidget {
  final String tag;
  final double susHeight;

  const GroupListIndexWidget({Key key, this.tag, this.susHeight = 40})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String tagStr = this.tag;
    if (tag == '★') {
      tagStr = '★ 热门城市';
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        tagStr,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }
}
