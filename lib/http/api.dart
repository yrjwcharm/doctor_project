import 'http_request.dart';
typedef RequestCallBack<T> = void Function(T value);

class API {
  static const BASE_URL = 'https://interhospital.youjiankang.net';
  var _request = HttpRequest(API.BASE_URL);

}
