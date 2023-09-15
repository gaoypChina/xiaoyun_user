import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/user_model_entity.dart';

UserModelEntity $UserModelEntityFromJson(Map<String, dynamic> json) {
  final UserModelEntity userModelEntity = UserModelEntity();
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    userModelEntity.phone = phone;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    userModelEntity.nickname = nickname;
  }
  final String? birthday = jsonConvert.convert<String>(json['birthday']);
  if (birthday != null) {
    userModelEntity.birthday = birthday;
  }
  final String? avatarImgUrl = jsonConvert.convert<String>(json['avatarImgUrl']);
  if (avatarImgUrl != null) {
    userModelEntity.avatarImgUrl = avatarImgUrl;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    userModelEntity.id = id;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    userModelEntity.sex = sex;
  }
  final String? password = jsonConvert.convert<String>(json['password']);
  if (password != null) {
    userModelEntity.password = password;
  }
  return userModelEntity;
}

Map<String, dynamic> $UserModelEntityToJson(UserModelEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['phone'] = entity.phone;
  data['nickname'] = entity.nickname;
  data['birthday'] = entity.birthday;
  data['avatarImgUrl'] = entity.avatarImgUrl;
  data['id'] = entity.id;
  data['sex'] = entity.sex;
  data['password'] = entity.password;
  return data;
}

extension UserModelEntityExtension on UserModelEntity {
  UserModelEntity copyWith({
    String? phone,
    String? nickname,
    String? birthday,
    String? avatarImgUrl,
    int? id,
    int? sex,
    String? password,
  }) {
    return UserModelEntity()
      ..phone = phone ?? this.phone
      ..nickname = nickname ?? this.nickname
      ..birthday = birthday ?? this.birthday
      ..avatarImgUrl = avatarImgUrl ?? this.avatarImgUrl
      ..id = id ?? this.id
      ..sex = sex ?? this.sex
      ..password = password ?? this.password;
  }
}