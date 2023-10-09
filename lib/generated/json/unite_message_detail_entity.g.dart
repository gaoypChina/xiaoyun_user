import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/unite_message_detail_entity.dart';

UniteMessageDetailEntity $UniteMessageDetailEntityFromJson(Map<String, dynamic> json) {
  final UniteMessageDetailEntity uniteMessageDetailEntity = UniteMessageDetailEntity();
  final String? createTime = jsonConvert.convert<String>(json['create_time']);
  if (createTime != null) {
    uniteMessageDetailEntity.createTime = createTime;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    uniteMessageDetailEntity.title = title;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    uniteMessageDetailEntity.content = content;
  }
  return uniteMessageDetailEntity;
}

Map<String, dynamic> $UniteMessageDetailEntityToJson(UniteMessageDetailEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['create_time'] = entity.createTime;
  data['title'] = entity.title;
  data['content'] = entity.content;
  return data;
}

extension UniteMessageDetailEntityExtension on UniteMessageDetailEntity {
  UniteMessageDetailEntity copyWith({
    String? createTime,
    String? title,
    String? content,
  }) {
    return UniteMessageDetailEntity()
      ..createTime = createTime ?? this.createTime
      ..title = title ?? this.title
      ..content = content ?? this.content;
  }
}