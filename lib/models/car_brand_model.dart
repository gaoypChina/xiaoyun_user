import 'package:azlistview/azlistview.dart';
import 'package:lpinyin/lpinyin.dart';

class CarBrandModel extends ISuspensionBean {
  String title;
  int brandId;
  int id;
  String firstLetter;
  String pinyin;

  CarBrandModel({this.title, this.brandId});

  List<CarBrandModel> child = [];

  CarBrandModel.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    brandId = json["brandId"];
    id = json["id"];
    firstLetter = json["firstLetter"];
    pinyin = PinyinHelper.getPinyinE(title, separator: "");
  }

  @override
  String getSuspensionTag() => firstLetter;
}
