import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/unite_message_entity.g.dart';
import 'dart:convert';
export 'package:xiaoyun_user/generated/json/unite_message_entity.g.dart';

@JsonSerializable()
class UniteMessageEntity {
	List<UniteMessageList>? list = [];
	int? page = 0;
	int? pageSize = 0;
	int? total = 0;

	UniteMessageEntity();

	factory UniteMessageEntity.fromJson(Map<String, dynamic> json) => $UniteMessageEntityFromJson(json);

	Map<String, dynamic> toJson() => $UniteMessageEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UniteMessageList {
	int? id = 0;
	String? title = '';
	String? content = '';
	@JSONField(name: "is_read")
	int? isRead = 0;
	@JSONField(name: "create_time")
	String? createTime = '';

	UniteMessageList();

	factory UniteMessageList.fromJson(Map<String, dynamic> json) => $UniteMessageListFromJson(json);

	Map<String, dynamic> toJson() => $UniteMessageListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}