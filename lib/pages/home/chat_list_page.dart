import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List _conversationList = [];

  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    // _onGetConversationList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "聊天列表",
      ),
      body: _buildListView(),
      // body: CommonRefresher(
      //   showEmpty: _conversationList.isEmpty,
      //   emptyTips: "暂无聊天数据",
      //   onRefresh: _onGetConversationList,
      //   controller: _refreshController,
      //   scrollView: _buildListView(),
      // ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: _conversationList.length,
      itemBuilder: (context, index) {
        return Container();
        // Conversation con = _conversationList[index];
        // return GestureDetector(
        //   child: ChatListCell(conversation: con),
        //   onTap: () {
        //     NavigatorUtils.showPage(
        //       context,
        //       ChatPage(targetId: con.targetId),
        //     ).then(
        //       (value) => _onGetConversationList(),
        //     );
        //   },
        // );
      },
      separatorBuilder: (context, index) => Divider(height: 0.5),
    );
  }

  // void _onGetConversationList() async {
  //   List conList =
  //       await RongIMClient.getConversationList([RCConversationType.Private]);
  //   _refreshController.refreshCompleted();
  //   setState(() {
  //     _conversationList = conList;
  //   });
  // }
}
