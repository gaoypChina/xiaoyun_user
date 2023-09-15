import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
// import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/user_info_entity.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_network_image.dart';

class ChatListCell extends StatefulWidget {
  // final Conversation conversation;
  // const ChatListCell({Key key, this.conversation}) : super(key: key);

  @override
  _ChatListCellState createState() => _ChatListCellState();
}

class _ChatListCellState extends State<ChatListCell> {
  UserInfoEntity? _targetUserInfo;

  int _unReadCount = 0;

  @override
  void initState() {
    super.initState();
    // _getUserInfo();
    // _getUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          _buildUserPortrait(),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _targetUserInfo == null ? '' : _targetUserInfo!.name??'',
                  style: TextStyle(
                    fontSize: 16,
                    color: DYColors.text_normal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                _buildContent(),
              ],
            ),
          ),
          if (_unReadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: const EdgeInsets.only(right: 5),
              child: Text(
                _unReadCount > 99 ? "99+" : "$_unReadCount",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          // Text(
          //   _convertTime(widget.conversation.receivedTime),
          //   style: TextStyle(fontSize: 12, color: DYColors.text_gray),
          // ),
        ],
      ),
    );
  }

  // void _getUserInfo() {
  //   XYUserInfo userInfo =
  //       UserInfoDataSource.cachedUserMap[widget.conversation.targetId];
  //   if (userInfo == null) {
  //     UserInfoDataSource.getUserInfo(widget.conversation.targetId).then((user) {
  //       setState(() {
  //         _targetUserInfo = user;
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       _targetUserInfo = userInfo;
  //     });
  //   }
  // }

  Widget _buildContent() {
    String content = "[未知消息]";
    // if (widget.conversation.latestMessageContent != null) {
    //   if (widget.conversation.objectName == "RC:TxtMsg") {
    //     TextMessage message = widget.conversation.latestMessageContent;
    //     content = message.content;
    //   } else {
    //     content = "[图片]";
    //   }
    // }
    return Text(
      content,
      maxLines: 1,
    );
  }

  // void _getUnreadCount() {
  //   RongIMClient.getUnreadCount(
  //       RCConversationType.Private, widget.conversation.targetId,
  //       (int count, int code) {
  //     if (0 == code) {
  //       setState(() {
  //         _unReadCount = count;
  //       });
  //     }
  //   });
  // }

  /// 用户头像
  Widget _buildUserPortrait() {
    Widget protraitWidget;
    Widget placeholder = DYLocalImage(
      imageName: "common_staff_header",
      size: 60,
    );
    if (_targetUserInfo == null || ObjectUtil.isEmptyString(_targetUserInfo!.portraitUrl)) {
      protraitWidget = placeholder;
    } else {
      protraitWidget = DYNetworkImage(
        imageUrl: _targetUserInfo!.portraitUrl!,
        placeholder: placeholder,
        size: 60,
      );
    }
    return ClipOval(
      child: protraitWidget,
    );
  }

  String _convertTime(int timestamp) {
    DateTime msgTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime nowTime = DateTime.now();

    if (nowTime.year == msgTime.year) {
      //同一年
      if (nowTime.month == msgTime.month) {
        //同一月
        if (nowTime.day == msgTime.day) {
          //同一天 时:分
          return formatDate(msgTime, [HH, ':', nn]);
        } else {
          if (nowTime.day - msgTime.day == 1) {
            //昨天
            return "昨天";
          } else if (nowTime.day - msgTime.day < 7) {
            return [
              "星期一",
              "星期二",
              "星期三",
              "星期四",
              "星期五",
              "星期六",
              "星期日"
            ][msgTime.weekday - 1];
          }
        }
      }
    }
    return formatDate(msgTime, [yyyy, '-', mm, '-', dd]);
  }
}
