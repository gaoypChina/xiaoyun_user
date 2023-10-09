import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/unite_setting_entity.dart';

UniteSettingEntity $UniteSettingEntityFromJson(Map<String, dynamic> json) {
  final UniteSettingEntity uniteSettingEntity = UniteSettingEntity();
  final String? realName = jsonConvert.convert<String>(json['real_name']);
  if (realName != null) {
    uniteSettingEntity.realName = realName;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    uniteSettingEntity.sex = sex;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    uniteSettingEntity.mobile = mobile;
  }
  final String? idCard = jsonConvert.convert<String>(json['id_card']);
  if (idCard != null) {
    uniteSettingEntity.idCard = idCard;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    uniteSettingEntity.email = email;
  }
  final String? bankCard = jsonConvert.convert<String>(json['bank_card']);
  if (bankCard != null) {
    uniteSettingEntity.bankCard = bankCard;
  }
  final String? bankName = jsonConvert.convert<String>(json['bank_name']);
  if (bankName != null) {
    uniteSettingEntity.bankName = bankName;
  }
  return uniteSettingEntity;
}

Map<String, dynamic> $UniteSettingEntityToJson(UniteSettingEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['real_name'] = entity.realName;
  data['sex'] = entity.sex;
  data['mobile'] = entity.mobile;
  data['id_card'] = entity.idCard;
  data['email'] = entity.email;
  data['bank_card'] = entity.bankCard;
  data['bank_name'] = entity.bankName;
  return data;
}

extension UniteSettingEntityExtension on UniteSettingEntity {
  UniteSettingEntity copyWith({
    String? realName,
    int? sex,
    String? mobile,
    String? idCard,
    String? email,
    String? bankCard,
    String? bankName,
  }) {
    return UniteSettingEntity()
      ..realName = realName ?? this.realName
      ..sex = sex ?? this.sex
      ..mobile = mobile ?? this.mobile
      ..idCard = idCard ?? this.idCard
      ..email = email ?? this.email
      ..bankCard = bankCard ?? this.bankCard
      ..bankName = bankName ?? this.bankName;
  }
}