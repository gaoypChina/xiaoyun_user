import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/unite_order_list_entity.dart';
import 'package:xiaoyun_user/network/apis.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/result_data.dart';
import 'package:xiaoyun_user/utils/color_util.dart';
import 'package:xiaoyun_user/utils/date_picker_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class UniteOrderRecordsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UniteOrderRecordsListPageState();
  }
}

class UniteOrderRecordsListPageState extends State<UniteOrderRecordsListPage> with SingleTickerProviderStateMixin {
  late DateTime _startTime;
  late DateTime _endTime;
  late int _page;
  late int _dateType;
  late RefreshController _refreshController;

  List<UniteOrderListList>? _dataList;

  @override
  void initState() {
    super.initState();
    _page = 1;
    _dateType = 1;
    _dataList = [];
    _startTime = DateTime.now();
    _endTime = DateTime.now();
    _refreshController = RefreshController();
    _onRefresh();
  }

  void _onRefresh() async {
    _page = 1;
    _loadData();
  }

  void _onLoadData() async {
    _page++;
    _loadData();
  }

  void _loadData() {
    Map _params = {};
    if (_dateType == - 1) {
      _params = {
        'page':_page,
        'pageSize':'10',
        'starTime':formatDate(_startTime, [yyyy, '-', mm, '-', dd]),
        'endTime':formatDate(_endTime, [yyyy, '-', mm, '-', dd])
      };
    } else {
      _params = {
        'page':_page,
        'pageSize':'10',
        'dataType':_dateType,
        'starTime':'',
        'endTime':''
      };
    }
    HttpUtils.post(
        Apis.uniteOrderList,
        params: _params as Map<String,dynamic>,
        onSuccess: (ResultData resultData){
          _refreshController.refreshCompleted();
          UniteOrderListEntity uniteOrderListEntity = UniteOrderListEntity.fromJson(resultData.data);
          if (ObjectUtil.isEmptyList(uniteOrderListEntity.list)) {
            if (_page == 1) {
              setState(() {
                _dataList = uniteOrderListEntity.list;
              });
            } else {
              setState(() {
                _dataList?.addAll(uniteOrderListEntity.list  as Iterable<UniteOrderListList>);
              });
            }
          }},
        onError: (message){
          _refreshController.refreshCompleted();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: '订单记录',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16
        ),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            _buildTimeSelectWidget(),
            SizedBox(
              height: 25.0,
            ),
            _buildSelectItemWidget(),
            SizedBox(
              height: 13.0,
            ),
            Expanded(
              child: CommonRefresher(
                controller: _refreshController,
                scrollView: _buildListViewWidget(),
                showEmpty: true,
                onRefresh: _onRefresh,
                onLoad: _onLoadData,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelectWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          '完成时间',
          style: TextStyle(
              fontSize: 14,
              color: HexColor('0x333333')
          ),
        ),
        _buildTimeBtn('开始时间', dateTime: _startTime, isStart: true,onTap: (){
          _showDatePicker(_startTime,true);
        }),
        Container(
            height: 0.5,
            width: 10.0,
            color: HexColor('333333'),
            padding: EdgeInsets.symmetric(horizontal: 15.0)
        ),
        _buildTimeBtn('结束时间', dateTime: _endTime, isStart: false,onTap: (){
          _showDatePicker(_startTime,false);
        }),
        Icon(
            Icons.search,
            size: 18.0
        )
      ],
    );
  }

  Widget _buildTimeBtn(String placeholder, {DateTime? dateTime, bool isStart = true,VoidCallback? onTap}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color:DYColors.background,
          border: Border.all(
            width: 1.0,
            color: HexColor('#C2C2C2'),
          ),
        ),
        padding: EdgeInsets.only(
            top: 5,
          left: 10,
          right: 3,
          bottom: 5
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              dateTime != null ? formatDate(dateTime, [yyyy, '-', mm, '-', dd]) : placeholder,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                color: dateTime != null
                    ? DYColors.text_normal
                    : DYColors.text_light_gray,
              ),
            ),
            SizedBox(width: 3),
            GestureDetector(
              child: Icon(
                Icons.search,
                size: 8.0,
              ),
              onTap: (){
                _dateType = -1;
                _onRefresh();
              },
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSelectItemWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTypeItemWidget('今日',_dateType == 1,onPress: (){
          if (_dateType != 1) {
            setState(() {
              _dateType = 1;
            });
          }
          _onRefresh();
        }),
        _buildTypeItemWidget('本周',_dateType == 2,onPress: (){
          if (_dateType != 2) {
            setState(() {
              _dateType = 2;
            });
          }
          _onRefresh();
        }),
        _buildTypeItemWidget('本月',_dateType == 3,onPress: (){
          if (_dateType != 3) {
            setState(() {
              _dateType = 3;
            });
          }
          _onRefresh();
        }),
      ],
    );
  }

  Widget _buildTypeItemWidget(String title,bool isSelect,{VoidCallback? onPress}) {
    return GestureDetector(
      child: Container(
        height: 36,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 36
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: isSelect?1.0:0.0,
              color: isSelect?HexColor('#489FF7'):Colors.white,
            ),
            borderRadius: BorderRadius.circular(18.0)
        ),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              color: isSelect?HexColor('#489FF7'):Colors.black
          ),
        ),
      ),
      onTap: onPress,
    );
  }

  Widget _buildListViewWidget() {
    return ListView.builder(
        itemCount: _dataList?.length,
        itemBuilder: (context,index){
          UniteOrderListList listModel = _dataList![index];
          return _buildCellItem(listModel);
        });
  }

  Widget _buildCellItem(UniteOrderListList listModel,{VoidCallback? onPressed}) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0)
            ),
            padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 11
            ),
            child: Stack(
              children: [
                Positioned(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: '¥',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: HexColor('#EB5426')
                                )
                            ),
                            TextSpan(
                                text: listModel.incomeMoney??'0',
                                style: TextStyle(
                                    fontSize: 21,
                                    color: HexColor('#EB5426')
                                )
                            ),
                          ]
                        ),
                      ),
                      Text(
                          listModel.orderStatus==0?'本单收益':'退款',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor('#999999')
                          )
                      )
                    ],
                  ),
                  bottom: 0,
                  right: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem('订单编号',listModel.orderNo.toString()),
                    SizedBox(height: 12),
                    _buildDetailItem('完成时间',listModel.completeTime??''),
                    SizedBox(height: 12),
                    _buildDetailItem('支付金额',ObjectUtil.isEmptyString(listModel.payMoney)?'' : '¥${listModel.payMoney}'),
                    SizedBox(height: 12),
                    _buildDetailItem('推广人员',listModel.partnerName??'')
                  ],
                )
              ],
            ),
          ),
          onTap: onPressed,
        ),
        SizedBox(height: 10)
      ],
    );
  }

  Widget _buildDetailItem(String title,String detailTitle) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
          children: [
            TextSpan(
                text: title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: HexColor('#25292C')
                )
            ),
            TextSpan(
              text: ' ',
            ),
            TextSpan(
                text: detailTitle,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: HexColor('#666666')
                )
            )
          ]
      ),
    );
  }

  void _showDatePicker(DateTime dataTime,bool isStar) {

    DatePickerUtils.showDatePicker(
      context,
      initialDateTime: dataTime,
      onConfirm: (time) {
       setState(() {
         if (isStar) {
           _startTime = time;
         } else {
           _endTime = time;
         }
       });
      },
    );
  }
}