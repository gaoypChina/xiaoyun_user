import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/unite_group_entity.g.dart';
import 'dart:convert';
export 'package:xiaoyun_user/generated/json/unite_group_entity.g.dart';

@JsonSerializable()
class UniteGroupEntity {
	List<UniteGroupList>? list = [];
	int? page = 0;
	int? pageSize = 0;
	int? total = 0;

	UniteGroupEntity();

	factory UniteGroupEntity.fromJson(Map<String, dynamic> json) => $UniteGroupEntityFromJson(json);

	Map<String, dynamic> toJson() => $UniteGroupEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UniteGroupList {
	@JSONField(name: "account_id")
	int? accountId = 0;
	@JSONField(name: "real_name")
	String? realName = '';
	String? mobile = '';
	@JSONField(name: "create_time")
	String? createTime = '';
	String? avatar = '';
	@JSONField(name: "customer_num")
	int? customerNum = 0;

	UniteGroupList();

	factory UniteGroupList.fromJson(Map<String, dynamic> json) => $UniteGroupListFromJson(json);

	Map<String, dynamic> toJson() => $UniteGroupListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}