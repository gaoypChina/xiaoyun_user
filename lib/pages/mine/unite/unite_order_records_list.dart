import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
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
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _endTime = DateTime.now();
    _refreshController = RefreshController();
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
                  scrollView: _buildListViewWidget()
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

  Widget _buildTimeBtn(String placeholder,
      {DateTime? dateTime, bool isStart = true,VoidCallback? onTap}) {
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
            Icon(
              Icons.abc,
              size: 8.0,
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
        _buildTypeItemWidget('今日',true,onPress: (){

        }),
        _buildTypeItemWidget('本周',false,onPress: (){

        }),
        _buildTypeItemWidget('本月',false,onPress: (){

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
        itemCount: 10,
        itemBuilder: (context,index){
          return _buildCellItem();
        });
  }

  Widget _buildCellItem({VoidCallback? onPressed}) {
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
                                text: '18.00',
                                style: TextStyle(
                                    fontSize: 21,
                                    color: HexColor('#EB5426')
                                )
                            ),
                          ]
                        ),
                      ),
                      Text(
                          '本单收益',
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
                    _buildDetailItem('订单编号','16934242477781231345'),
                    SizedBox(height: 12),
                    _buildDetailItem('完成时间','2023-08-27 21:11'),
                    SizedBox(height: 12),
                    _buildDetailItem('支付金额','¥98.00'),
                    SizedBox(height: 12),
                    _buildDetailItem('推广人员','徐大虾')
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