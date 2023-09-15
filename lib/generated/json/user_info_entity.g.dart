import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/user_info_entity.dart';
import 'package:xiaoyun_user/network/http_utils.dart';

import 'package:xiaoyun_user/network/result_data.dart';

import 'package:xiaoyun_user/utils/db_utils.dart';


UserInfoEntity $UserInfoEntityFromJson(Map<String, dynamic> json) {
  final UserInfoEntity userInfoEntity = UserInfoEntity();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    userInfoEntity.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    userInfoEntity.name = name;
  }
  final String? portraitUrl = jsonConvert.convert<String>(json['portraitUrl']);
  if (portraitUrl != null) {
    userInfoEntity.portraitUrl = portraitUrl;
  }
  return userInfoEntity;
}

Map<String, dynamic> $UserInfoEntityToJson(UserInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['portraitUrl'] = entity.portraitUrl;
  return data;
}

extension UserInfoEntityExtension on UserInfoEntity {
  UserInfoEntity copyWith({
    String? id,
    String? name,
    String? portraitUrl,
  }) {
    return UserInfoEntity()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..portraitUrl = portraitUrl ?? this.portraitUrl;
  }
}