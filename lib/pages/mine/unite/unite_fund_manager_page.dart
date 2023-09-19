import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/utils/color_util.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';

class UniteFundManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UniteFundManagerPageState();
  }
}

class UniteFundManagerPageState extends State<UniteFundManagerPage>  {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: DYAppBar(
         titleWidget: Text(
           '资金管理',
           style: TextStyle(
             fontSize: 18,
             color: Colors.white,
           ),
         ),
         leading: NavigationItem(
           iconName: "navigation_back_white",
           onPressed: () {
             Navigator.maybePop(context);
           },
         ),
       backgroundColor: DYColors.primary,
         systemOverlayStyle: SystemUiOverlayStyle.light,
       ),
     body: _buildBodyView(),
   );
  }

  Widget _buildBodyView() {
    return Container(
      color: DYColors.primary,
      child: Column(
        children: [
          _buildHeaderInfoWidget(),
          _buildListWidget()
        ],
      ),
    );
  }

  Widget _buildHeaderInfoWidget() {
    return Container(
      height: 120,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 38,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTypeItem('0.00','当月账户余额（元）'),
          _buildTypeItem('0.00','待入账金额'),
          _buildTypeItem('0.00','已提现金额')
        ],
      ),
    );
  }

  Widget _buildTypeItem(String title,String subTitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white
            )
        ),
        Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: Colors.white
            )
        )
      ],
    );
  }

  Widget _buildListWidget() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 25.0
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                '账户明细',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(child:
            ListView.builder(
                itemCount: 10,
                itemBuilder: (context,index){
                  return _buildItemCell();
                }))
          ],
        ),
      ),
    );
  }

  Widget _buildItemCell() {
    return Container(
      height: 75,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 0.5,
            width: double.infinity,
            color: HexColor('#979797'),
          ),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '提现',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          color: HexColor('#25292C')
                        ),
                      ),
                      Text(
                        '-129.0',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 16,
                          color: HexColor('#EB5426'),
                            fontWeight: FontWeight.bold
                        )
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '2023-08-27 21:11',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 12,
                            color: HexColor('#999999')
                        ),
                      ),
                      Text(
                          '余额0.00',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor('#B2B2B2'),
                              fontWeight: FontWeight.bold
                          )
                      )
                    ],
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}