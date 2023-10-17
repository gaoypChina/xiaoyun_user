import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/unite_base_info_entity.dart';
import 'package:xiaoyun_user/models/user_model_entity.dart';
import 'package:xiaoyun_user/network/apis.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/mine/unite/unite_accoun_setting_page.dart';
import 'package:xiaoyun_user/pages/mine/unite/unite_analyze_page.dart';
import 'package:xiaoyun_user/pages/mine/unite/unite_client_page.dart';
import 'package:xiaoyun_user/pages/mine/unite/unite_fund_manager_page.dart';
import 'package:xiaoyun_user/pages/mine/unite/unite_group_page.dart';
import 'package:xiaoyun_user/pages/mine/unite/unite_message_center_page.dart';
import 'package:xiaoyun_user/pages/mine/unite/unite_order_records_list.dart';
import 'package:xiaoyun_user/pages/mine/unite/unite_share_page.dart';
import 'package:xiaoyun_user/utils/color_util.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_network_image.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';

class UniteCenterPage extends StatefulWidget {

  final UserModelEntity userModelEntity;

  const UniteCenterPage({super.key, required this.userModelEntity});

  @override
  State<StatefulWidget> createState() {
    return UniteCenterPageState();
  }
}

class UniteCenterPageState extends State<UniteCenterPage> {
  late RefreshController _refreshController;
  UniteBaseInfoEntity? _baseInfoEntity;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    // _loadCenterData();
  }


  void _loadCenterData() {
    ToastUtils.showLoading('加载中');
    HttpUtils.get(Apis.uniteBaseInfo,onSuccess: (resultData){
      ToastUtils.dismiss();
      _refreshController.refreshCompleted();
      setState(() {
        _baseInfoEntity = UniteBaseInfoEntity.fromJson(resultData.data);
      });
    },onError: (String msg) {
      ToastUtils.dismiss();
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        titleWidget: Text(
          '合作中心',
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
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      extendBodyBehindAppBar: true,
      body: CommonRefresher(
        controller: _refreshController,
        scrollView: _buildListView(),
        onRefresh: _loadCenterData,
      ),
    );
  }

  ListView _buildListView(){
    return ListView(
      children: [
        _buildHeaderWidget(),
        SizedBox(
          height: 10,
        ),
        _buildActionWidget()
      ],
    );
  }

  Widget _buildHeaderWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: Constant.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + kToolbarHeight,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 12),
            child: Row(
              children: [
                _buildUserHeader(),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _baseInfoEntity?.realName??'未设置',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // SizedBox(
                          //   width: 15,
                          // ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 11
                          //   ),
                          //   child: Text(
                          //     'VIP',
                          //     style: TextStyle(
                          //       fontSize: 12.0,
                          //       color: HexColor('#44B9FD'),
                          //     ),
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(15.0)
                          //   ),
                          // )
                        ],
                      ),
                      Offstage(
                        offstage: ObjectUtil.isEmpty(_baseInfoEntity?.levelName),
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            _baseInfoEntity?.levelName??'',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBalanceAndCouponCard(),
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/mine/mine_home_bg.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    Widget userDefault = DYLocalImage(
      imageName: "common_user_header",
      size: 60,
    );
    if (ObjectUtil.isNotEmpty(_baseInfoEntity?.avatar)) {
      return ClipOval(
        child: DYNetworkImage(
          imageUrl: _baseInfoEntity!.avatar!,
          placeholder: userDefault,
          size: 60,
        ),
      );
    }
    return userDefault;
  }

  Widget _buildBalanceAndCouponCard() {
    return Stack(
      children: [
        DYLocalImage(
          imageName: "mine_home_middle_bg",
          height: 94,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Container(
          height: 94,
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: _buildHeaderBtn(
                  title: '当月流水',
                  value: _baseInfoEntity?.monthMoney??'0.0',
                  icon: "mine_home_balance",
                  onPressed: () {},
                ),
              ),
              Container(width: 1, height: 30, color: HexColor('#FFFFFF'),),
              Expanded(
                child: _buildHeaderBtn(
                  title: '当月订单',
                  value: _baseInfoEntity?.monthCount.toString()??'0',
                  icon: "mine_home_coupon",
                  onPressed: () {},
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildHeaderBtn({String? title, String? value, String? icon, GestureTapCallback? onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value??'',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: HexColor('#FFFFFF'),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                title??'',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: HexColor('#FFFFFF'),
                ),
              )
            ],
          ),
        ),
        onTap: onPressed,
      ),
    );
  }

  Widget _buildActionWidget() {
    return Container(
      decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0)
        ),
      margin: EdgeInsets.symmetric(
        horizontal: 12.0
      ),
      padding: EdgeInsets.symmetric(
        vertical: 35.0,
        horizontal: 25.0
      ),
      child: Column (
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildActionItemWidget('mine_unite_records','订单记录',onPressed: (){
                NavigatorUtils.showPage(context, UniteOrderRecordsListPage());
              }),
              _buildActionItemWidget('mine_unite_fund','资金管理',onPressed: () {
                NavigatorUtils.showPage(context, UniteFundManagerPage());
              }),
              _buildActionItemWidget('mine_unite_manage','经营分析',onPressed: (){
                NavigatorUtils.showPage(context, UniteAnalyzePage());
              })
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Offstage(
                offstage: false,
                child: _buildActionItemWidget('mine_unite_group','团队管理',onPressed: () {
                  NavigatorUtils.showPage(context, UniteGroupManagerPage());
                }),
              ),
              _buildActionItemWidget((_baseInfoEntity?.messagePoint == null || _baseInfoEntity?.messagePoint! == 1)?'mine_unite_message_no':'mine_unite_message','消息中心',onPressed: (){
                NavigatorUtils.showPage(context, UniteMessageCenterPage());
              }),
              _buildActionItemWidget('mine_unite_share','推荐分享',onPressed: (){
                NavigatorUtils.showPage(context, UniteSharePage());
              }),
              Offstage(
                offstage: true,
                child: _buildActionItemWidget('mine_unite_client','我的客户',onPressed: () {
                  NavigatorUtils.showPage(context, UniteClientPage());
                }),
              )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Offstage(
                offstage: false,
                child: _buildActionItemWidget('mine_unite_client','我的客户',onPressed: () {
                  NavigatorUtils.showPage(context, UniteClientPage());
                }),
              ),
              _buildActionItemWidget('mine_unite_equity','我的权益',onPressed: (){
                NavigatorUtils.goWebViewPage(context, '我的权益', 'https://www.baidu.com');
              }),
              _buildActionItemWidget('mine_unite_set','账号设置',onPressed: (){
                NavigatorUtils.showPage(context, UniteAccountSettingPage(isChangeInfo:true));
              })
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionItemWidget(String icon, String title, {GestureTapCallback? onPressed}) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        width: (MediaQuery.of(context).size.width-75)/3,
        child: Column(
          children: [
            DYLocalImage(
              imageName: icon,
              height: 50,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: HexColor('#25292C')
              ),
            )
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}