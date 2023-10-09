import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/unite_money_manager_entity.g.dart';
import 'dart:convert';
export 'package:xiaoyun_user/generated/json/unite_money_manager_entity.g.dart';

@JsonSerializable()
class UniteMoneyManagerEntity {
	List<UniteMoneyManagerList>? list = [];
	int? page = 0;
	int? pageSize = 0;
	int? total = 0;
	String? balance = '';
	String? waitMoney = '';
	String? withdrawMoney = '';

	UniteMoneyManagerEntity();

	factory UniteMoneyManagerEntity.fromJson(Map<String, dynamic> json) => $UniteMoneyManagerEntityFromJson(json);

	Map<String, dynamic> toJson() => $UniteMoneyManagerEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UniteMoneyManagerList {
	String? title = '';
	String? money = '';
	@JSONField(name: "create_time")
	String? createTime = '';

	UniteMoneyManagerList();

	factory UniteMoneyManagerList.fromJson(Map<String, dynamic> json) => $UniteMoneyManagerListFromJson(json);

	Map<String, dynamic> toJson() => $UniteMoneyManagerListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}