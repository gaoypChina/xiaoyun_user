import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/store_show_entity.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';

class StoreCard extends StatelessWidget {
  final StoreShowEntity storeShowEntity;

  const StoreCard({super.key,required this.storeShowEntity});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
        backgroundColor: this.storeShowEntity.isChecked!
            ? DYColors.primary.withOpacity(0.1)
            : DYColors.normal_bg,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                          this.storeShowEntity.name??'',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black
                          )
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                          this.storeShowEntity.address??'',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey
                          )
                      ),
                    )
                  ],
                )
            ),
            SizedBox(
              width: 12,
            ),
            DYLocalImage(
              imageName: this.storeShowEntity.isChecked!
                  ? "common_check_selected"
                  : "common_check_normal",
              size: 24,
            ),
          ],
        )
    );
  }
}