import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/unite_group_entity.dart';

UniteGroupEntity $UniteGroupEntityFromJson(Map<String, dynamic> json) {
  final UniteGroupEntity uniteGroupEntity = UniteGroupEntity();
  final List<UniteGroupList>? list = (json['list'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<UniteGroupList>(e) as UniteGroupList).toList();
  if (list != null) {
    uniteGroupEntity.list = list;
  }
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    uniteGroupEntity.page = page;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    uniteGroupEntity.pageSize = pageSize;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    uniteGroupEntity.total = total;
  }
  return uniteGroupEntity;
}

Map<String, dynamic> $UniteGroupEntityToJson(UniteGroupEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['page'] = entity.page;
  data['pageSize'] = entity.pageSize;
  data['total'] = entity.total;
  return data;
}

extension UniteGroupEntityExtension on UniteGroupEntity {
  UniteGroupEntity copyWith({
    List<UniteGroupList>? list,
    int? page,
    int? pageSize,
    int? total,
  }) {
    return UniteGroupEntity()
      ..list = list ?? this.list
      ..page = page ?? this.page
      ..pageSize = pageSize ?? this.pageSize
      ..total = total ?? this.total;
  }
}

UniteGroupList $UniteGroupListFromJson(Map<String, dynamic> json) {
  final UniteGroupList uniteGroupList = UniteGroupList();
  final int? accountId = jsonConvert.convert<int>(json['account_id']);
  if (accountId != null) {
    uniteGroupList.accountId = accountId;
  }
  final String? realName = jsonConvert.convert<String>(json['real_name']);
  if (realName != null) {
    uniteGroupList.realName = realName;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    uniteGroupList.mobile = mobile;
  }
  final String? createTime = jsonConvert.convert<String>(json['create_time']);
  if (createTime != null) {
    uniteGroupList.createTime = createTime;
  }
  final String? avatar = jsonConvert.convert<String>(json['avatar']);
  if (avatar != null) {
    uniteGroupList.avatar = avatar;
  }
  final int? customerNum = jsonConvert.convert<int>(json['customer_num']);
  if (customerNum != null) {
    uniteGroupList.customerNum = customerNum;
  }
  return uniteGroupList;
}

Map<String, dynamic> $UniteGroupListToJson(UniteGroupList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['account_id'] = entity.accountId;
  data['real_name'] = entity.realName;
  data['mobile'] = entity.mobile;
  data['create_time'] = entity.createTime;
  data['avatar'] = entity.avatar;
  data['customer_num'] = entity.customerNum;
  return data;
}

extension UniteGroupListExtension on UniteGroupList {
  UniteGroupList copyWith({
    int? accountId,
    String? realName,
    String? mobile,
    String? createTime,
    String? avatar,
    int? customerNum,
  }) {
    return UniteGroupList()
      ..accountId = accountId ?? this.accountId
      ..realName = realName ?? this.realName
      ..mobile = mobile ?? this.mobile
      ..createTime = createTime ?? this.createTime
      ..avatar = avatar ?? this.avatar
      ..customerNum = customerNum ?? this.customerNum;
  }
}