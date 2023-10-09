import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/unite_group_entity.dart';
import 'package:xiaoyun_user/network/apis.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/result_data.dart';
import 'package:xiaoyun_user/utils/color_util.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class UniteGroupManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UniteGroupManagerPageState();
  }
}

class UniteGroupManagerPageState extends State<UniteGroupManagerPage> {

  UniteGroupEntity? _groupEntity;

  late int _pageNumber;
  late List<UniteGroupList> _dataList;
  late RefreshController _refreshController;
  late TextEditingController _couponController;
  late TextEditingController _searchController;


  @override
  void initState() {
    super.initState();
    _pageNumber = 1;
    _dataList = [];
    _refreshController = RefreshController();
    _couponController = TextEditingController();
    _searchController = TextEditingController();
    _loadData();
  }

  void _onRefresh() {
    _pageNumber = 1;
    _loadData();
  }

  void _onLoadMoreData() {
    _pageNumber++;
    _loadData();
  }

  ///获取团队管理数据
  void _loadData() {
    HttpUtils.get(
        Apis.unitePartnerManger,
        params: {
          'page':_pageNumber,
          'pageSize':'10',
          'real_name':_searchController.text
        },
        onSuccess: (ResultData resultData){
          _refreshController.refreshCompleted();
          if (resultData.data == null) {
            return;
          }
          setState(() {
            _groupEntity = UniteGroupEntity.fromJson(resultData.data);
            if (_pageNumber == 1) {
              _dataList = _groupEntity!.list??[];
            } else {
              _dataList.addAll(_groupEntity!.list as Iterable<UniteGroupList>);
            }
          });
        },
        onError: (message){
          _refreshController.refreshCompleted();
        });
  }

  ///邀请成为团队成员
  void _invitePartner() {
    if (_couponController.text.isEmpty) {
      ToastUtils.showText('手机号码不能为空');
      return;
    }
    HttpUtils.post(Apis.uniteInvitePartner,params: {'mobile':_couponController.text});
  }

  void _showInviteAlert() {
    DialogUtils.showAlertDialog(
      context,
      title: "邀请团队成员",
      autoDismiss: false,
      onDismissCallback: (type) {},
      body: Column(
        children: [
          Text(
            "邀请团队成员",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: DYColors.text_normal,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: SizedBox(
              height: 40,
              child: DYTextField(
                controller: _couponController,
                placeholder: "请输入手机号",
                keyboardType: TextInputType.number,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: DYColors.divider,
              ),
            ),
          ),
        ],
      ),
      cancelAction: () {

      },
      confirmAction: () {
        _invitePartner();
        _couponController.clear();
        NavigatorUtils.goBack(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: '团队管理',
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 15),
            _buildTopInfoWidget(),
            SizedBox(height: 15),
            Expanded(
                child: CommonRefresher(
                  controller: _refreshController,
                  scrollView: ListView.builder(
                      itemCount: _dataList.length,
                      itemBuilder: (context,index){
                        UniteGroupList groupListData = _dataList[index];
                        return _buildItemCell(groupListData);
                      }
                  ),
                  showEmpty: true,
                  onRefresh: _onRefresh,
                  onLoad: _onLoadMoreData,
                )
            ),
            SizedBox(
              height: 43,
            ),
            GestureDetector(
              onTap: (){
                _showInviteAlert();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16
                ),
                child: Container(
                  height: 45,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: HexColor('#489FF7'),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    '邀请',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
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
            '团队成员 ${_groupEntity?.total??0}',
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
                    Expanded(
                        child: DYTextField(
                          controller: _searchController,
                          placeholder: '请输入搜索昵称',
                          color: HexColor('#C9C9C9'),
                          fontSize: 12,
                          onChanged: (String value) {
                            if (value.isEmpty) {
                              _onRefresh();
                            }
                          },
                        )
                    ),
                    GestureDetector(
                      child: Icon(Icons.search,size: 14,),
                      onTap: () {
                        if (_searchController.text.isNotEmpty) {
                          _onRefresh();
                        }
                      },
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }

  Widget _buildItemCell(UniteGroupList groupListData) {
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
                  SizedBox(width: 15),
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                groupListData.realName??'',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: HexColor('#25292C')
                                )
                            ),
                            Text(
                                '加入时间${groupListData.createTime}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: HexColor('#999999')
                                )
                            )
                          ]
                      )
                  ),
                  Text(
                      '推广客户: ${groupListData.customerNum}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: HexColor('#25292C')
                      )
                  ),
                  IconButton(
                      onPressed: (){
                        if (ObjectUtil.isEmptyString(groupListData.mobile)) {
                          return;
                        }
                      },
                      icon: Icon(Icons.phone,size: 14,color: Colors.blue,)
                  )
                ],
              ),
            )
        ),
        SizedBox(height: 10)
      ],
    );
  }
}