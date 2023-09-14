import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/others/report_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import '../../utils/sp_utils.dart';
import '../../models/user_info.dart';
import '../../constant/constant.dart';
import '../../utils/photo_picker_utils.dart';
import '../../widgets/common/common_local_image.dart';
import '../../widgets/common/common_refresher.dart';
import '../../widgets/common/common_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';

class ChatPage extends StatefulWidget {
  final String targetId;
  final String name;

  const ChatPage({super.key, required this.targetId, this.name = "洗车工"});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _inputController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  RefreshController _refreshController = RefreshController();
  FocusNode _focusNode = FocusNode();
  List _messageDataSource = []; //消息数组
  late String _senderPhotoUrl;
  late String _targetPhotoUrl;
  late String _userName;
  bool _chatDisable = true;

  @override
  void initState() {
    super.initState();
    _userName = widget.name;
    _getUserChatStatus();
    _getUserInfo();
    // _onGetHistoryMessages();
    // _onGetMessageNotify();
    // _onSendMessageNotify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: _userName.isEmpty ? "洗车工" : _userName,
        actions: [
          NavigationItem(
            title: "投诉",
            onPressed: () {
              String userId = widget.targetId.split("_").last;
              NavigatorUtils.showPage(context, ReportPage(userId: userId));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CommonRefresher(
              scrollView: _buildListView(),
              controller: _refreshController,
              enablePullDown: false,
              onLoad: _messageDataSource.length < 20
                  ? null
                  : () {
                      // _pullMoreHistoryMessage();
                    },
            ),
          ),
          _buildToolBar()
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      reverse: true,
      controller: _scrollController,
      itemBuilder: (context, index) {
        return Container();
        // Message messageItem = _messageDataSource[index];
        // bool showDate = index == _messageDataSource.length - 1;
        // if (_messageDataSource.length > 1 &&
        //     index < _messageDataSource.length - 1) {
        //   Message nextMessage = _messageDataSource[index + 1];
        //   int millDuration = messageItem.sentTime - nextMessage.sentTime;
        //   showDate = millDuration > 180000;
        // }
        // return ConversationCell(
        //   message: messageItem,
        //   showDate: showDate,
        //   targetPhotoUrl: _targetPhotoUrl,
        //   senderPhotoUrl: _senderPhotoUrl,
        // );
      },
      itemCount: _messageDataSource.length,
    );
  }

  Widget _buildToolBar() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          height: 49,
          padding: const EdgeInsets.symmetric(horizontal: Constant.padding),
          child: _chatDisable
              ? Container(
                  height: 49,
                  alignment: Alignment.center,
                  child: Text(
                    "当前不可聊天",
                    style: TextStyle(
                      color: DYColors.text_gray,
                    ),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: DYTextField(
                        placeholder: "输入消息...",
                        autoFocus: true,
                        focusNode: _focusNode,
                        controller: _inputController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            // _onSendMessage();
                          }
                          _inputController.clear();
                          _focusNode.requestFocus();
                        },
                        onTap: () {
                          _scrollController.animateTo(0,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeIn);
                        },
                      ),
                    ),
                    IconButton(
                      icon: DYLocalImage(
                        imageName: "common_chat_pic",
                        size: 24,
                      ),
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        File? photo = await PhotoPickerUtils.pickPhoto(context);
                        if (photo != null) {
                          // _onSendImageMessage(photo);
                        }
                      },
                    ),
                  ],
                ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                width: 0.5,
                color: Color(0xffCCCCCC),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getUserInfo() {
    XYUserInfo? userInfo = UserInfoDataSource.cachedUserMap[widget.targetId];
    if (userInfo == null) {
      UserInfoDataSource.getUserInfo(widget.targetId).then((user) {
        setState(() {
          _targetPhotoUrl = user.portraitUrl;
          _userName = user.name ?? "洗车工";
        });
      });
    } else {
      setState(() {
        _targetPhotoUrl = userInfo.portraitUrl;
        _userName = userInfo.name ?? "洗车工";
      });
    }

    String senderId = SpUtil.getString(Constant.imUserId);
    XYUserInfo? senderInfo = UserInfoDataSource.cachedUserMap[senderId];
    if (senderInfo == null) {
      UserInfoDataSource.getUserInfo(widget.targetId).then((userInfo) {
        setState(() {
          _senderPhotoUrl = userInfo.portraitUrl;
        });
      });
    } else {
      setState(() {
        _senderPhotoUrl = senderInfo.portraitUrl;
      });
    }
  }

  // void _onGetMessageNotify() {
  //   RongIMClient.onMessageReceived = (Message msg, int left) {
  //     _messageDataSource.insert(0, msg);
  //     setState(() {});
  //     _scrollController.animateTo(0,
  //         duration: Duration(seconds: 1), curve: Curves.easeIn);
  //   };
  // }

  // void _onSendMessageNotify() {
  //   RongIMClient.onMessageSend = (int messageId, int status, int code) async {
  //     String msgInfo =
  //         "send message messageId: $messageId status: $status code: $code";
  //     print(msgInfo);
  //     if (code == 0) {
  //       Message msg = await RongIMClient.getMessage(messageId);
  //       _messageDataSource.insert(0, msg);
  //       setState(() {});
  //       _scrollController.animateTo(0,
  //           duration: Duration(seconds: 1), curve: Curves.easeIn);
  //       ToastUtils.dismiss();
  //     } else if (code == 31004 || code == 30001) {
  //       ToastUtils.showError("当前登录已失效，请退出重试");
  //     } else if (code != -1) {
  //       ToastUtils.showError("发送失败：$code");
  //     }
  //   };
  // }

  // void _pullMoreHistoryMessage() async {
  //   int messageId = -1;
  //   Message tempMessage = _messageDataSource.last;
  //   if (tempMessage != null && tempMessage.messageId > 0) {
  //     messageId = tempMessage.messageId;
  //   }
  //   _onGetHistoryMessages(messageId);
  // }

  // //获取历史消息
  // void _onGetHistoryMessages([int messageId = -1]) async {
  //   List msgs = await RongIMClient.getHistoryMessage(
  //       RCConversationType.Private, widget.targetId, messageId, 20);
  //   print("get history message");

  //   if (msgs != null && msgs.isNotEmpty) {
  //     msgs.sort((a, b) => b.sentTime.compareTo(a.sentTime));
  //     _messageDataSource += msgs;
  //     if (msgs.length < 20) {
  //       Message tempMessage = _messageDataSource.last;
  //       _onLoadRemoteHistoryMessages(tempMessage.sentTime);
  //     }
  //     _refreshController.loadComplete();
  //   } else if (messageId != -1) {
  //     _refreshController.loadNoData();
  //   }
  //   setState(() {});
  // }

  // //获取服务器消息
  // void _onLoadRemoteHistoryMessages(int recordTime) {
  //   RongIMClient.getRemoteHistoryMessages(
  //       RCConversationType.Private, widget.targetId, recordTime, 20,
  //       (msgList, code) {
  //     if (code == 0) {
  //       if (code == 0 && msgList != null) {
  //         msgList.sort((a, b) => b.sentTime.compareTo(a.sentTime));
  //         _messageDataSource += msgList;
  //         if (msgList.isNotEmpty) {
  //           setState(() {});
  //         }
  //       }
  //     }
  //   });
  // }

  // void _onSendMessage() async {
  //   TextMessage txtMessage = TextMessage();
  //   txtMessage.content = _inputController.text;
  //   await RongIMClient.sendMessage(
  //       RCConversationType.Private, widget.targetId, txtMessage);
  // }

  // void _onSendImageMessage(File photo) async {
  //   ImageMessage imgMessage = ImageMessage();
  //   imgMessage.localPath = photo.path;
  //   ToastUtils.showLoading("发送中...");
  //   await RongIMClient.sendMessage(
  //       RCConversationType.Private, widget.targetId, imgMessage);
  // }

  void _getUserChatStatus() {
    String targetId = widget.targetId.split("_").last;
    HttpUtils.get(
      "/user/getUserChatStatus.do",
      params: {"washerId": targetId},
      onSuccess: (resultData) {
        setState(() {
          _chatDisable = !resultData.data;
        });
      },
    );
  }
}
