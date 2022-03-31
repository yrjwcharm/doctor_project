import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  static  EventBus ? _instance;
  static EventBus getInstance(){
    if (_instance == null) {
      _instance = EventBus();
    }
    return _instance!;
  }
}