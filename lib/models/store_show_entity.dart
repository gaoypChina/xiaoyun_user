import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/store_show_entity.g.dart';
import 'dart:convert';
export 'package:xiaoyun_user/generated/json/store_show_entity.g.dart';

@JsonSerializable()
class StoreShowEntity {
	int? id = 0;
	String? name = '';
	String? address = '';
	String? phone = '';
	bool? isChecked = false;

	StoreShowEntity();

	factory StoreShowEntity.fromJson(Map<String, dynamic> json) => $StoreShowEntityFromJson(json);

	Map<String, dynamic> toJson() => $StoreShowEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}