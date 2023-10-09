import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/unite_message_entity.dart';

UniteMessageEntity $UniteMessageEntityFromJson(Map<String, dynamic> json) {
  final UniteMessageEntity uniteMessageEntity = UniteMessageEntity();
  final List<UniteMessageList>? list = (json['list'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<UniteMessageList>(e) as UniteMessageList).toList();
  if (list != null) {
    uniteMessageEntity.list = list;
  }
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    uniteMessageEntity.page = page;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    uniteMessageEntity.pageSize = pageSize;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    uniteMessageEntity.total = total;
  }
  return uniteMessageEntity;
}

Map<String, dynamic> $UniteMessageEntityToJson(UniteMessageEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  data['page'] = entity.page;
  data['pageSize'] = entity.pageSize;
  data['total'] = entity.total;
  return data;
}

extension UniteMessageEntityExtension on UniteMessageEntity {
  UniteMessageEntity copyWith({
    List<UniteMessageList>? list,
    int? page,
    int? pageSize,
    int? total,
  }) {
    return UniteMessageEntity()
      ..list = list ?? this.list
      ..page = page ?? this.page
      ..pageSize = pageSize ?? this.pageSize
      ..total = total ?? this.total;
  }
}

UniteMessageList $UniteMessageListFromJson(Map<String, dynamic> json) {
  final UniteMessageList uniteMessageList = UniteMessageList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    uniteMessageList.id = id;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    uniteMessageList.title = title;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    uniteMessageList.content = content;
  }
  final int? isRead = jsonConvert.convert<int>(json['is_read']);
  if (isRead != null) {
    uniteMessageList.isRead = isRead;
  }
  final String? createTime = jsonConvert.convert<String>(json['create_time']);
  if (createTime != null) {
    uniteMessageList.createTime = createTime;
  }
  return uniteMessageList;
}

Map<String, dynamic> $UniteMessageListToJson(UniteMessageList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['title'] = entity.title;
  data['content'] = entity.content;
  data['is_read'] = entity.isRead;
  data['create_time'] = entity.createTime;
  return data;
}

extension UniteMessageListExtension on UniteMessageList {
  UniteMessageList copyWith({
    int? id,
    String? title,
    String? content,
    int? isRead,
    String? createTime,
  }) {
    return UniteMessageList()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..content = content ?? this.content
      ..isRead = isRead ?? this.isRead
      ..createTime = createTime ?? this.createTime;
  }
}