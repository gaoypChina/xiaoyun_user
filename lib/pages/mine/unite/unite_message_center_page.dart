import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/unite_message_entity.dart';
import 'package:xiaoyun_user/network/apis.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/result_data.dart';
import 'package:xiaoyun_user/pages/mine/unite/unite_message_detail_page.dart';
import 'package:xiaoyun_user/utils/color_util.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class UniteMessageCenterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UniteMessageCenterPageState();
  }
}

class UniteMessageCenterPageState extends State<UniteMessageCenterPage> {
  late double _screenWidth;
  late int _pageNumber;
  late RefreshController _refreshController;
  late List<UniteMessageList> _dataList;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _dataList = [];
    _pageNumber = 1;
    _loadMessageList();
  }

  ///下拉刷新
  void _onRefresh() {
    _pageNumber = 1;
    _loadMessageList();
  }

  ///上拉加载
  void _loadMoreData() {
    _pageNumber++;
    _loadMessageList();
  }

  ///获取数据
  void _loadMessageList() {
    HttpUtils.get(
        Apis.uniteMessageList,
        params: {'page':_pageNumber,'pageSize':'20'},
        onSuccess: (ResultData resultData) {
          _refreshController.loadComplete();
          if (resultData.data == null) {
            return;
          }
          UniteMessageEntity messageEntity = UniteMessageEntity.fromJson(resultData.data);
          if (!ObjectUtil.isEmptyList(messageEntity.list)) {
            setState(() {
              if (_pageNumber == 1) {
                _dataList = messageEntity.list!;
              } else {
                _dataList.addAll(messageEntity.list!);
              }
            });
          }
        },
      onError: (message) {
          _refreshController.loadComplete();
      }
    );
  }

  ///已读
  void _readMessage(String messageId) {
    Map<String, dynamic> params = messageId.isEmpty?{}:{'id':messageId};
    HttpUtils.post(
        Apis.uniteMessageReader,
        params: params,
        onSuccess: (ResultData resultData){
          for (UniteMessageList model in _dataList) {
            model.isRead = 1;
          }
          setState(() {

          });
        });
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: DYAppBar(
        title: '消息中心',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16
          ),
          child: Column(
            children: [
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '最近消息',
                    style: TextStyle(
                      fontSize: 14,
                      color: HexColor('#666666')
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      _readMessage('');
                    },
                    child: Text(
                      '一键已读',
                      style: TextStyle(
                          fontSize: 14,
                          color: HexColor('#666666')
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                  child: CommonRefresher(
                    scrollView: _buildListView(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoad: _loadMoreData,
                    showEmpty: true,
                  ))
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildListView() {
    return ListView.builder(
        padding: const EdgeInsets.all(Constant.padding),
        itemCount: _dataList.length,
        itemBuilder: (context,index){
          UniteMessageList data = _dataList[index];
          return _buildMessageCell(data);
        });
  }

  Widget _buildMessageCell(UniteMessageList messageData) {
    double minHeight = (sizeHeightText('1', TextStyle(fontSize: 10), 1, _screenWidth-64) + 5) * 2;
    ///文字长度是否超过两行
    bool overFlow = sizeHeightText(messageData.content??'', TextStyle(fontSize: 10), 9999,  _screenWidth-64) > minHeight;
    double detailTextHeight =  sizeHeightText(messageData.content??'', TextStyle(fontSize: 10), 2,  _screenWidth-64);
    if (overFlow) {
      detailTextHeight = sizeHeightText(messageData.content??'', TextStyle(fontSize: 10), 9999,  _screenWidth-64);
    } else {
      detailTextHeight = minHeight;
    }
    return GestureDetector(
      child: Column(
        children: [
          CommonCard(
            padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            messageData.title??'',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14,
                                color: HexColor('#25292C'),
                                fontWeight: FontWeight.bold
                            )
                        ),
                        Text(
                            messageData.createTime??'',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 12,
                                color: HexColor('#999999')
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: double.infinity,
                    height: detailTextHeight,
                    child: Text(
                      messageData.content??'',
                      overflow: TextOverflow.ellipsis,
                      maxLines: overFlow ? 9999:2,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                      visible: overFlow,
                      child: Divider(height: 1)
                  ),
                  Visibility(
                    visible: overFlow,
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '查看详情',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: HexColor('#666666')
                              ),
                            ),
                            DYLocalImage(
                              imageName: "common_right_arrow",
                              size: 24,
                            )
                          ],
                        ),
                      ),
                      onTap: (){

                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
      onTap: () {
        _readMessage(messageData.id.toString());
        if (overFlow) {
          NavigatorUtils.showPage(context, UniteMessageCenterDetailPage(messageId: messageData.id.toString(),));
        }
      },
    );
  }

  double sizeHeightText(String text,TextStyle textStyle,int? maxLines,double maxWidth) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style:  textStyle), maxLines: maxLines, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size.height;
  }
}