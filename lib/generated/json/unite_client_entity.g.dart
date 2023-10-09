import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/unite_client_entity.dart';

UniteClientEntity $UniteClientEntityFromJson(Map<String, dynamic> json) {
  final UniteClientEntity uniteClientEntity = UniteClientEntity();
  final List<UniteClientList>? list = (json['list'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<UniteClientList>(e) as UniteClientList).toList();
  if (list != null) {
    uniteClientEntity.list = list;
  }
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    uniteClientEntity.page = page;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    uniteClientEntity.pageSize = pageSize;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    uniteClientEntity.total = total;
  }
  return uniteClientEntity;
}

Map<String, dynamic> $UniteClientEntityToJson(UniteClientEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['page'] = entity.page;
  data['pageSize'] = entity.pageSize;
  data['total'] = entity.total;
  return data;
}

extension UniteClientEntityExtension on UniteClientEntity {
  UniteClientEntity copyWith({
    List<UniteClientList>? list,
    int? page,
    int? pageSize,
    int? total,
  }) {
    return UniteClientEntity()
      ..list = list ?? this.list
      ..page = page ?? this.page
      ..pageSize = pageSize ?? this.pageSize
      ..total = total ?? this.total;
  }
}

UniteClientList $UniteClientListFromJson(Map<String, dynamic> json) {
  final UniteClientList uniteClientList = UniteClientList();
  final int? accountId = jsonConvert.convert<int>(json['account_id']);
  if (accountId != null) {
    uniteClientList.accountId = accountId;
  }
  final String? remarkName = jsonConvert.convert<String>(json['remark_name']);
  if (remarkName != null) {
    uniteClientList.remarkName = remarkName;
  }
  final String? createTime = jsonConvert.convert<String>(json['create_time']);
  if (createTime != null) {
    uniteClientList.createTime = createTime;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    uniteClientList.nickname = nickname;
  }
  final int? orderNum = jsonConvert.convert<int>(json['order_num']);
  if (orderNum != null) {
    uniteClientList.orderNum = orderNum;
  }
  return uniteClientList;
}

Map<String, dynamic> $UniteClientListToJson(UniteClientList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['account_id'] = entity.accountId;
  data['remark_name'] = entity.remarkName;
  data['create_time'] = entity.createTime;
  data['nickname'] = entity.nickname;
  data['order_num'] = entity.orderNum;
  return data;
}

extension UniteClientListExtension on UniteClientList {
  UniteClientList copyWith({
    int? accountId,
    String? remarkName,
    String? createTime,
    String? nickname,
    int? orderNum,
  }) {
    return UniteClientList()
      ..accountId = accountId ?? this.accountId
      ..remarkName = remarkName ?? this.remarkName
      ..createTime = createTime ?? this.createTime
      ..nickname = nickname ?? this.nickname
      ..orderNum = orderNum ?? this.orderNum;
  }
}