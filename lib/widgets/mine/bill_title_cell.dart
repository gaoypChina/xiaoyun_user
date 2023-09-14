import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class BillTitleCell extends StatelessWidget {
  final Function? onDeleteAction;
  final String title;
  final bool isDefault;

  const BillTitleCell(
      {super.key, this.onDeleteAction, this.title = '', this.isDefault = false});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            label: "删除",
            backgroundColor: DYColors.text_red,
            borderRadius: BorderRadius.circular(16),
            onPressed: (context) {
              this.onDeleteAction?.call();
            },
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Constant.padding),
        child: Row(
          children: [
            Flexible(
              child: Text(
                this.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (this.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.only(left: 8),
                child: Text(
                  "默认",
                  style: TextStyle(fontSize: 10, color: DYColors.primary),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: DYColors.primary, width: 0.5),
                ),
              )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
