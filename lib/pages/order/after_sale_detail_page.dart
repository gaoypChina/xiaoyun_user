import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/event/order_status_event_bus.dart';
import 'package:xiaoyun_user/models/after_sale_detail_model.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/dialog_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/photo_browser.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/common_network_image.dart';
import 'package:xiaoyun_user/widgets/common/navigation_item.dart';
import 'package:xiaoyun_user/widgets/order/order_action_btn.dart';

class AfterSaleDetailPage extends StatefulWidget {
  final int orderId;

  const AfterSaleDetailPage({super.key, required this.orderId});

  @override
  _AfterSaleDetailPageState createState() => _AfterSaleDetailPageState();
}

class _AfterSaleDetailPageState extends State<AfterSaleDetailPage> {
  AfterSaleDetailModel? _detailModel;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _detailModel == null ? Container() : _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              _buildContent(),
            ],
          ),
        ),
        if (_detailModel != null && _detailModel!.status == 1) _buildToolBar(),
      ],
    );
  }

  Widget _buildToolBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          horizontal: Constant.padding, vertical: 12),
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: SafeArea(
        top: false,
        child: OrderActionBtn(
          title: "撤销申请",
          onPressed: () {
            DialogUtils.showActionSheetDialog(
              context,
              message: "确定要取消该售后申请吗？",
              dialogItems: [
                ActionSheetDialogItem(
                  title: "撤销申请",
                  onPressed: _repealAction,
                  isDestructiveAction: true,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void _repealAction() {
    ToastUtils.showLoading("撤销中...");
    HttpUtils.get(
      "order/cancelPetition.do",
      params: {"orderId": _detailModel!.orderId},
      onSuccess: (resultData) {
        ToastUtils.showSuccess("撤销成功");
        Future.delayed(Duration(seconds: 1)).then((value) {
          OrderStatusEventBus().fire(OrderStateChangedEvent());
          NavigatorUtils.goBackWithParams(context, true);
        });
      },
    );
  }

  SliverPadding _buildContent() {
    return SliverPadding(
      padding: Constant.horizontalPadding,
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            CommonCard(
              padding: Constant.horizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_detailModel!.status == 4)
                    CommonCellWidget(
                      title: "退款金额",
                      subtitle: _detailModel!.refundFeeMoney,
                      subtitleStyle: TextStyle(color: DYColors.text_normal),
                      showArrow: false,
                    ),
                  CommonCellWidget(
                    title: "售后原因",
                    subtitle: _detailModel!.reason,
                    subtitleStyle: TextStyle(color: DYColors.text_normal),
                    showArrow: false,
                  ),
                  if (_detailModel!.comment.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: Constant.padding),
                      child: Text(_detailModel!.comment),
                    ),
                  if (_detailModel!.photoList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: Constant.padding),
                      child: Wrap(
                        runSpacing: 16,
                        spacing: 16,
                        children: List.generate(_detailModel!.photoList.length,
                            (index) {
                          double photoWH = MediaQuery.of(context).size.width -
                              Constant.padding * 6 -
                              50;
                          String imageUrl = _detailModel!.photoList[index];
                          return GestureDetector(
                            child: Hero(
                              tag: imageUrl,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: DYNetworkImage(
                                  imageUrl: _detailModel!.photoList[index],
                                  size: photoWH / 3,
                                ),
                              ),
                            ),
                            onTap: () {
                              NavigatorUtils.showPage(
                                context,
                                PhotoBrowser(
                                  photoUrls: _detailModel!.photoList,
                                  initialIndex: index,
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  SizedBox(height: Constant.padding),
                ],
              ),
            ),
            SizedBox(height: 12),
            CommonCard(
              padding: Constant.horizontalPadding,
              child: Column(
                children: [
                  CommonCellWidget(
                    title: "订单信息",
                    showArrow: false,
                    titleStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CommonCellWidget(
                    title: "订单编号",
                    subtitle: _detailModel!.no,
                    showArrow: false,
                    subtitleStyle: TextStyle(
                      color: DYColors.text_normal,
                    ),
                  ),
                  CommonCellWidget(
                    title: "申请时间",
                    subtitle: _detailModel!.createTime,
                    showArrow: false,
                    hiddenDivider: true,
                    subtitleStyle: TextStyle(
                      color: DYColors.text_normal,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      leading: NavigationItem(
        iconName: "navigation_back_white",
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
      expandedHeight: 164,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.blurBackground],
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xff4ACBFF), DYColors.primary],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: Constant.padding, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _detailModel!.statusTitle,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _detailModel!.statusDesc,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 26,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: DYColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadDetail() {
    ToastUtils.showLoading("加载中...");
    HttpUtils.get("order/custmerOrderDetail.do",
        params: {"orderId": widget.orderId}, onSuccess: (resultData) {
      ToastUtils.dismiss();
      _detailModel = AfterSaleDetailModel.fromJson(resultData.data);
      setState(() {});
    }, onError: (error) {
      Future.delayed(Duration(seconds: 1))
          .then((value) => NavigatorUtils.goBack(context));
    });
  }
}
