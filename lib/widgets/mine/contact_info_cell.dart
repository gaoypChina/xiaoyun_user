import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_card.dart';

import '../../models/contact_info_model.dart';

class ContactInfoCell extends StatelessWidget {
  final ContactInfo contactInfo;
  final Function()? onEdit;

  const ContactInfoCell({super.key, required this.contactInfo, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.all(Constant.padding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (this.contactInfo.isDefault)
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 3, vertical: 1),
                        child: Text(
                          "默认",
                          style:
                              TextStyle(fontSize: 10, color: DYColors.primary),
                        ),
                        decoration: BoxDecoration(
                          color: DYColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    Text(
                      this.contactInfo.contactName + "    " + this.contactInfo.contactPhone,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  this.contactInfo.address,
                  style: TextStyle(color: DYColors.text_gray),
                )
              ],
            ),
          ),
          IconButton(
            onPressed: this.onEdit,
            icon: Icon(
              Icons.edit_location_alt_outlined,
              size: 20,
              color: DYColors.text_gray,
            ),
          )
        ],
      ),
    );
  }
}
