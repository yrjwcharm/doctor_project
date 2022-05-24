/**
 * @Author: Sky24n
 * @GitHub: https://github.com/Sky24n
 * @Description: Regex Util.
 * @Date: 2018/9/8
 */

/// id card province dict.
List<String> ID_CARD_PROVINCE_DICT = [
  '11=北京',
  '12=天津',
  '13=河北',
  '14=山西',
  '15=内蒙古',
  '21=辽宁',
  '22=吉林',
  '23=黑龙江',
  '31=上海',
  '32=江苏',
  '33=浙江',
  '34=安徽',
  '35=福建',
  '36=江西',
  '37=山东',
  '41=河南',
  '42=湖北',
  '43=湖南',
  '44=广东',
  '45=广西',
  '46=海南',
  '50=重庆',
  '51=四川',
  '52=贵州',
  '53=云南',
  '54=西藏',
  '61=陕西',
  '62=甘肃',
  '63=青海',
  '64=宁夏',
  '65=新疆',
  '71=台湾老',
  '81=香港',
  '82=澳门',
  '83=台湾新',
  '91=国外',
];

/// Regex Util.
class RegexUtil {
  static const String regexPhone = r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$';

  /// Regex of telephone number.
  static const String regexTel = r'^0\\d{2,3}[- ]?\\d{7,8}';
  /// Regex of email.
  static const String regexEmail = r'^\w+((-\w+)|(\.\w+))*@[a-zA-Z0-9]+((\.|-)[a-zA-Z0-9]+)*\.[a-zA-Z0-9]+$';

  /// Regex of url.
  static const String regexUrl = r'[a-zA-Z]+://[^\\s]*';

  /// Regex of Chinese character.
  static const String regexZh = r'[\\u4e00-\\u9fa5]';

  /// Regex of date which pattern is 'yyyy-MM-dd'.
  static const String regexDate =
      r'^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)\$';

  /// Regex of ip address.
  static const String regexIp =
      r'((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)';


  /// 必须包含字母和数字和特殊字符, 6~16.
  static const String regexPwd =r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{6,16}$';
  /// Regex of QQ number.
  static const String regexQQ = '[1-9][0-9]{4,}';

  /// Regex of postal code in China.
  static const String regexChinaPostalCode = r"[1-9]\\d{5}(?!\\d)";

  /// Regex of Passport.
  static const String regexPassport =
      r'(^[EeKkGgDdSsPpHh]\d{8}$)|(^(([Ee][a-fA-F])|([DdSsPp][Ee])|([Kk][Jj])|([Mm][Aa])|(1[45]))\d{7}$)';

  static final Map<String, String> cityMap =  {};

  ///Return whether input matches regex of simple mobile.
  static bool isPhone(String input) {
    return matches(regexPhone, input);
  }
  static bool isPwd(String input){
    return matches(regexPwd, input);
  }

  /// Return whether input matches regex of telephone number.
  static bool isTel(String input) {
    return matches(regexTel, input);
  }
  /// Return whether input matches regex of email.
  static bool isEmail(String input) {
    return matches(regexEmail, input);
  }

  /// Return whether input matches regex of url.
  static bool isURL(String input) {
    return matches(regexUrl, input);
  }
  static bool isEmpty(String str){
    if (str == null) return false;
    return str.isEmpty;
  }

  /// Return whether input matches regex of Chinese character.
  static bool isZh(String input) {
    return '〇' == input || matches(regexZh, input);
  }

  /// Return whether input matches regex of date which pattern is 'yyyy-MM-dd'.
  static bool isDate(String input) {
    return matches(regexDate, input);
  }

  /// Return whether input matches regex of ip address.
  static bool isIP(String input) {
    return matches(regexIp, input);
  }
  /// Return whether input matches regex of QQ.
  static bool isQQ(String input) {
    return matches(regexQQ, input);
  }

  ///Return whether input matches regex of Passport.
  static bool isPassport(String input) {
    return matches(regexPassport, input);
  }

  static bool matches(String regex, String input) {
    RegExp  regExp = RegExp(regex);
    return  regExp.hasMatch(input);
  }
}
