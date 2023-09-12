import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/notice_model.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/others/common_dot.dart';

class NoticeCell extends StatelessWidget {
  final NoticeModel noticeModel;

  const NoticeCell({Key key, this.noticeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                this.noticeModel.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 6),
                child: Offstage(
                  offstage: this.noticeModel.isRead,
                  child: CommonDot(color: DYColors.text_red, size: 6),
                ),
              ),
              Spacer(),
              Text(
                this.noticeModel.createTime,
                style: TextStyle(
                  fontSize: 12,
                  color: DYColors.text_gray,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Constant.padding),
            child: Divider(height: 1),
          ),
          Text(this.noticeModel.content),
        ],
      ),
    );
  }
}
