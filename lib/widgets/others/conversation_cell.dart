import 'package:flutter/material.dart';
// import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import '../../constant/constant.dart';
import '../../widgets/common/common_local_image.dart';
import '../../widgets/common/common_network_image.dart';

class ConversationCell extends StatelessWidget {
  // final Message message;
  final bool showDate;
  final String senderPhotoUrl;
  final String targetPhotoUrl;

  const ConversationCell({
    Key key,
    // this.message,
    this.showDate = true,
    this.senderPhotoUrl,
    this.targetPhotoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Constant.padding, vertical: 10),
      child: _buildMessageWidget(context),
    );
  }

  Widget _buildMessageWidget(BuildContext context) {
    // MessageContent messageContent = this.message.content;
    Widget messageWidget;
    // if (this.message.messageDirection == RCMessageDirection.Send) {
    //   messageWidget = Row(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       // Flexible(
    //       //   child: _buildMessageContent(context, messageContent, true),
    //       // ),
    //       SizedBox(width: 8),
    //       _buildUserHeader(true),
    //     ],
    //   );
    // } else {
    messageWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserHeader(false),
        SizedBox(width: 8),
        // Flexible(child: _buildMessageContent(context, messageContent, false)),
      ],
    );
    // }
    // // DateTime dateTime =
    // //     DateTime.fromMillisecondsSinceEpoch(this.message.sentTime);
    // DateTime nowTime = DateTime.now();
    // String timeStr =
    //     formatDate(dateTime, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
    // if (dateTime.year == nowTime.year && dateTime.month == nowTime.month) {
    //   if (dateTime.day == nowTime.day) {
    //     timeStr = formatDate(dateTime, [HH, ':', nn, ':', ss]);
    //   }
    //   DateTime tempDate = dateTime.add(Duration(days: 1));
    //   if (tempDate.day == nowTime.day) {
    //     timeStr = "昨天 " + formatDate(dateTime, [HH, ':', nn, ':', ss]);
    //   }
    // }
    return Column(
      children: [
        if (this.showDate)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "timeStr",
              style: TextStyle(fontSize: 12, color: DYColors.text_gray),
            ),
          ),
        messageWidget,
      ],
    );
  }

  Widget _buildUserHeader(bool isSend) {
    Widget placeholder = DYLocalImage(
      imageName: isSend ? 'common_user_header' : 'common_staff_header',
      size: 44,
    );
    String portraitUrl = isSend ? this.senderPhotoUrl : this.targetPhotoUrl;
    if (portraitUrl == null || portraitUrl.isEmpty) {
      return ClipOval(child: placeholder);
    }
    return ClipOval(
      child: DYNetworkImage(
        imageUrl: portraitUrl,
        placeholder: placeholder,
        size: 44,
      ),
    );
  }

  // Widget _buildMessageContent(
  //     BuildContext context, MessageContent messageContent, bool isSend) {
  //   Widget child;
  //   bool isImage = messageContent is ImageMessage;
  //   Color bgColor = isSend ? DYColors.primary : Color(0xffF0F2F7);
  //   if (messageContent is TextMessage) {
  //     TextMessage textMessage = messageContent;
  //     child = Text(
  //       textMessage.content,
  //       style: TextStyle(
  //         fontSize: 15,
  //         color: isSend ? Colors.white : DYColors.text_normal,
  //       ),
  //     );
  //   } else if (messageContent is ImageMessage) {
  //     bgColor = Color(0xffE7E7E7);
  //     ImageMessage imageMessage = messageContent;
  //     child = GestureDetector(
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(isSend ? 16 : 4),
  //           topRight: Radius.circular(isSend ? 4 : 16),
  //           bottomLeft: Radius.circular(16),
  //           bottomRight: Radius.circular(16),
  //         ),
  //         child: DYNetworkImage(
  //           imageUrl: imageMessage.imageUri,
  //           placeholder: CircularProgressIndicator(),
  //         ),
  //       ),
  //       onTap: () {
  //         NavigatorUtils.showPage(
  //           context,
  //           PhotoBrowser(
  //             photoUrls: [imageMessage.imageUri],
  //           ),
  //         );
  //       },
  //     );
  //   }
  //   return Container(
  //     constraints:
  //         BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
  //     padding: EdgeInsets.all(isImage ? 0 : Constant.padding),
  //     child: child,
  //     decoration: BoxDecoration(
  //       color: bgColor,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(isSend ? 16 : 4),
  //         topRight: Radius.circular(isSend ? 4 : 16),
  //         bottomLeft: Radius.circular(16),
  //         bottomRight: Radius.circular(16),
  //       ),
  //     ),
  //   );
  // }
}
