import 'package:azlistview/azlistview.dart';
import 'package:lpinyin/lpinyin.dart';

class CityModel extends ISuspensionBean {
  String name = '';
  String code = '';
  int id = 0;
  String firstLetter = '';
  String pinyin = '';

  List<CityModel> child = [];

  CityModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    code = json["code"];
    id = json["id"];
    firstLetter = json["firstLetter"];
    pinyin = PinyinHelper.getPinyinE(name??'', separator: "");

    List childJsonList = json["child"] as List;
    childJsonList.forEach((element) {
      child.add(CityModel.fromJson(element));
    });
  }

  @override
  String getSuspensionTag() => firstLetter;
}
