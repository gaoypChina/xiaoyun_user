import 'package:event_bus/event_bus.dart';

class OrderStatusEventBus extends EventBus {
  factory OrderStatusEventBus() => _getInstance();
  static OrderStatusEventBus get instance => _getInstance();

  static OrderStatusEventBus _instance;
  OrderStatusEventBus._internal() {
    //初始化
  }

  static OrderStatusEventBus _getInstance() {
    if (_instance == null) {
      _instance = OrderStatusEventBus._internal();
    }
    return _instance;
  }
}

class OrderStateChangedEvent {
  OrderStateChangedEvent();
}
