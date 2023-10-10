import 'package:xiaoyun_user/generated/json/base/json_convert_content.dart';
import 'package:xiaoyun_user/models/store_show_entity.dart';

StoreShowEntity $StoreShowEntityFromJson(Map<String, dynamic> json) {
  final StoreShowEntity storeShowEntity = StoreShowEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    storeShowEntity.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    storeShowEntity.name = name;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    storeShowEntity.address = address;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    storeShowEntity.phone = phone;
  }
  final bool? isChecked = jsonConvert.convert(bool)(json['isChecked']);
  if (isChecked != null) {
    storeShowEntity.isChecked = isChecked;
  }
  return storeShowEntity;
}

Map<String, dynamic> $StoreShowEntityToJson(StoreShowEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['address'] = entity.address;
  data['phone'] = entity.phone;
  data['isClicked'] = entity.isChecked;
  return data;
}

extension StoreShowEntityExtension on StoreShowEntity {
  StoreShowEntity copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    bool? isChecked,
  }) {
    return StoreShowEntity()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..address = address ?? this.address
      ..phone = phone ?? this.phone
      ..isChecked = isChecked ?? this.isChecked;
  }
}