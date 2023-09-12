import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class GroupListItemWidget extends StatelessWidget {
  final String tag;
  final String name;
  final double susHeight;
  final Function onTap;

  const GroupListItemWidget(
      {Key key, this.tag, this.name, this.susHeight = 40, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          child: Container(
            child: Text(this.name),
            padding: const EdgeInsets.all(Constant.padding),
            width: double.infinity,
            color: Colors.white,
          ),
          onTap: this.onTap,
        ),
        Divider(height: 1),
      ],
    );
  }
}
