import 'package:flutter/material.dart';
import 'package:xiaoyun_user/models/store_show_entity.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/home/store_card.dart';

class StoreSelectionWidget extends StatefulWidget {
  final List<StoreShowEntity> storeList;
  final Function(List<StoreShowEntity> selectedStoreList)? onConfirmed;
  const StoreSelectionWidget({super.key, required this.storeList,this.onConfirmed});

  @override
  State<StatefulWidget> createState() {
    return StoreSelectionWidgetState();
  }
}

class StoreSelectionWidgetState extends State<StoreSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Text(
              "门店选择",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                StoreShowEntity storyEntity = widget.storeList[index];
                return GestureDetector(
                  child: StoreCard(
                    storeShowEntity: storyEntity,
                  ),
                  onTap: () {
                    widget.storeList.forEach((element) {
                      element.isChecked = false;
                    });
                    storyEntity.isChecked = !storyEntity.isChecked!;
                    setState(() {});
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: widget.storeList.length,
            ),
          ),
          SizedBox(height: 20),
          CommonActionButton(
            title: "确定",
            onPressed: () {
              List<StoreShowEntity> selectedList = [];
              widget.storeList.forEach((project) {
                if (project.isChecked!) {
                  selectedList.add(project);
                }
              });
              widget.onConfirmed?.call(selectedList);
              NavigatorUtils.goBack(context);
            },
          )
        ],
      ),
    );
  }
}