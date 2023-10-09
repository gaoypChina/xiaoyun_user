import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/unite_order_list_entity.dart';

UniteOrderListEntity $UniteOrderListEntityFromJson(Map<String, dynamic> json) {
  final UniteOrderListEntity uniteOrderListEntity = UniteOrderListEntity();
  final List<UniteOrderListList>? list = (json['list'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<UniteOrderListList>(e) as UniteOrderListList).toList();
  if (list != null) {
    uniteOrderListEntity.list = list;
  }
  final String? page = jsonConvert.convert<String>(json['page']);
  if (page != null) {
    uniteOrderListEntity.page = page;
  }
  final String? pageSize = jsonConvert.convert<String>(json['pageSize']);
  if (pageSize != null) {
    uniteOrderListEntity.pageSize = pageSize;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    uniteOrderListEntity.total = total;
  }
  return uniteOrderListEntity;
}

Map<String, dynamic> $UniteOrderListEntityToJson(UniteOrderListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['page'] = entity.page;
  data['pageSize'] = entity.pageSize;
  data['total'] = entity.total;
  return data;
}

extension UniteOrderListEntityExtension on UniteOrderListEntity {
  UniteOrderListEntity copyWith({
    List<UniteOrderListList>? list,
    String? page,
    String? pageSize,
    int? total,
  }) {
    return UniteOrderListEntity()
      ..list = list ?? this.list
      ..page = page ?? this.page
      ..pageSize = pageSize ?? this.pageSize
      ..total = total ?? this.total;
  }
}

UniteOrderListList $UniteOrderListListFromJson(Map<String, dynamic> json) {
  final UniteOrderListList uniteOrderListList = UniteOrderListList();
  final int? orderNo = jsonConvert.convert<int>(json['order_no']);
  if (orderNo != null) {
    uniteOrderListList.orderNo = orderNo;
  }
  final String? completeTime = jsonConvert.convert<String>(json['complete_time']);
  if (completeTime != null) {
    uniteOrderListList.completeTime = completeTime;
  }
  final String? payMoney = jsonConvert.convert<String>(json['pay_money']);
  if (payMoney != null) {
    uniteOrderListList.payMoney = payMoney;
  }
  final String? incomeMoney = jsonConvert.convert<String>(json['income_money']);
  if (incomeMoney != null) {
    uniteOrderListList.incomeMoney = incomeMoney;
  }
  final String? partnerName = jsonConvert.convert<String>(json['partner_name']);
  if (partnerName != null) {
    uniteOrderListList.partnerName = partnerName;
  }
  final int? orderStatus = jsonConvert.convert<int>(json['order_status']);
  if (orderStatus != null) {
    uniteOrderListList.orderStatus = orderStatus;
  }
  return uniteOrderListList;
}

Map<String, dynamic> $UniteOrderListListToJson(UniteOrderListList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['order_no'] = entity.orderNo;
  data['complete_time'] = entity.completeTime;
  data['pay_money'] = entity.payMoney;
  data['income_money'] = entity.incomeMoney;
  data['partner_name'] = entity.partnerName;
  data['order_status'] = entity.orderStatus;
  return data;
}

extension UniteOrderListListExtension on UniteOrderListList {
  UniteOrderListList copyWith({
    int? orderNo,
    String? completeTime,
    String? payMoney,
    String? incomeMoney,
    String? partnerName,
    int? orderStatus,
  }) {
    return UniteOrderListList()
      ..orderNo = orderNo ?? this.orderNo
      ..completeTime = completeTime ?? this.completeTime
      ..payMoney = payMoney ?? this.payMoney
      ..incomeMoney = incomeMoney ?? this.incomeMoney
      ..partnerName = partnerName ?? this.partnerName
      ..orderStatus = orderStatus ?? this.orderStatus;
  }
}