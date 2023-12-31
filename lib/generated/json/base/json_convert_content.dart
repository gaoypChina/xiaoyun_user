// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:flutter/material.dart' show debugPrint;
import 'package:xiaoyun_user/models/store_show_entity.dart';
import 'package:xiaoyun_user/models/unite_analyze_entity.dart';
import 'package:xiaoyun_user/models/unite_base_info_entity.dart';
import 'package:xiaoyun_user/models/unite_client_entity.dart';
import 'package:xiaoyun_user/models/unite_group_entity.dart';
import 'package:xiaoyun_user/models/unite_message_detail_entity.dart';
import 'package:xiaoyun_user/models/unite_message_entity.dart';
import 'package:xiaoyun_user/models/unite_money_manager_entity.dart';
import 'package:xiaoyun_user/models/unite_order_list_entity.dart';
import 'package:xiaoyun_user/models/unite_setting_entity.dart';
import 'package:xiaoyun_user/models/user_info_entity.dart';
import 'package:xiaoyun_user/models/user_model_entity.dart';

JsonConvert jsonConvert = JsonConvert();

typedef JsonConvertFunction<T> = T Function(Map<String, dynamic> json);
typedef EnumConvertFunction<T> = T Function(String value);
typedef ConvertExceptionHandler = void Function(Object error, StackTrace stackTrace);

class JsonConvert {
  static ConvertExceptionHandler? onError;
  JsonConvertClassCollection convertFuncMap = JsonConvertClassCollection();

  /// When you are in the development, to generate a new model class, hot-reload doesn't find new generation model class, you can build on MaterialApp method called jsonConvert. ReassembleConvertFuncMap (); This method only works in a development environment
  /// https://flutter.cn/docs/development/tools/hot-reload
  /// class MyApp extends StatelessWidget {
  ///    const MyApp({Key? key})
  ///        : super(key: key);
  ///
  ///    @override
  ///    Widget build(BuildContext context) {
  ///      jsonConvert.reassembleConvertFuncMap();
  ///      return MaterialApp();
  ///    }
  /// }
  void reassembleConvertFuncMap() {
    bool isReleaseMode = const bool.fromEnvironment('dart.vm.product');
    if (!isReleaseMode) {
      convertFuncMap = JsonConvertClassCollection();
    }
  }

  T? convert<T>(dynamic value, {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    if (value is T) {
      return value;
    }
    try {
      return _asT<T>(value, enumConvert: enumConvert);
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      if (onError != null) {
        onError!(e, stackTrace);
      }
      return null;
    }
  }

  List<T?>? convertList<T>(List<dynamic>? value, {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    try {
      return value.map((dynamic e) => _asT<T>(e, enumConvert: enumConvert)).toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      if (onError != null) {
        onError!(e, stackTrace);
      }
      return <T>[];
    }
  }

  List<T>? convertListNotNull<T>(dynamic value, {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    try {
      return (value as List<dynamic>).map((dynamic e) => _asT<T>(e, enumConvert: enumConvert)!).toList();
    } catch (e, stackTrace) {
      debugPrint('asT<$T> $e $stackTrace');
      if (onError != null) {
        onError!(e, stackTrace);
      }
      return <T>[];
    }
  }

  T? _asT<T extends Object?>(dynamic value,
      {EnumConvertFunction? enumConvert}) {
    final String type = T.toString();
    final String valueS = value.toString();
    if (enumConvert != null) {
      return enumConvert(valueS) as T;
    } else if (type == "String") {
      return valueS as T;
    } else if (type == "int") {
      final int? intValue = int.tryParse(valueS);
      if (intValue == null) {
        return double.tryParse(valueS)?.toInt() as T?;
      } else {
        return intValue as T;
      }
    } else if (type == "double") {
      return double.parse(valueS) as T;
    } else if (type == "DateTime") {
      return DateTime.parse(valueS) as T;
    } else if (type == "bool") {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return (valueS == 'true') as T;
    } else if (type == "Map" || type.startsWith("Map<")) {
      return value as T;
    } else {
      if (convertFuncMap.containsKey(type)) {
        if (value == null) {
          return null;
        }
        return convertFuncMap[type]!(Map<String, dynamic>.from(value)) as T;
      } else {
        throw UnimplementedError('$type unimplemented,you can try running the app again');
      }
    }
  }

  //list is returned by type
  static M? _getListChildType<M>(List<Map<String, dynamic>> data) {
    if (<StoreShowEntity>[] is M) {
      return data.map<StoreShowEntity>((Map<String, dynamic> e) => StoreShowEntity.fromJson(e)).toList() as M;
    }
    if (<UniteAnalyzeEntity>[] is M) {
      return data.map<UniteAnalyzeEntity>((Map<String, dynamic> e) => UniteAnalyzeEntity.fromJson(e)).toList() as M;
    }
    if (<UniteAnalyzeCountTrend>[] is M) {
      return data.map<UniteAnalyzeCountTrend>((Map<String, dynamic> e) => UniteAnalyzeCountTrend.fromJson(e)).toList() as M;
    }
    if (<UniteAnalyzeMonthCountRank>[] is M) {
      return data.map<UniteAnalyzeMonthCountRank>((Map<String, dynamic> e) => UniteAnalyzeMonthCountRank.fromJson(e))
          .toList() as M;
    }
    if (<UniteAnalyzeMonthCustomerRank>[] is M) {
      return data.map<UniteAnalyzeMonthCustomerRank>((Map<String, dynamic> e) => UniteAnalyzeMonthCustomerRank.fromJson(e))
          .toList() as M;
    }
    if (<UniteAnalyzeCustomerRank>[] is M) {
      return data.map<UniteAnalyzeCustomerRank>((Map<String, dynamic> e) => UniteAnalyzeCustomerRank.fromJson(e)).toList() as M;
    }
    if (<UniteAnalyzeMonthData>[] is M) {
      return data.map<UniteAnalyzeMonthData>((Map<String, dynamic> e) => UniteAnalyzeMonthData.fromJson(e)).toList() as M;
    }
    if (<UniteBaseInfoEntity>[] is M) {
      return data.map<UniteBaseInfoEntity>((Map<String, dynamic> e) => UniteBaseInfoEntity.fromJson(e)).toList() as M;
    }
    if (<UniteClientEntity>[] is M) {
      return data.map<UniteClientEntity>((Map<String, dynamic> e) => UniteClientEntity.fromJson(e)).toList() as M;
    }
    if (<UniteClientList>[] is M) {
      return data.map<UniteClientList>((Map<String, dynamic> e) => UniteClientList.fromJson(e)).toList() as M;
    }
    if (<UniteGroupEntity>[] is M) {
      return data.map<UniteGroupEntity>((Map<String, dynamic> e) => UniteGroupEntity.fromJson(e)).toList() as M;
    }
    if (<UniteGroupList>[] is M) {
      return data.map<UniteGroupList>((Map<String, dynamic> e) => UniteGroupList.fromJson(e)).toList() as M;
    }
    if (<UniteMessageDetailEntity>[] is M) {
      return data.map<UniteMessageDetailEntity>((Map<String, dynamic> e) => UniteMessageDetailEntity.fromJson(e)).toList() as M;
    }
    if (<UniteMessageEntity>[] is M) {
      return data.map<UniteMessageEntity>((Map<String, dynamic> e) => UniteMessageEntity.fromJson(e)).toList() as M;
    }
    if (<UniteMessageList>[] is M) {
      return data.map<UniteMessageList>((Map<String, dynamic> e) => UniteMessageList.fromJson(e)).toList() as M;
    }
    if (<UniteMoneyManagerEntity>[] is M) {
      return data.map<UniteMoneyManagerEntity>((Map<String, dynamic> e) => UniteMoneyManagerEntity.fromJson(e)).toList() as M;
    }
    if (<UniteMoneyManagerList>[] is M) {
      return data.map<UniteMoneyManagerList>((Map<String, dynamic> e) => UniteMoneyManagerList.fromJson(e)).toList() as M;
    }
    if (<UniteOrderListEntity>[] is M) {
      return data.map<UniteOrderListEntity>((Map<String, dynamic> e) => UniteOrderListEntity.fromJson(e)).toList() as M;
    }
    if (<UniteOrderListList>[] is M) {
      return data.map<UniteOrderListList>((Map<String, dynamic> e) => UniteOrderListList.fromJson(e)).toList() as M;
    }
    if (<UniteSettingEntity>[] is M) {
      return data.map<UniteSettingEntity>((Map<String, dynamic> e) => UniteSettingEntity.fromJson(e)).toList() as M;
    }
    if (<UserInfoEntity>[] is M) {
      return data.map<UserInfoEntity>((Map<String, dynamic> e) => UserInfoEntity.fromJson(e)).toList() as M;
    }
    if (<UserModelEntity>[] is M) {
      return data.map<UserModelEntity>((Map<String, dynamic> e) => UserModelEntity.fromJson(e)).toList() as M;
    }

    debugPrint("${M.toString()} not found");

    return null;
  }

  static M? fromJsonAsT<M>(dynamic json) {
    if (json is M) {
      return json;
    }
    if (json is List) {
      return _getListChildType<M>(json.map((e) => e as Map<String, dynamic>).toList());
    } else {
      return jsonConvert.convert<M>(json);
    }
  }
}

class JsonConvertClassCollection {
  Map<String, JsonConvertFunction> convertFuncMap = {
    (StoreShowEntity).toString(): StoreShowEntity.fromJson,
    (UniteAnalyzeEntity).toString(): UniteAnalyzeEntity.fromJson,
    (UniteAnalyzeCountTrend).toString(): UniteAnalyzeCountTrend.fromJson,
    (UniteAnalyzeMonthCountRank).toString(): UniteAnalyzeMonthCountRank.fromJson,
    (UniteAnalyzeMonthCustomerRank).toString(): UniteAnalyzeMonthCustomerRank.fromJson,
    (UniteAnalyzeCustomerRank).toString(): UniteAnalyzeCustomerRank.fromJson,
    (UniteAnalyzeMonthData).toString(): UniteAnalyzeMonthData.fromJson,
    (UniteBaseInfoEntity).toString(): UniteBaseInfoEntity.fromJson,
    (UniteClientEntity).toString(): UniteClientEntity.fromJson,
    (UniteClientList).toString(): UniteClientList.fromJson,
    (UniteGroupEntity).toString(): UniteGroupEntity.fromJson,
    (UniteGroupList).toString(): UniteGroupList.fromJson,
    (UniteMessageDetailEntity).toString(): UniteMessageDetailEntity.fromJson,
    (UniteMessageEntity).toString(): UniteMessageEntity.fromJson,
    (UniteMessageList).toString(): UniteMessageList.fromJson,
    (UniteMoneyManagerEntity).toString(): UniteMoneyManagerEntity.fromJson,
    (UniteMoneyManagerList).toString(): UniteMoneyManagerList.fromJson,
    (UniteOrderListEntity).toString(): UniteOrderListEntity.fromJson,
    (UniteOrderListList).toString(): UniteOrderListList.fromJson,
    (UniteSettingEntity).toString(): UniteSettingEntity.fromJson,
    (UserInfoEntity).toString(): UserInfoEntity.fromJson,
    (UserModelEntity).toString(): UserModelEntity.fromJson,
  };

  bool containsKey(String type) {
    return convertFuncMap.containsKey(type);
  }

  JsonConvertFunction? operator [](String key) {
    return convertFuncMap[key];
  }
}