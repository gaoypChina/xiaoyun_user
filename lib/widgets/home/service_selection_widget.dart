import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/models/service_project_model.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/home/service_card.dart';

class ServiceSelectionWidget extends StatefulWidget {
  final List<ServiceProjectModel> projectList;
  final Function(List<ServiceProjectModel> selectedProjectList) onConfirmed;

  const ServiceSelectionWidget(
      {Key key, @required this.projectList, this.onConfirmed})
      : super(key: key);
  @override
  _ServiceSelectionWidgetState createState() => _ServiceSelectionWidgetState();
}

class _ServiceSelectionWidgetState extends State<ServiceSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Text(
              "服务选择",
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
                ServiceProjectModel projectModel = widget.projectList[index];
                return GestureDetector(
                  child: ServiceCard(
                    projectModel: projectModel,
                  ),
                  onTap: () {
                    projectModel.isChecked = !projectModel.isChecked;
                    setState(() {});
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: widget.projectList.length,
            ),
          ),
          SizedBox(height: 20),
          CommonActionButton(
            title: "确定",
            onPressed: () {
              List<ServiceProjectModel> selectedList = [];
              widget.projectList.forEach((project) {
                if (project.isChecked) {
                  selectedList.add(project);
                }
              });
              if (widget.onConfirmed != null) {
                widget.onConfirmed(selectedList);
              }
              NavigatorUtils.goBack(context);
            },
          )
        ],
      ),
    );
  }
}
