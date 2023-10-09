import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/network/apis.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/result_data.dart';
import 'package:xiaoyun_user/utils/bottom_sheet_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

enum ShareType { wechat, timeline }

class UniteSharePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UniteSharePageState();
  }
}

class UniteSharePageState extends State<UniteSharePage> {

  /// 加载海报数据
  void _loadShareData() {
    HttpUtils.get(
        Apis.uniteSharePoster,
        onSuccess: (ResultData resultData){
          if(!ObjectUtil.isEmptyString(resultData.data['poster'])) {
            setState(() {
              _imageUrl = resultData.data['poster'];
            });
          }
        });
  }

  /// 保存网络图片到相册
  void _saveNetworkImage() async {
    var response = await Dio().get(
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fci.xiaohongshu.com%2Ff4fe7940-b4d3-a389-bfa0-56ef359cb9d5%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fci.xiaohongshu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1699422758&t=cdc69849f20aa606870b7a43b6e4cf37",
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello");
    if (result['isSuccess']) {
      ToastUtils.showText('保存成功');
    } else {
      ToastUtils.showText('保存失败');
    }
  }

  /// 分享到微信
  void _weChatShare(WeChatScene scene, String link, String title, String description) async {
    if (!(await Fluwx().isWeChatInstalled)) {
      ToastUtils.showInfo("您未安装微信");
      return;
    }
    bool result = await Fluwx().share(
        WeChatShareImageModel(
            WeChatImage.network('https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fci.xiaohongshu.com%2Ff4fe7940-b4d3-a389-bfa0-56ef359cb9d5%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fci.xiaohongshu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1699422758&t=cdc69849f20aa606870b7a43b6e4cf37'),
            scene: scene,
            title: title,
            description: description
        )
    );
    if (result) {
      ToastUtils.showSuccess("分享成功");
    } else {
      ToastUtils.showError("分享失败");
    }
  }

  /// 显示分享组件
  void _showShareDialog() {
    BottomSheetUtil.show(
      context,
      height: 150,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "分享到",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShareItem(ShareType.wechat),
                  _buildShareItem(ShareType.timeline),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareItem(ShareType type) {
    String iconName;
    String title;
    if (type == ShareType.wechat) {
      iconName = "common_share_wechat";
      title = "微信";
    } else if (type == ShareType.timeline) {
      iconName = "common_share_timeline";
      title = "朋友圈";
    } else {
      iconName = "common_share_copy";
      title = "复制链接";
    }
    return GestureDetector(
      child: Column(
        children: [
          DYLocalImage(imageName: iconName, size: 50),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(title),
          ),
        ],
      ),
      onTap: () {
        NavigatorUtils.goBack(context);
        String link = Constant.host + "share/index.html";
        String title = "鲸轿洗车";
        String description = "让洗车更方便，赶快加入我们吧~";
        switch (type) {
          case ShareType.wechat:
            _weChatShare(WeChatScene.session, link, title, description);
            break;
          case ShareType.timeline:
            _weChatShare(WeChatScene.timeline, link, title, description);
            break;
          default:
        }
      },
    );
  }

  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = '';
    // _loadShareData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: DYAppBar(
          backImage:'assets/images/navigation/navigation_back_white.png',
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
        ),
      body: Container(
        color: Color.fromRGBO(0, 0, 0, 0.3),
        padding: EdgeInsets.symmetric(
          horizontal: 21
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Image.network(
              'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fci.xiaohongshu.com%2Ff4fe7940-b4d3-a389-bfa0-56ef359cb9d5%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fci.xiaohongshu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1699422758&t=cdc69849f20aa606870b7a43b6e4cf37',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: 36,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 55,
                        width: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(27.5),
                          ),
                        ),
                        child: DYLocalImage(
                          imageName: 'common_share',
                          height: 36,
                          width: 36,
                          fit: BoxFit.fill,
                        ),
                      ),
                      onTap: (){
                        _showShareDialog();
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('分享',style: TextStyle(color: Colors.white,fontSize: 14))
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 55,
                        width: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(27.5),
                          ),
                        ),
                        child: DYLocalImage(
                          imageName: 'common_download',
                          height: 36,
                          width: 36,
                          fit: BoxFit.fill,
                        ),
                      ),
                      onTap: () {
                        _saveNetworkImage();
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('下载',style: TextStyle(color: Colors.white,fontSize: 14))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}