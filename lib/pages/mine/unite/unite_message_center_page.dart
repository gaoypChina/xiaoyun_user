import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/utils/color_util.dart';
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
  late RefreshController _refreshController;
  late double _screenWidth;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
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
                    onTap: (){},
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
        itemCount: 10,
        itemBuilder: (context,index){
          return _buildMessageCell('主题','尊敬的用户，恭喜您成为鲸轿合伙人，xxx尊敬的用户，恭喜您成为鲸轿合伙人，xxx尊敬的用户，恭喜您成为鲸轿合伙人，xxx尊敬的用户，恭喜您成为鲸轿合伙人，xxx!!!!!',index%2==0);
        });
  }

  Widget _buildMessageCell(String title, String detailTitle,bool isShowDetail) {
    double minHeight = (sizeHeightText('1', TextStyle(fontSize: 10), 1, _screenWidth-64) + 5) * 2;
    ///文字长度是否超过两行
    bool overFlow = sizeHeightText(detailTitle, TextStyle(fontSize: 10), 9999,  _screenWidth-64) > minHeight;
    double detailTextHeight =  sizeHeightText(detailTitle, TextStyle(fontSize: 10), 2,  _screenWidth-64);
    if (overFlow && isShowDetail) {
      detailTextHeight = sizeHeightText(detailTitle, TextStyle(fontSize: 10), 9999,  _screenWidth-64);
    } else {
      detailTextHeight = minHeight;
    }
    return Column(
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
                          title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14,
                              color: HexColor('#25292C'),
                              fontWeight: FontWeight.bold
                          )
                      ),
                      Text(
                          '2023-8-26 18:39',
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
                    detailTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: overFlow && isShowDetail ? 9999:2,
                    style: TextStyle(
                        fontSize: 10,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Visibility(
                    visible: isShowDetail,
                    child: Divider(height: 1)
                ),
                Visibility(
                  visible: isShowDetail,
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
    );
  }

  double sizeHeightText(String text,TextStyle textStyle,int? maxLines,double maxWidth) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style:  textStyle), maxLines: maxLines, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size.height;
  }
}