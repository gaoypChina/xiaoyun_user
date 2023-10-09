import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/unite_money_manager_entity.dart';

UniteMoneyManagerEntity $UniteMoneyManagerEntityFromJson(Map<String, dynamic> json) {
  final UniteMoneyManagerEntity uniteMoneyManagerEntity = UniteMoneyManagerEntity();
  final List<UniteMoneyManagerList>? list = (json['list'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<UniteMoneyManagerList>(e) as UniteMoneyManagerList).toList();
  if (list != null) {
    uniteMoneyManagerEntity.list = list;
  }
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    uniteMoneyManagerEntity.page = page;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    uniteMoneyManagerEntity.pageSize = pageSize;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    uniteMoneyManagerEntity.total = total;
  }
  final String? balance = jsonConvert.convert<String>(json['balance']);
  if (balance != null) {
    uniteMoneyManagerEntity.balance = balance;
  }
  final String? waitMoney = jsonConvert.convert<String>(json['waitMoney']);
  if (waitMoney != null) {
    uniteMoneyManagerEntity.waitMoney = waitMoney;
  }
  final String? withdrawMoney = jsonConvert.convert<String>(json['withdrawMoney']);
  if (withdrawMoney != null) {
    uniteMoneyManagerEntity.withdrawMoney = withdrawMoney;
  }
  return uniteMoneyManagerEntity;
}

Map<String, dynamic> $UniteMoneyManagerEntityToJson(UniteMoneyManagerEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['page'] = entity.page;
  data['pageSize'] = entity.pageSize;
  data['total'] = entity.total;
  data['balance'] = entity.balance;
  data['waitMoney'] = entity.waitMoney;
  data['withdrawMoney'] = entity.withdrawMoney;
  return data;
}

extension UniteMoneyManagerEntityExtension on UniteMoneyManagerEntity {
  UniteMoneyManagerEntity copyWith({
    List<UniteMoneyManagerList>? list,
    int? page,
    int? pageSize,
    int? total,
    String? balance,
    String? waitMoney,
    String? withdrawMoney,
  }) {
    return UniteMoneyManagerEntity()
      ..list = list ?? this.list
      ..page = page ?? this.page
      ..pageSize = pageSize ?? this.pageSize
      ..total = total ?? this.total
      ..balance = balance ?? this.balance
      ..waitMoney = waitMoney ?? this.waitMoney
      ..withdrawMoney = withdrawMoney ?? this.withdrawMoney;
  }
}

UniteMoneyManagerList $UniteMoneyManagerListFromJson(Map<String, dynamic> json) {
  final UniteMoneyManagerList uniteMoneyManagerList = UniteMoneyManagerList();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    uniteMoneyManagerList.title = title;
  }
  final String? money = jsonConvert.convert<String>(json['money']);
  if (money != null) {
    uniteMoneyManagerList.money = money;
  }
  final String? createTime = jsonConvert.convert<String>(json['create_time']);
  if (createTime != null) {
    uniteMoneyManagerList.createTime = createTime;
  }
  return uniteMoneyManagerList;
}

Map<String, dynamic> $UniteMoneyManagerListToJson(UniteMoneyManagerList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['money'] = entity.money;
  data['create_time'] = entity.createTime;
  return data;
}

extension UniteMoneyManagerListExtension on UniteMoneyManagerList {
  UniteMoneyManagerList copyWith({
    String? title,
    String? money,
    String? createTime,
  }) {
    return UniteMoneyManagerList()
      ..title = title ?? this.title
      ..money = money ?? this.money
      ..createTime = createTime ?? this.createTime;
  }
}