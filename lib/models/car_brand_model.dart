import 'package:azlistview/azlistview.dart';
import 'package:lpinyin/lpinyin.dart';

class CarBrandModel extends ISuspensionBean {
  String title = '';
  int brandId = 0;
  int id = 0;
  String? firstLetter;
  String pinyin = '';

  CarBrandModel({this.title = '', this.brandId = 0});

  List<CarBrandModel> child = [];

  CarBrandModel.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    brandId = json["brandId"];
    id = json["id"];
    firstLetter = json["firstLetter"];
    pinyin = PinyinHelper.getPinyinE(title??'', separator: "");
  }

  @override
  String getSuspensionTag() => firstLetter??'';
}
