import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/order_detail_model.dart';
import 'package:xiaoyun_user/pages/order/order_effect_page.dart';
// import 'package:xiaoyun_user/pages/others/chat_page.dart';
import 'package:xiaoyun_user/utils/common_utils.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/utils/toast_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_cell_widget.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_network_image.dart';

class OrderStaffInfoCard extends StatelessWidget {
  final StaffModel staffModel;
  final String? virtualPhone;
  final bool isFinished;
  final bool isRefundStatus;
  final bool isCanceled;
  final List<String>? beforePhotoList;
  final List<String>? afterPhotoList;
  final int orderId;

  const OrderStaffInfoCard({
    super.key,
    required this.staffModel,
    this.isFinished = false,
    this.beforePhotoList,
    this.afterPhotoList,
    required this.virtualPhone,
    this.isRefundStatus = false,
    this.isCanceled = false,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: Constant.horizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonCellWidget(
            title: "服务人员",
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            subtitle: this.isFinished ? "查看效果" : "",
            showArrow: this.isFinished,
            subtitleStyle: TextStyle(
              fontSize: 12,
              color: DYColors.text_light_gray,
            ),
            onClicked: () {
              if (!this.isFinished) {
                return;
              }
              NavigatorUtils.showPage(
                context,
                OrderEffectPage(
                  orderId: this.orderId,
                ),
              );
            },
          ),
          SizedBox(height: 12),
          Row(
            children: [
              this.staffModel.avatarImgUrl != null &&
                      this.staffModel.avatarImgUrl.isNotEmpty
                  ? ClipOval(
                      child: DYNetworkImage(
                        imageUrl: this.staffModel.avatarImgUrl,
                        size: 48,
                      ),
                    )
                  : DYLocalImage(
                      imageName: "common_staff_header",
                      size: 48,
                    ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          this.staffModel.uname ?? "",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          margin: const EdgeInsets.only(left: 4),
                          child: Text(
                            "No." + this.staffModel.uname,
                            style: TextStyle(
                                fontSize: 10, color: DYColors.primary),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: DYColors.primary.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "服务星级：" + this.staffModel.rating,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
              if (!this.isRefundStatus && !this.isCanceled)
                IconButton(
                  icon: DYLocalImage(
                    imageName: "order_call_icon",
                    size: 36,
                  ),
                  onPressed: () {
                    if (this.virtualPhone == null || this.virtualPhone!.isEmpty) {
                      ToastUtils.showError("获取电话号码失败\n请稍后再试");
                      return;
                    }
                    CommonUtils.launchTelUrl(this.virtualPhone??'');
                  },
                ),
              // IconButton(
              //   icon: DYLocalImage(
              //     imageName: "order_message_icon",
              //     size: 36,
              //   ),
              //   onPressed: () {
              //     NavigatorUtils.showPage(
              //       context,
              //       ChatPage(
              //         targetId: "wash_${this.staffModel.id}",
              //         name: this.staffModel.uname,
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
