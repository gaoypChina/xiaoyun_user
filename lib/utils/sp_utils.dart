import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class SpUtil {
  static SpUtil? _singleton;
  static SharedPreferences? _prefs;
  static Lock _lock = Lock();

  static Future<SpUtil> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // keep local instance till it is fully initialized.
          // 保持本地实例直到完全初始化。
          var singleton = SpUtil._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton!;
  }

  SpUtil._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// put object.
  static Future<bool> putObject(String key, Object value) async {
    if (_prefs == null) return false;
    return  _prefs!.setString(key, value == null ? "" : json.encode(value));
  }

  /// get obj.
  static T getObj<T>(String key, T f(Map v), {required T defValue}) {
    Map map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  static Map getObject(String key) {
    if (_prefs == null) return {};
    String _data = _prefs!.getString(key)??'';
    return (_data.isEmpty) ? null : json.decode(_data);
  }

  /// put object list.
  static Future<bool> putObjectList(String key, List<Object> list) async {
    if (_prefs == null) return false;
    List<String>? _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    if (_dataList == null) {
      return false;
    }
    return  _prefs!.setStringList(key, _dataList);
  }

  /// get obj list.
  static List<T> getObjList<T>(String key, T f(Map v),
      {List<T> defValue = const []}) {
    List<Map>? dataList = getObjectList(key);
    List<T>? list = dataList?.map((value) {
      return f(value);
    })?.toList();
    return list ?? defValue;
  }

  /// get object list.
  static List<Map>? getObjectList(String key) {
    if (_prefs == null) return [];
    List<String>? dataLis = _prefs!.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }

  /// get string.
  static String getString(String key, {String defValue = ''}) {
    if (_prefs == null) return defValue;
    return _prefs!.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool> putString(String key, String value) async{
    if (_prefs == null) return false;
    return  _prefs!.setString(key, value);
  }

  /// get bool.
  static bool getBool(String key, {bool defValue = false}) {
    if (_prefs == null) return defValue;
    return _prefs!.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool> putBool(String key, bool value) async {
    if (_prefs == null) return false;
    return _prefs!.setBool(key, value);
  }

  /// get int.
  static int getInt(String key, {int defValue = 0}) {
    if (_prefs == null) return defValue;
    return _prefs!.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool> putInt(String key, int value) async{
    if (_prefs == null) return false;
    return _prefs!.setInt(key, value);
  }

  /// get double.
  static double getDouble(String key, {double defValue = 0.0}) {
    if (_prefs == null) return defValue;
    return _prefs!.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool> putDouble(String key, double value) async{
    if (_prefs == null) return false;
    return _prefs!.setDouble(key, value);
  }

  /// get string list.
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (_prefs == null) return defValue;
    return _prefs!.getStringList(key) ?? defValue;
  }

  /// put string list.
  static Future<bool> putStringList(String key, List<String> value) async{
    if (_prefs == null) return false;
    return _prefs!.setStringList(key, value);
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {required Object defValue}) {
    if (_prefs == null) return defValue;
    return _prefs!.get(key) ?? defValue;
  }

  /// have key.
  static bool haveKey(String key) {
    if (_prefs == null) return false;
    return _prefs!.getKeys().contains(key);
  }

  /// get keys.
  static Set<String> getKeys() {
    if (_prefs == null) return Set();
    return _prefs!.getKeys();
  }

  /// remove.
  static Future<bool> remove(String key) async {
    if (_prefs == null) return false;
    return _prefs!.remove(key);
  }

  /// clear.
  static Future<bool> clear() async {
    if (_prefs == null) return false;
    return _prefs!.clear();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return _prefs != null;
  }
}
