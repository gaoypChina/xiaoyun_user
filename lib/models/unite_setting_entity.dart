import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/unite_setting_entity.g.dart';
import 'dart:convert';
export 'package:xiaoyun_user/generated/json/unite_setting_entity.g.dart';

@JsonSerializable()
class UniteSettingEntity {
	@JSONField(name: "real_name")
	String? realName = '';
	int? sex = 0;
	String? mobile = '';
	@JSONField(name: "id_card")
	String? idCard = '';
	String? email = '';
	@JSONField(name: "bank_card")
	String? bankCard = '';
	@JSONField(name: "bank_name")
	String? bankName = '';

	UniteSettingEntity();

	factory UniteSettingEntity.fromJson(Map<String, dynamic> json) => $UniteSettingEntityFromJson(json);

	Map<String, dynamic> toJson() => $UniteSettingEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}