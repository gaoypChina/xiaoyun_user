import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/user_model_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class UserModelEntity {
	String? phone;
	String? nickname;
	String? birthday;
	String? avatarImgUrl;
	int? id;
	int? sex;
	String? password;

	UserModelEntity();

	factory UserModelEntity.fromJson(Map<String, dynamic> json) => $UserModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $UserModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}