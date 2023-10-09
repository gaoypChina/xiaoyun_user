import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/unite_client_entity.dart';
import 'package:xiaoyun_user/network/apis.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/result_data.dart';
import 'package:xiaoyun_user/utils/color_util.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class UniteClientPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UniteClientPageState();
  }
}

class UniteClientPageState extends State<UniteClientPage> {
  late int _pageNumber;
  late bool _canLoadMore;
  late RefreshController _refreshController;
  late TextEditingController _searchController;
  late TextEditingController _couponController;
  late List<UniteClientList> _dataList;
  UniteClientEntity? _clientEntity;

  @override
  void initState() {
    super.initState();
    _pageNumber = 1;
    _dataList = [];
    _canLoadMore = true;
    _refreshController = RefreshController();
    _searchController = TextEditingController();
    _couponController = TextEditingController();
  }

  /// 刷新
  void _onRefresh() {
    _pageNumber = 1;
    _loadData();
  }

  /// 加载更多
  void _loadMoreData() {
    _pageNumber++;
    _loadData();
  }

  /// 加载列表数据
  void _loadData() {
    HttpUtils.post(
        Apis.uniteCustomerList,
        params: {
          'page':_pageNumber,
          'pageSize':'20',
          'nickname':_searchController.text,
        },
        onSuccess: (ResultData resultData) {
          _refreshController.refreshCompleted();
          if (resultData.data == null) {
            return;
          }
          _clientEntity = UniteClientEntity.fromJson(resultData.data);
          setState(() {
            _canLoadMore = !ObjectUtil.isEmptyList(_clientEntity!.list);
            if (_pageNumber == 1) {
              _dataList = _clientEntity!.list??[];
            } else {
              if (ObjectUtil.isNotEmpty(_clientEntity!.list)) {
                _dataList.addAll(_clientEntity!.list!);
              }
            }
          });
        },onError: (message) {
          _refreshController.refreshCompleted();
        });
  }

  /// 修改备注名称
  void _changeRemarkName(int accountId) {
    String remarkName = _couponController.text;
    HttpUtils.post(
        Apis.uniteOrderList,
        params: {
          'account_id':accountId.toString(),
          'remark_name':_couponController.text
        },
        onSuccess: (ResultData resultData){
          for(UniteClientList model in _dataList) {
            if (model.accountId == accountId) {
              setState(() {
                model.remarkName = remarkName;
              });
              break;
            }
          }
        });
  }

  void _showChangeRemarkAlert(int accountId) {
    DialogUtils.showAlertDialog(
      context,
      title: '添加备注',
      autoDismiss: false,
      onDismissCallback: (type) {},
      body: Column(
        children: [
          Text(
            '添加备注',
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
                placeholder: '请输入备注姓名',
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
        _changeRemarkName(accountId);
        _couponController.clear();
        NavigatorUtils.goBack(context);
      },
    );
  }

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
              child: CommonRefresher(
                  showEmpty: true,
                  onLoad: _loadMoreData,
                  onRefresh: _onRefresh,
                  controller: _refreshController,
                  enablePullDown: _canLoadMore,
                  scrollView: ListView.builder(
                    itemCount: _dataList.length,
                    itemBuilder: (context,index){
                      UniteClientList listModel = _dataList[index];
                      return _buildItemCell(listModel);
                    },
                  )
              )
          ),
        ]
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
            '推广客户 ${_clientEntity?.total??0}',
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
                          fontSize: 12,
                          placeholder: '请输入搜索昵称',
                          color: HexColor('#C9C9C9'),
                          controller: _searchController,
                          onChanged: (String value) {
                            if (value.isEmpty) {
                              _onRefresh();
                            }
                          },
                        )),
                    GestureDetector(
                      child: Icon(Icons.search,size: 14),
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

  Widget _buildItemCell(UniteClientList listModel) {
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
                                  ObjectUtil.isEmptyString(listModel.remarkName) ? Text.rich(
                                    TextSpan(
                                        text: listModel.nickname,
                                        children: [
                                          TextSpan(
                                            text: '(${listModel.remarkName})',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: HexColor('#999999')
                                            ),
                                          )
                                        ]),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor('#25292C')
                                    ),
                                  ):Text.rich(
                                    TextSpan(
                                        text: listModel.nickname,
                                        children: [
                                          TextSpan(
                                            text: '(${listModel.remarkName})',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: HexColor('#999999')
                                            ),
                                          )
                                        ]),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor('#25292C')
                                    ),
                                  ),
                                  Text(
                                      '推广时间${listModel.createTime}',
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
                                      '已下单 ${listModel.orderNum}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: HexColor('#25292C')
                                      )
                                  ),
                                  InkWell(
                                    child: Container(
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
                                              color: Colors.white
                                          )
                                      ),
                                    ),
                                    onTap: () {
                                      _showChangeRemarkAlert(listModel.accountId??0);
                                    },
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