import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/unite_client_entity.g.dart';
import 'dart:convert';
export 'package:xiaoyun_user/generated/json/unite_client_entity.g.dart';

@JsonSerializable()
class UniteClientEntity {
	List<UniteClientList>? list = [];
	int? page = 0;
	int? pageSize = 0;
	int? total = 0;

	UniteClientEntity();

	factory UniteClientEntity.fromJson(Map<String, dynamic> json) => $UniteClientEntityFromJson(json);

	Map<String, dynamic> toJson() => $UniteClientEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UniteClientList {
	@JSONField(name: "account_id")
	int? accountId = 0;
	@JSONField(name: "remark_name")
	String? remarkName = '';
	@JSONField(name: "create_time")
	String? createTime = '';
	String? nickname = '';
	@JSONField(name: "order_num")
	int? orderNum = 0;

	UniteClientList();

	factory UniteClientList.fromJson(Map<String, dynamic> json) => $UniteClientListFromJson(json);

	Map<String, dynamic> toJson() => $UniteClientListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}