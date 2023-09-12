import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/pages/mine/contact_add_page.dart';
import 'package:xiaoyun_user/utils/navigator_utils.dart';
import 'package:xiaoyun_user/widgets/common/common_action_button.dart';
import 'package:xiaoyun_user/widgets/common/common_refresher.dart';
import 'package:xiaoyun_user/widgets/common/custom_app_bar.dart';

import '../../models/contact_info_model.dart';
import '../../widgets/mine/contact_info_cell.dart';

class ContactInfoPage extends StatefulWidget {
  final bool isSelectMode;
  const ContactInfoPage({Key key, this.isSelectMode = false}) : super(key: key);

  @override
  State<ContactInfoPage> createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  List<ContactInfo> _contactInfos = [];
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    _getAddressList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DYAppBar(
        title: "常用联系信息",
      ),
      body: Column(
        children: [
          Expanded(
            child: CommonRefresher(
              showEmpty: _contactInfos.isEmpty,
              controller: _refreshController,
              scrollView: _buildListView(),
              onRefresh: () {
                _getAddressList();
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonActionButton(
                title: "添加联系信息",
                onPressed: () {
                  NavigatorUtils.showPage(context, ContactAddPage())
                      .then((value) {
                    if (value != null && value) {
                      _getAddressList();
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(Constant.padding),
      itemBuilder: (context, index) {
        ContactInfo info = _contactInfos[index];
        return GestureDetector(
          child: ContactInfoCell(
            contactInfo: info,
            onEdit: () {
              NavigatorUtils.showPage(
                  context,
                  ContactAddPage(
                    contactInfo: info,
                  )).then((value) {
                if (value != null && value) {
                  _getAddressList();
                }
              });
            },
          ),
          onTap: () {
            if (widget.isSelectMode) {
              NavigatorUtils.goBackWithParams(context, info);
            }
          },
        );
      },
      separatorBuilder: ((context, index) {
        return SizedBox(height: 10);
      }),
      itemCount: _contactInfos.length,
    );
  }

  void _getAddressList() {
    HttpUtils.get(
      "address/getAddressList.do",
      onSuccess: (resultData) {
        _refreshController.refreshCompleted();
        List list = resultData.data;
        setState(() {
          _contactInfos = list.map((e) => ContactInfo.fromJson(e)).toList();
        });
      },
      onError: (msg) {
        _refreshController.refreshCompleted();
      },
    );
  }
}
