class UserModel {
  String phone;
  String nickname;
  String birthday;
  String avatarImgUrl;
  int id;
  int sex;
  String sexDesc;
  String password;

  UserModel.fromJson(Map<String, dynamic> json) {
    phone = json["phone"];
    String nicknameTmp = json["nickname"];
    nickname = nicknameTmp == null || nicknameTmp.isEmpty ? "未设置" : nicknameTmp;
    birthday = json["birthday"];
    avatarImgUrl = json["avatarImgUrl"];
    id = json["id"];
    sex = json["sex"];

    if (sex == 0) {
      sexDesc = "保密";
    } else if (sex == 1) {
      sexDesc = "男";
    } else {
      sexDesc = "女";
    }
    password = json["password"];
  }
}
