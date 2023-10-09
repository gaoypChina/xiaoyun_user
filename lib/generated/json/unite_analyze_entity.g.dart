import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/unite_analyze_entity.dart';

UniteAnalyzeEntity $UniteAnalyzeEntityFromJson(Map<String, dynamic> json) {
  final UniteAnalyzeEntity uniteAnalyzeEntity = UniteAnalyzeEntity();
  final String? monthMoney = jsonConvert.convert<String>(json['monthMoney']);
  if (monthMoney != null) {
    uniteAnalyzeEntity.monthMoney = monthMoney;
  }
  final int? monthCount = jsonConvert.convert<int>(json['monthCount']);
  if (monthCount != null) {
    uniteAnalyzeEntity.monthCount = monthCount;
  }
  final int? customerCount = jsonConvert.convert<int>(json['customerCount']);
  if (customerCount != null) {
    uniteAnalyzeEntity.customerCount = customerCount;
  }
  final List<UniteAnalyzeCountTrend>? countTrend = (json['countTrend'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<UniteAnalyzeCountTrend>(e) as UniteAnalyzeCountTrend).toList();
  if (countTrend != null) {
    uniteAnalyzeEntity.countTrend = countTrend;
  }
  final List<UniteAnalyzeMonthCountRank>? monthCountRank = (json['monthCountRank'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<UniteAnalyzeMonthCountRank>(e) as UniteAnalyzeMonthCountRank).toList();
  if (monthCountRank != null) {
    uniteAnalyzeEntity.monthCountRank = monthCountRank;
  }
  final List<UniteAnalyzeMonthCustomerRank>? monthCustomerRank = (json['monthCustomerRank'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<UniteAnalyzeMonthCustomerRank>(e) as UniteAnalyzeMonthCustomerRank).toList();
  if (monthCustomerRank != null) {
    uniteAnalyzeEntity.monthCustomerRank = monthCustomerRank;
  }
  final List<UniteAnalyzeCustomerRank>? customerRank = (json['customerRank'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<UniteAnalyzeCustomerRank>(e) as UniteAnalyzeCustomerRank).toList();
  if (customerRank != null) {
    uniteAnalyzeEntity.customerRank = customerRank;
  }
  final List<UniteAnalyzeMonthData>? monthData = (json['monthData'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<UniteAnalyzeMonthData>(e) as UniteAnalyzeMonthData).toList();
  if (monthData != null) {
    uniteAnalyzeEntity.monthData = monthData;
  }
  return uniteAnalyzeEntity;
}

Map<String, dynamic> $UniteAnalyzeEntityToJson(UniteAnalyzeEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['monthMoney'] = entity.monthMoney;
  data['monthCount'] = entity.monthCount;
  data['customerCount'] = entity.customerCount;
  data['countTrend'] = entity.countTrend?.map((v) => v.toJson()).toList();
  data['monthCountRank'] = entity.monthCountRank?.map((v) => v.toJson()).toList();
  data['monthCustomerRank'] = entity.monthCustomerRank?.map((v) => v.toJson()).toList();
  data['customerRank'] = entity.customerRank?.map((v) => v.toJson()).toList();
  data['monthData'] = entity.monthData?.map((v) => v.toJson()).toList();
  return data;
}

extension UniteAnalyzeEntityExtension on UniteAnalyzeEntity {
  UniteAnalyzeEntity copyWith({
    String? monthMoney,
    int? monthCount,
    int? customerCount,
    List<UniteAnalyzeCountTrend>? countTrend,
    List<UniteAnalyzeMonthCountRank>? monthCountRank,
    List<UniteAnalyzeMonthCustomerRank>? monthCustomerRank,
    List<UniteAnalyzeCustomerRank>? customerRank,
    List<UniteAnalyzeMonthData>? monthData,
  }) {
    return UniteAnalyzeEntity()
      ..monthMoney = monthMoney ?? this.monthMoney
      ..monthCount = monthCount ?? this.monthCount
      ..customerCount = customerCount ?? this.customerCount
      ..countTrend = countTrend ?? this.countTrend
      ..monthCountRank = monthCountRank ?? this.monthCountRank
      ..monthCustomerRank = monthCustomerRank ?? this.monthCustomerRank
      ..customerRank = customerRank ?? this.customerRank
      ..monthData = monthData ?? this.monthData;
  }
}

UniteAnalyzeCountTrend $UniteAnalyzeCountTrendFromJson(Map<String, dynamic> json) {
  final UniteAnalyzeCountTrend uniteAnalyzeCountTrend = UniteAnalyzeCountTrend();
  final String? day = jsonConvert.convert<String>(json['day']);
  if (day != null) {
    uniteAnalyzeCountTrend.day = day;
  }
  final int? num = jsonConvert.convert<int>(json['num']);
  if (num != null) {
    uniteAnalyzeCountTrend.num = num;
  }
  return uniteAnalyzeCountTrend;
}

Map<String, dynamic> $UniteAnalyzeCountTrendToJson(UniteAnalyzeCountTrend entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['day'] = entity.day;
  data['num'] = entity.num;
  return data;
}

extension UniteAnalyzeCountTrendExtension on UniteAnalyzeCountTrend {
  UniteAnalyzeCountTrend copyWith({
    String? day,
    int? num,
  }) {
    return UniteAnalyzeCountTrend()
      ..day = day ?? this.day
      ..num = num ?? this.num;
  }
}

UniteAnalyzeMonthCountRank $UniteAnalyzeMonthCountRankFromJson(Map<String, dynamic> json) {
  final UniteAnalyzeMonthCountRank uniteAnalyzeMonthCountRank = UniteAnalyzeMonthCountRank();
  final String? realName = jsonConvert.convert<String>(json['real_name']);
  if (realName != null) {
    uniteAnalyzeMonthCountRank.realName = realName;
  }
  final int? num = jsonConvert.convert<int>(json['num']);
  if (num != null) {
    uniteAnalyzeMonthCountRank.num = num;
  }
  return uniteAnalyzeMonthCountRank;
}

Map<String, dynamic> $UniteAnalyzeMonthCountRankToJson(UniteAnalyzeMonthCountRank entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['real_name'] = entity.realName;
  data['num'] = entity.num;
  return data;
}

extension UniteAnalyzeMonthCountRankExtension on UniteAnalyzeMonthCountRank {
  UniteAnalyzeMonthCountRank copyWith({
    String? realName,
    int? num,
  }) {
    return UniteAnalyzeMonthCountRank()
      ..realName = realName ?? this.realName
      ..num = num ?? this.num;
  }
}

UniteAnalyzeMonthCustomerRank $UniteAnalyzeMonthCustomerRankFromJson(Map<String, dynamic> json) {
  final UniteAnalyzeMonthCustomerRank uniteAnalyzeMonthCustomerRank = UniteAnalyzeMonthCustomerRank();
  final String? realName = jsonConvert.convert<String>(json['real_name']);
  if (realName != null) {
    uniteAnalyzeMonthCustomerRank.realName = realName;
  }
  final int? num = jsonConvert.convert<int>(json['num']);
  if (num != null) {
    uniteAnalyzeMonthCustomerRank.num = num;
  }
  return uniteAnalyzeMonthCustomerRank;
}

Map<String, dynamic> $UniteAnalyzeMonthCustomerRankToJson(UniteAnalyzeMonthCustomerRank entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['real_name'] = entity.realName;
  data['num'] = entity.num;
  return data;
}

extension UniteAnalyzeMonthCustomerRankExtension on UniteAnalyzeMonthCustomerRank {
  UniteAnalyzeMonthCustomerRank copyWith({
    String? realName,
    int? num,
  }) {
    return UniteAnalyzeMonthCustomerRank()
      ..realName = realName ?? this.realName
      ..num = num ?? this.num;
  }
}

UniteAnalyzeCustomerRank $UniteAnalyzeCustomerRankFromJson(Map<String, dynamic> json) {
  final UniteAnalyzeCustomerRank uniteAnalyzeCustomerRank = UniteAnalyzeCustomerRank();
  final String? realName = jsonConvert.convert<String>(json['real_name']);
  if (realName != null) {
    uniteAnalyzeCustomerRank.realName = realName;
  }
  final int? num = jsonConvert.convert<int>(json['num']);
  if (num != null) {
    uniteAnalyzeCustomerRank.num = num;
  }
  return uniteAnalyzeCustomerRank;
}

Map<String, dynamic> $UniteAnalyzeCustomerRankToJson(UniteAnalyzeCustomerRank entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['real_name'] = entity.realName;
  data['num'] = entity.num;
  return data;
}

extension UniteAnalyzeCustomerRankExtension on UniteAnalyzeCustomerRank {
  UniteAnalyzeCustomerRank copyWith({
    String? realName,
    int? num,
  }) {
    return UniteAnalyzeCustomerRank()
      ..realName = realName ?? this.realName
      ..num = num ?? this.num;
  }
}

UniteAnalyzeMonthData $UniteAnalyzeMonthDataFromJson(Map<String, dynamic> json) {
  final UniteAnalyzeMonthData uniteAnalyzeMonthData = UniteAnalyzeMonthData();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    uniteAnalyzeMonthData.name = name;
  }
  final String? time = jsonConvert.convert<String>(json['time']);
  if (time != null) {
    uniteAnalyzeMonthData.time = time;
  }
  final int? num = jsonConvert.convert<int>(json['num']);
  if (num != null) {
    uniteAnalyzeMonthData.num = num;
  }
  return uniteAnalyzeMonthData;
}

Map<String, dynamic> $UniteAnalyzeMonthDataToJson(UniteAnalyzeMonthData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['time'] = entity.time;
  data['num'] = entity.num;
  return data;
}

extension UniteAnalyzeMonthDataExtension on UniteAnalyzeMonthData {
  UniteAnalyzeMonthData copyWith({
    String? name,
    String? time,
    int? num,
  }) {
    return UniteAnalyzeMonthData()
      ..name = name ?? this.name
      ..time = time ?? this.time
      ..num = num ?? this.num;
  }
}