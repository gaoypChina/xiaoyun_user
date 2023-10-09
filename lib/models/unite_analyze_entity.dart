import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/unite_analyze_entity.g.dart';
import 'dart:convert';
export 'package:xiaoyun_user/generated/json/unite_analyze_entity.g.dart';

@JsonSerializable()
class UniteAnalyzeEntity {
	String? monthMoney = '';
	int? monthCount = 0;
	int? customerCount = 0;
	List<UniteAnalyzeCountTrend>? countTrend = [];
	List<UniteAnalyzeMonthCountRank>? monthCountRank = [];
	List<UniteAnalyzeMonthCustomerRank>? monthCustomerRank = [];
	List<UniteAnalyzeCustomerRank>? customerRank = [];
	List<UniteAnalyzeMonthData>? monthData = [];

	UniteAnalyzeEntity();

	factory UniteAnalyzeEntity.fromJson(Map<String, dynamic> json) => $UniteAnalyzeEntityFromJson(json);

	Map<String, dynamic> toJson() => $UniteAnalyzeEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UniteAnalyzeCountTrend {
	String? day = '';
	int? num = 0;

	UniteAnalyzeCountTrend();

	factory UniteAnalyzeCountTrend.fromJson(Map<String, dynamic> json) => $UniteAnalyzeCountTrendFromJson(json);

	Map<String, dynamic> toJson() => $UniteAnalyzeCountTrendToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UniteAnalyzeMonthCountRank {
	@JSONField(name: "real_name")
	String? realName = '';
	int? num = 0;

	UniteAnalyzeMonthCountRank();

	factory UniteAnalyzeMonthCountRank.fromJson(Map<String, dynamic> json) => $UniteAnalyzeMonthCountRankFromJson(json);

	Map<String, dynamic> toJson() => $UniteAnalyzeMonthCountRankToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UniteAnalyzeMonthCustomerRank {
	@JSONField(name: "real_name")
	String? realName = '';
	int? num = 0;

	UniteAnalyzeMonthCustomerRank();

	factory UniteAnalyzeMonthCustomerRank.fromJson(Map<String, dynamic> json) => $UniteAnalyzeMonthCustomerRankFromJson(json);

	Map<String, dynamic> toJson() => $UniteAnalyzeMonthCustomerRankToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UniteAnalyzeCustomerRank {
	@JSONField(name: "real_name")
	String? realName = '';
	int? num = 0;

	UniteAnalyzeCustomerRank();

	factory UniteAnalyzeCustomerRank.fromJson(Map<String, dynamic> json) => $UniteAnalyzeCustomerRankFromJson(json);

	Map<String, dynamic> toJson() => $UniteAnalyzeCustomerRankToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UniteAnalyzeMonthData {
	String? name = '';
	String? time = '';
	int? num = 0;

	UniteAnalyzeMonthData();

	factory UniteAnalyzeMonthData.fromJson(Map<String, dynamic> json) => $UniteAnalyzeMonthDataFromJson(json);

	Map<String, dynamic> toJson() => $UniteAnalyzeMonthDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}