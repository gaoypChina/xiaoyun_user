import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:xiaoyun_user/constant/constant.dart';
import 'package:xiaoyun_user/models/city_model.dart';
import 'package:xiaoyun_user/widgets/common/common_empty_widget.dart';
import 'package:xiaoyun_user/widgets/others/group_list_index_widget.dart';

class CityContentPage extends StatelessWidget {
  final List<CityModel> cityList;
  final String locationCity;
  final Function(CityModel city) onSelected;
  final String searchKeywords;

  const CityContentPage(
      {Key key,
      this.cityList,
      this.locationCity,
      this.onSelected,
      this.searchKeywords})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CityModel> resultCityList = [];
    if (searchKeywords.isNotEmpty) {
      this.cityList.forEach((city) {
        if (city.name.contains(searchKeywords) ||
            city.pinyin.contains(searchKeywords.toLowerCase())) {
          resultCityList.add(city);
        }
      });
    }
    return this.searchKeywords.isNotEmpty
        ? Container(
            child: resultCityList.isEmpty
                ? Container(
                    child: Center(
                        child: CommonEmptyWidget(
                      emptyTips: "暂无结果，换个词试试吧",
                    )),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      CityModel model = resultCityList[index];
                      return GestureDetector(
                        child: Container(
                          child: Text(model.name),
                          padding: const EdgeInsets.all(Constant.padding),
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        onTap: () {
                          if (this.onSelected != null) {
                            this.onSelected(model);
                          }
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemCount: resultCityList.length,
                  ),
          )
        : Column(
            children: [
              _buildLocationWidget(),
              Expanded(
                child: AzListView(
                  data: this.cityList,
                  itemCount: this.cityList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildListItem(this.cityList[index]),
                  padding: EdgeInsets.zero,
                  susItemBuilder: (BuildContext context, int index) {
                    CityModel model = this.cityList[index];
                    String tag = model.getSuspensionTag();
                    return GroupListIndexWidget(tag: tag);
                  },
                ),
              )
            ],
          );
  }

  Widget _buildListItem(CityModel model) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: ListTile(
            title: Text(
              model.name,
              style: TextStyle(
                fontSize: 14,
                color: DYColors.text_normal,
              ),
            ),
            onTap: () {
              if (this.onSelected != null) {
                this.onSelected(model);
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildLocationWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
          horizontal: Constant.padding, vertical: 10),
      child: Row(
        children: [
          Text(
            "当前定位城市",
            style: TextStyle(
              fontSize: 14,
              color: DYColors.text_gray,
            ),
          ),
          SizedBox(width: 10),
          Text(
            this.locationCity,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
