import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xiaoyun_user/models/user_info.dart';

class DbUtils {
  factory DbUtils() => _getInstance();
  static DbUtils get instance => _getInstance();
  static DbUtils _instance;
  static Database database;
  static String dbName = 'UserInfoCache.db';
  static String userTableName = 'users';

  DbUtils._internal() {
    // 初始化
  }

  static DbUtils _getInstance() {
    if (_instance == null) {
      _instance = new DbUtils._internal();
    }
    return _instance;
  }

  Future<void> openDb() async {
    database = await openDatabase(join(await getDatabasesPath(), dbName),
        onCreate: (db, version) {
      db.execute(
          "CREATE TABLE $userTableName(userId TEXT PRIMARY KEY, name TEXT, portraitUrl TEXT) ");
    }, version: 1);
  }

  Future<void> setUserInfo(XYUserInfo info) async {
    if (database == null) {
      await openDb();
    }
    await database?.insert(userTableName, info.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<XYUserInfo>> getUserInfo({String userId}) async {
    List<Map<String, dynamic>> maps = [];
    if (database == null) {
      await openDb();
    }
    if (userId == null || userId.isEmpty) {
      maps = await database?.query(userTableName);
    } else {
      maps = await database
          ?.query(userTableName, where: 'userId = ?', whereArgs: [userId]);
    }
    List<XYUserInfo> infoList = [];
    if (maps.length > 0) {
      infoList = List.generate(maps.length, (i) {
        XYUserInfo info = XYUserInfo();
        info.id = maps[i]['userId'];
        info.name = maps[i]['name'];
        info.portraitUrl = maps[i]['portraitUrl'];
        return info;
      });
    }
    return infoList;
  }
}
