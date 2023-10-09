import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/unite_base_info_entity.dart';

UniteBaseInfoEntity $UniteBaseInfoEntityFromJson(Map<String, dynamic> json) {
  final UniteBaseInfoEntity uniteBaseInfoEntity = UniteBaseInfoEntity();
  final String? realName = jsonConvert.convert<String>(json['real_name']);
  if (realName != null) {
    uniteBaseInfoEntity.realName = realName;
  }
  final int? level = jsonConvert.convert<int>(json['level']);
  if (level != null) {
    uniteBaseInfoEntity.level = level;
  }
  final int? monthCount = jsonConvert.convert<int>(json['monthCount']);
  if (monthCount != null) {
    uniteBaseInfoEntity.monthCount = monthCount;
  }
  final String? monthMoney = jsonConvert.convert<String>(json['monthMoney']);
  if (monthMoney != null) {
    uniteBaseInfoEntity.monthMoney = monthMoney;
  }
  final int? messagePoint = jsonConvert.convert<int>(json['messagePoint']);
  if (messagePoint != null) {
    uniteBaseInfoEntity.messagePoint = messagePoint;
  }
  final String? avatar = jsonConvert.convert<String>(json['avatar']);
  if (avatar != null) {
    uniteBaseInfoEntity.avatar = avatar;
  }
  final String? levelName = jsonConvert.convert<String>(json['level_name']);
  if (levelName != null) {
    uniteBaseInfoEntity.levelName = levelName;
  }
  return uniteBaseInfoEntity;
}

Map<String, dynamic> $UniteBaseInfoEntityToJson(UniteBaseInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['real_name'] = entity.realName;
  data['level'] = entity.level;
  data['monthCount'] = entity.monthCount;
  data['monthMoney'] = entity.monthMoney;
  data['messagePoint'] = entity.messagePoint;
  data['avatar'] = entity.avatar;
  data['level_name'] = entity.levelName;
  return data;
}

extension UniteBaseInfoEntityExtension on UniteBaseInfoEntity {
  UniteBaseInfoEntity copyWith({
    String? realName,
    int? level,
    int? monthCount,
    String? monthMoney,
    int? messagePoint,
    String? avatar,
    String? levelName,
  }) {
    return UniteBaseInfoEntity()
      ..realName = realName ?? this.realName
      ..level = level ?? this.level
      ..monthCount = monthCount ?? this.monthCount
      ..monthMoney = monthMoney ?? this.monthMoney
      ..messagePoint = messagePoint ?? this.messagePoint
      ..avatar = avatar ?? this.avatar
      ..levelName = levelName ?? this.levelName;
  }
}