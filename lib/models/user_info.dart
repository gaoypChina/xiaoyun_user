import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/result_data.dart';
import 'package:xiaoyun_user/utils/db_utils.dart';

class XYUserInfo {
  String id = '0';
  String name = '';
  String portraitUrl = '';

  Map<String, dynamic> toMap() {
    return {'userId': id, 'name': name, 'portraitUrl': portraitUrl};
  }

  XYUserInfo();

  XYUserInfo.fromJson(Map<String, dynamic> json) {
    id = json['userId'];
    name = json["userName"];
    portraitUrl = json["userAvatarImgUrl"];
  }
}

class UserInfoDataSource {
  static Map<String, XYUserInfo> cachedUserMap = new Map(); //保证同一 userId
  static UserInfoCacheListener cacheListener = new UserInfoCacheListener();

  // 用来刷新用户信息，当有用户信息更新的时候
  static void setUserInfo(XYUserInfo info) {
    if (info == null) {
      return;
    }
    cachedUserMap[info.id] = info;
    DbUtils.instance.setUserInfo(info);
  }

  // 获取用户信息
  static Future<XYUserInfo> getUserInfo(String userId) async {
    XYUserInfo? cachedUserInfo = cachedUserMap[userId];
    if (cachedUserInfo != null) {
      return cachedUserInfo;
    } else {
      XYUserInfo info;
      List<XYUserInfo> infoList = await DbUtils.instance.getUserInfo(userId: userId);
      if (infoList.isNotEmpty) {
        info = infoList[0];
      }
      info = await cacheListener.getUserInfo(userId);
      DbUtils.instance.setUserInfo(info);
      cachedUserMap[info.id] = info;

      if (info == null) {
        info = XYUserInfo();
      }
      return info;
    }
  }

  static Future<XYUserInfo> fetchUserInfo(String userId) async {
    ResultData resultData =
        await HttpUtils.get("user/getUserMessage.do", params: {"id": userId});
    XYUserInfo user = XYUserInfo();
    if (resultData.isSuccessful) {
      user = XYUserInfo.fromJson(resultData.data);
      user.id = userId;
      cachedUserMap[userId] = user;
    }
    return user;
  }

  static void setCacheListener(UserInfoCacheListener listener) {
    cacheListener = listener;
  }
}

class UserInfoCacheListener {
  late Future<XYUserInfo> Function(String userId) getUserInfo;
  late void Function(XYUserInfo info) onUserInfoUpdated;
}
