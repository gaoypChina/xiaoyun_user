import 'package:event_bus/event_bus.dart';

class UserEventBus extends EventBus {
  factory UserEventBus() => _getInstance();
  static UserEventBus get instance => _getInstance();

  static UserEventBus _instance;
  UserEventBus._internal() {
    //初始化
  }

  static UserEventBus _getInstance() {
    if (_instance == null) {
      _instance = UserEventBus._internal();
    }
    return _instance;
  }
}

class UserStateChangedEvent {
  bool isLogin;
  bool isRegister;
  UserStateChangedEvent(this.isLogin, {this.isRegister = false});
}
