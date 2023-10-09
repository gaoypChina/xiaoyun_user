import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/unite_message_detail_entity.g.dart';
import 'dart:convert';
export 'package:xiaoyun_user/generated/json/unite_message_detail_entity.g.dart';

@JsonSerializable()
class UniteMessageDetailEntity {
	@JSONField(name: "create_time")
	String? createTime = '';
	String? title = '';
	String? content = '';

	UniteMessageDetailEntity();

	factory UniteMessageDetailEntity.fromJson(Map<String, dynamic> json) => $UniteMessageDetailEntityFromJson(json);

	Map<String, dynamic> toJson() => $UniteMessageDetailEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}