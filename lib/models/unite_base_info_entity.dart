import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/unite_base_info_entity.g.dart';
import 'dart:convert';
export 'package:xiaoyun_user/generated/json/unite_base_info_entity.g.dart';

@JsonSerializable()
class UniteBaseInfoEntity {
	@JSONField(name: "real_name")
	String? realName = '';
	int? level = 0;
	int? monthCount = 0;
	String? monthMoney = '';
	int? messagePoint = 0;
	String? avatar = '';
	@JSONField(name: "level_name")
	String? levelName = '';

	UniteBaseInfoEntity();

	factory UniteBaseInfoEntity.fromJson(Map<String, dynamic> json) => $UniteBaseInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $UniteBaseInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}