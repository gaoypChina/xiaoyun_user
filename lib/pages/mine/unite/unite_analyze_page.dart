import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/unite_analyze_entity.dart';
import 'package:xiaoyun_user/network/apis.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/result_data.dart';
import 'package:xiaoyun_user/utils/color_util.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

enum CardItemType {
  ///经营情况
  manager,
  ///走势
  trend,
}

class UniteAnalyzePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UniteAnalyzePageState();
  }
}

class UniteAnalyzePageState extends State<UniteAnalyzePage> {
  late RefreshController _refreshController;

  UniteAnalyzeEntity? _analyzeEntity;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  void _loadData() {
    ToastUtils.showLoading('加载中');
    HttpUtils.get(
        Apis.uniteAnalyzeInfo,
        onSuccess: (ResultData resultData){
          ToastUtils.dismiss();
          _refreshController.refreshCompleted();
          setState(() {
            _analyzeEntity = UniteAnalyzeEntity.fromJson(resultData.data);
          });
        },
        onError: (message){
          ToastUtils.dismiss();
          _refreshController.refreshFailed();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: '经营分析',
      ),
      body: CommonRefresher(
        controller: _refreshController,
        scrollView: _buildListViw(),
        onRefresh: _loadData,
      ),
    );
  }

  Widget _buildListViw() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Constant.padding),
      child: Column(
        children: [
          SizedBox(
              height: 15
          ),
          _buildCardItem('本月经营情况',CardItemType.manager),
          Offstage(
            offstage: !ObjectUtil.isEmptyList(_analyzeEntity?.countTrend),
            child:  Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                _buildCardItem(
                    '订单走势',
                    CardItemType.trend,
                    options: _getLineOption(
                      ['1', '2', '3', '4', '5', '6', '11'],
                        [5, 14, 3, 6, 9, 16, 4]
                    ))
              ],
            ),
          ),
          Offstage(
            offstage: !ObjectUtil.isEmptyList(_analyzeEntity?.monthCountRank),
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                _buildCardItem(
                    '本月客户订单',
                    CardItemType.trend,
                    options: _getBarOption(
                        ['张一鸣','丽丽','王一','三儿','陈大头','周杰伦','赵雷'],
                        [8,15,19,22,31,35,41]
                    )
                ),
              ],
            ),
          ),
          Offstage(
            offstage: !ObjectUtil.isEmptyList(_analyzeEntity?.monthCustomerRank),
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                _buildCardItem(
                    '本月推广客户',
                    CardItemType.trend,
                    options: _getBarOption(
                        ['张一鸣','丽丽','王一','三儿','陈大头','周杰伦','赵雷'],
                        [8,15,19,22,31,35,41]
                    )),
              ],
            ),
          ),
          Offstage(
            offstage: !ObjectUtil.isEmptyList(_analyzeEntity?.customerRank),
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                _buildCardItem(
                    '推广客户总数',
                    CardItemType.trend,
                    options: _getBarOption(
                        ['张一鸣','丽丽','王一','三儿','陈大头','周杰伦','赵雷'],
                        [8,15,19,22,31,35,41]
                    )),
              ],
            ),
          ),
          Offstage(
            offstage: !ObjectUtil.isEmptyList(_analyzeEntity?.monthData),
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                _buildCardItem(''
                    '月度数据',
                    CardItemType.trend,
                    options: _getTwoBarOption(
                        ['1月','2月','3月','4月','5月'],
                        [100,140,230,100,130],
                        [140,100,200,140,100]
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardItem(String itemName,CardItemType type,{String? options}) {
    return CommonCard(
        padding: Constant.horizontalPadding,
        child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 16
                ),
                width: double.infinity,
                child: Text(
                    itemName,
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor('#25292C'),
                        fontWeight: FontWeight.bold
                    )
                ),
              ),
              Divider(
                height: 1,
              ),
              type == CardItemType.manager? _buildManagerWidget():_buildTrendWidget(options??'')
            ]
        )
    );
  }

  Widget _buildManagerWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAnalyzeItem(_analyzeEntity?.monthMoney??'0', '收益金额（元）'),
          _buildAnalyzeItem(_analyzeEntity?.customerCount.toString()??'0', '推广客户（人）'),
          _buildAnalyzeItem(_analyzeEntity?.monthCount.toString()??'0', '订单数'),
        ],
      ),
    );
  }

  Widget _buildAnalyzeItem(String money,String title) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            money,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: HexColor('#25292C'),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: HexColor('#25292C'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTrendWidget(String option) {
    return Container(
      child: Echarts(
        option: option,
        reloadAfterInit: false,
      ),
      width: 300,
      height: 250,
    );
  }

  String _getLineOption(List<String> crossLineData,List<int> mainLineData) {
    return '''
      {
        grid: {
          left: '0%',
          right: '0%',
          bottom: '5%',
          top: '7%',
          height: '85%',
          containLabel: true,
        },
        tooltip:{},
        xAxis: {
          type: 'category',
          data: ${jsonEncode(crossLineData)}
        },
        yAxis: {
          type: 'value'
        },
        series: [{
         data: ${jsonEncode(mainLineData)},
         type: 'line'
        }
        ]}
     ''';
  }

  String _getBarOption(List<String> crossLineData,List<int> mainLineData) {
    return ''' 
                {
                  grid: {
                    left: '0%',
                    right: '0%',
                    bottom: '5%',
                    top: '7%',
                    width: '95%',
                    containLabel: true,
                  },
                  tooltip:{},
                  yAxis: {
                   type: 'category',
                   data: ${jsonEncode(crossLineData)}
                  },
                  xAxis: {
                   type: 'value'
                  },
                  series: [{
                    type: 'bar',
                   data: ${jsonEncode(mainLineData)}
                  }
                  ]
                 }
                ''';
  }

  String _getTwoBarOption(List<String> crossDataList,List<int> mainOneDataList,List<int> mainTwoDataList) {
    return '''{
              grid: {
                left: '0%',
                right: '0%',
                top: '7%',
                bottom: '5%',
                height: '85%',
                containLabel: true,
              },
              tooltip:{},
              xAxis:{
                type:'category',
                data: ${jsonEncode(crossDataList)}
              },
              yAxis:{
                type:'value'
              },
              series: [
                {type: 'bar',data:${jsonEncode(mainOneDataList)}},
                {type: 'bar',data:${jsonEncode(mainTwoDataList)}}F,
              ]
             }''';
  }
}