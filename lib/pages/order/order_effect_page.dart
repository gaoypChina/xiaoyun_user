import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/photo_browser.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_network_image.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

class OrderEffectPage extends StatefulWidget {
  final int orderId;

  const OrderEffectPage({
    super.key,
    required this.orderId,
  });
  @override
  _OrderEffectPageState createState() => _OrderEffectPageState();
}

class _OrderEffectPageState extends State<OrderEffectPage> {
  List<String> _beforePhotoList = [];
  List<String> _afterPhotoList = [];

  @override
  void initState() {
    super.initState();
    _getWashCarPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(title: "效果图"),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
                left: Constant.padding, top: Constant.padding),
            child: _buildTitleWidget("服务前"),
          ),
        ),
        _buildPhotoGrid(_beforePhotoList),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: Constant.padding),
            child: _buildTitleWidget("服务后"),
          ),
        ),
        _buildPhotoGrid(_afterPhotoList),
      ],
    );
  }

  SliverPadding _buildPhotoGrid(List<String> photoList) {
    return SliverPadding(
      padding: const EdgeInsets.all(Constant.padding),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int position) {
            String photoUrl = photoList[position];
            return GestureDetector(
              child: CommonCard(
                clipChild: true,
                radius: 8,
                child: Hero(
                  tag: photoUrl,
                  child: DYNetworkImage(
                    imageUrl: photoUrl,
                  ),
                ),
              ),
              onTap: () {
                NavigatorUtils.showPage(
                  context,
                  PhotoBrowser(
                    initialIndex: position,
                    photoUrls: photoList,
                  ),
                );
              },
            );
          },
          childCount: photoList.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.6,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
        ),
      ),
    );
  }

  Widget _buildTitleWidget(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: DYColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _getWashCarPhotos() {
    ToastUtils.showLoading("加载中...");
    HttpUtils.get(
      "order/getWashCarPhoto.do",
      params: {"orderId": widget.orderId},
      onSuccess: (resultData) {
        ToastUtils.dismiss();
        setState(() {
          List beforePhotoJsonList = resultData.data["beforePhotoList"] ?? [];
          beforePhotoJsonList.forEach((element) {
            _beforePhotoList.add(element["fullImgUrlBefore"]);
          });
          List afterPhotoJsonList = resultData.data["afterPhotoList"] ?? [];
          afterPhotoJsonList.forEach((element) {
            _afterPhotoList.add(element["fullImgUrlAfter"]);
          });
        });
      },
    );
  }
}
