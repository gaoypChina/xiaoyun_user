import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/constant.dart';
import '../../models/service_project_model.dart';
import '../../pages/home/service_detail_page.dart';
import '../../utils/navigator_utils.dart';
import '../common/common_card.dart';
import '../common/common_local_image.dart';
import '../common/common_network_image.dart';

class ServiceCard extends StatelessWidget {
  final ServiceProjectModel projectModel;

  const ServiceCard({Key key, @required this.projectModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonCard(
          backgroundColor: this.projectModel.isChecked
              ? DYColors.primary.withOpacity(0.1)
              : DYColors.normal_bg,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: DYNetworkImage(
                        size: 50,
                        imageUrl: this.projectModel.photoImgUrl,
                        placeholder: DYLocalImage(
                          imageName: "common_placeholder_small",
                          size: 50,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            projectModel.title,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  this.projectModel.intro,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: DYColors.text_gray,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: _buildDetailBtn(context),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          _buildPriceWidget(),
                          if (this.projectModel.tag.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Wrap(
                                runSpacing: 5,
                                spacing: 5,
                                children: this
                                    .projectModel
                                    .tag
                                    .split(",")
                                    .toList()
                                    .map((title) => ServiceTag(title: title))
                                    .toList(),
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DYLocalImage(
                imageName: this.projectModel.isChecked
                    ? "common_check_selected"
                    : "common_check_normal",
                size: 24,
              ),
            ],
          ),
        ),
        if (this.projectModel.isHot)
          DYLocalImage(imageName: "home_service_hot", size: 40),
      ],
    );
  }

  Widget _buildPriceWidget() {
    return Row(
      children: [
        Text(
          "￥",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: DYColors.text_red,
          ),
        ),
        Text(
          this.projectModel.priceMoney,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: DYColors.text_red,
          ),
        ),
        Text(
          "起",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: DYColors.text_red,
          ),
        ),
        if (this.projectModel.originalPriceMoney > 0)
          Text(
            "￥${this.projectModel.originalPriceMoney}起",
            style: TextStyle(
              fontSize: 12,
              color: DYColors.text_light_gray,
              decoration: TextDecoration.lineThrough,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            this.projectModel.recommendText,
            style: TextStyle(
              fontSize: 10,
              color: DYColors.primary,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDetailBtn(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 1, 2, 1),
      child: CupertinoButton(
        padding: const EdgeInsets.all(0),
        minSize: 0,
        child: Row(
          children: [
            Text(
              "详情",
              style: TextStyle(
                fontSize: 10,
                color: DYColors.primary,
              ),
            ),
            DYLocalImage(
              imageName: "home_service_arrow",
              size: 12,
            ),
          ],
        ),
        onPressed: () {
          NavigatorUtils.showPage(
            context,
            ServiceDetailPage(content: projectModel.content),
          );
        },
      ),
      decoration: BoxDecoration(
        color: DYColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class ServiceTag extends StatelessWidget {
  final String title;
  const ServiceTag({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          colors: [Color(0xffF5A181), Color(0xffE8684A)],
        ),
      ),
    );
  }
}
