import 'dart:convert';
class JSONUtil {
  static List<dynamic> decodeListResult(String data) {
    return json.decode(data);
  }

  static Map<String, dynamic> decodeMapResult(String data) {
    return json.decode(data);
  }

  static String encodeToString(String data) {
    return json.encode(data);
  }
}
