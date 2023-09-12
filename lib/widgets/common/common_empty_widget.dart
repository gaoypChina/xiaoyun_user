import 'package:flutter/material.dart';

class CommonEmptyWidget extends StatelessWidget {
  final String emptyTips;

  const CommonEmptyWidget({
    Key key,
    this.emptyTips = '暂无数据',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/common/common_empty.png',
          width: 160,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            emptyTips,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xff999999),
            ),
          ),
        ),
      ],
    );
  }
}
