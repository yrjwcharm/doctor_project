import 'package:doctor_project/config/keys.dart';
import 'package:doctor_project/tools/data/store.dart';
export 'package:doctor_project/tools/data/store.dart';
export 'package:doctor_project/tools/data/notice.dart';

class WeChatActions {
  static String msg() => 'msg';

  static String groupName() => 'groupName';

  static String voiceImg() => 'voiceImg';

  static String user() => 'user';
}

class Data {
  static String msg() => Store(WeChatActions.msg()).value = '';

  static String user() => Store(WeChatActions.user()).value = '';

  static String voiceImg() => Store(WeChatActions.voiceImg()).value = '';

  static initData() {
    getStoreValue(Keys.account).then((data) {
      Store(WeChatActions.user()).value = data;
    });
  }
}
