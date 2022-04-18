import '../common/event/event_bus.dart';

class EventBusUtil{
  static  EventBus? _instance;
  static EventBus getInstance(){
    _instance ??= EventBus();
    return _instance!;
  }
}