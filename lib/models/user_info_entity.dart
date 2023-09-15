import 'package:xiaoyun_user/generated/json/base/json_field.dart';
import 'package:xiaoyun_user/generated/json/user_info_entity.g.dart';
import 'package:xiaoyun_user/network/http_utils.dart';
import 'package:xiaoyun_user/network/result_data.dart';
import 'package:xiaoyun_user/utils/db_utils.dart';
import 'dart:convert';

@JsonSerializable()
class UserInfoEntity {
	String? id = '';
	String? name = '';
	String? portraitUrl = '';

	UserInfoEntity();

	Map<String, dynamic> toMap() {
		return {'userId': id, 'name': name, 'portraitUrl': portraitUrl};
	}

	factory UserInfoEntity.fromJson(Map<String, dynamic> json) => $UserInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $UserInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

class UserInfoDataSource {
	static Map<String, UserInfoEntity> cachedUserMap = new Map(); //保证同一 userId
	static UserInfoCacheListener cacheListener = new UserInfoCacheListener();

	// 用来刷新用户信息，当有用户信息更新的时候
	static void setUserInfo(UserInfoEntity info) {
		cachedUserMap[info.id??'0'] = info;
		DbUtils.instance.setUserInfo(info);
	}

	// 获取用户信息
	static Future<UserInfoEntity> getUserInfo(String userId) async {
		UserInfoEntity? cachedUserInfo = cachedUserMap[userId];
		if (cachedUserInfo != null) {
			return cachedUserInfo;
		} else {
			UserInfoEntity info;
			List<UserInfoEntity> infoList = await DbUtils.instance.getUserInfo(userId: userId);
			if (infoList.isNotEmpty) {
				info = infoList[0];
			}
			info = await cacheListener.getUserInfo(userId);
			DbUtils.instance.setUserInfo(info);
			cachedUserMap[info.id??'0'] = info;

			if (info == null) {
				info = UserInfoEntity();
			}
			return info;
		}
	}

	static Future<UserInfoEntity> fetchUserInfo(String userId) async {
		ResultData resultData =
		await HttpUtils.get("user/getUserMessage.do", params: {"id": userId});
		UserInfoEntity user = UserInfoEntity();
		if (resultData.isSuccessful) {
			user = UserInfoEntity.fromJson(resultData.data);
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
	late Future<UserInfoEntity> Function(String userId) getUserInfo;
	late void Function(UserInfoEntity info) onUserInfoUpdated;
}