import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/widgets/common/common_local_image.dart';
import 'package:xiaoyun_user/widgets/common/common_text_field.dart';
import 'package:xiaoyun_user/widgets/others/common_dot.dart';

class AddressSearchField extends StatelessWidget {
  final TextEditingController? cityController;
  final TextEditingController? addressController;
  final FocusNode? cityNode;
  final FocusNode? addressNode;

  final GestureTapCallback? cityOnTap;
  final ValueChanged<String>? cityOnSubmit;
  final ValueChanged<String>? cityOnChanged;

  final GestureTapCallback? addressOnTap;
  final ValueChanged<String>? addressOnSubmitted;

  final bool cityEditing;

  const AddressSearchField({
    super.key,
    this.cityController,
    this.addressController,
    this.cityOnTap,
    this.addressOnTap,
    this.cityOnChanged,
    this.addressOnSubmitted,
    this.cityEditing = false,
    this.cityOnSubmit,
    this.cityNode,
    this.addressNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: Constant.padding),
      width: double.infinity,
      height: 36,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: Constant.padding, right: 8),
            child: CommonDot(color: DYColors.yellowDot),
          ),
          AnimatedContainer(
            width: cityEditing ? 120 : 42,
            height: 36,
            duration: Duration(milliseconds: 300),
            child: DYTextField(
              focusNode: cityNode,
              controller: cityController,
              placeholder: "城市名称或者拼音",
              textInputAction: TextInputAction.search,
              onChanged: this.cityOnChanged,
              onTap: this.cityOnTap,
              onSubmitted: this.cityOnSubmit,
              clearButtonMode: OverlayVisibilityMode.never,
            ),
          ),
          if (!cityEditing)
            DYLocalImage(
              imageName: "home_search_arrow_down",
              size: 24,
            ),
          Container(
            width: 1,
            height: 16,
            margin: const EdgeInsets.only(right: 8),
            color: Colors.white,
          ),
          Expanded(
            child: DYTextField(
              focusNode: addressNode,
              controller: addressController,
              placeholder: "请输入您具体位置",
              textInputAction: TextInputAction.search,
              onTap: this.addressOnTap,
              onSubmitted: this.addressOnSubmitted,
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: DYColors.search_bar,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
