import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/unite_order_list_entity.g.dart';
import 'dart:convert';
export 'package:xiaoyun_user/generated/json/unite_order_list_entity.g.dart';

@JsonSerializable()
class UniteOrderListEntity {
	List<UniteOrderListList>? list = [];
	String? page = '';
	String? pageSize = '';
	int? total = 0;

	UniteOrderListEntity();

	factory UniteOrderListEntity.fromJson(Map<String, dynamic> json) => $UniteOrderListEntityFromJson(json);

	Map<String, dynamic> toJson() => $UniteOrderListEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UniteOrderListList {
	@JSONField(name: "order_no")
	int? orderNo = 0;
	@JSONField(name: "complete_time")
	String? completeTime = '';
	@JSONField(name: "pay_money")
	String? payMoney = '';
	@JSONField(name: "income_money")
	String? incomeMoney = '';
	@JSONField(name: "partner_name")
	String? partnerName = '';
	@JSONField(name: "order_status")
	int? orderStatus = 0;

	UniteOrderListList();

	factory UniteOrderListList.fromJson(Map<String, dynamic> json) => $UniteOrderListListFromJson(json);

	Map<String, dynamic> toJson() => $UniteOrderListListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}