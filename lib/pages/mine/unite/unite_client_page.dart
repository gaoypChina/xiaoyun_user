import 'package:flutter/material.dart';
import 'package:xiaoyun_user/utils/color_util.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class UniteClientPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UniteClientPageState();
  }
}

class UniteClientPageState extends State<UniteClientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DYAppBar(
          title: '我的客户',
        ),
      body: Column(
        children: [
          SizedBox(height: 15),
          _buildTopInfoWidget(),
          SizedBox(height: 15),
          Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context,index){
                    return _buildItemCell();
                  }
              )
          ),
        ],
      ),
    );
  }

  Widget _buildTopInfoWidget() {
    return Padding(
      padding: EdgeInsets.only(
          left: 25,
          right: 19
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '推广客户 99',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 16,
                color: HexColor('#25292C'),
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
              child: Container(
                height: 30,
                padding: EdgeInsets.symmetric(
                    horizontal: 11
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13)
                ),
                child: Row(
                  children: [
                    Expanded(child: DYTextField(
                      placeholder: '请输入搜索昵称',
                      fontSize: 12,
                      color: HexColor('#C9C9C9'),
                    )),
                    Icon(Icons.search,size: 14,)
                  ],
                ),
              )
          )
        ],
      ),
    );
  }

  Widget _buildItemCell() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16
            ),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 16
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22.5,
                    backgroundColor: HexColor('#D8D8D8'),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '爱丽丝',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: HexColor('#25292C')
                                      )
                                  ),
                                  Text(
                                      '推广时间2023-09-04',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: HexColor('#999999')
                                      )
                                  )
                                ]
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '已下单 1',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: HexColor('#25292C')
                                      )
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16
                                    ),
                                    height: 17,
                                    decoration: BoxDecoration(
                                      color: HexColor('#BEC3C4'),
                                      borderRadius: BorderRadius.circular(3)
                                    ),
                                    child: Text(
                                        '备注',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor('#999999')
                                        )
                                    ),
                                  )
                                ]
                            )
                          ],
                        ),
                      )
                  ),
                ],
              ),
            )
        ),
        SizedBox(height: 10)
      ],
    );
  }
}