import 'package:doctor_project/utils/regex_util.dart';

class DesensitizationUtil {

  static String desensitizationMobile(str) {
      String phoneNumberStr = str.replaceFirst(
          RegExp(r'\d{4}'), '****', 3);
      return phoneNumberStr;
  }

  static desensitizationIdCard(str) {

  }
}
