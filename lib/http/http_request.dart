import 'dart:async';
import 'dart:convert' as Convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../http/api.dart';
typedef RequestCallBack = void Function(Map data);

class HttpRequest {
  // 静态私有成员，没有初始化
  static HttpRequest? _instance;
  // 静态、同步、私有访问点
  static HttpRequest? getInstance() {
    _instance ??= HttpRequest(Api.BASE_URL);
    return _instance;
  }
  final baseUrl;
  HttpRequest(this.baseUrl);
  Future<dynamic> get(String uri, {Map<String, String>? headers}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token= sp.getString('tokenValue')??'';
    try {
      http.Response response = await http.get(Uri.parse(baseUrl + uri), headers: {...?headers,'token':token});
      final statusCode = response.statusCode;
      final body = response.body;
      // var result = Convert.jsonDecode(utf8.decode(response.bodyBytes));
      var result = Convert.jsonDecode(utf8.decode(response.bodyBytes));
      print(result);
      return result;
    } on Exception catch (e) {
      print('exception e=${e.toString()}');
      return null;
    }
  }

  Future<dynamic> getResponseBody(String uri, {Map<String, String>? headers}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token= sp.getString('tokenValue')??'';
    try {
      http.Response response = await http.get(Uri.parse(baseUrl + uri), headers: {...?headers,'token':token});
      final statusCode = response.statusCode;
      final body = response.body;
      // var result = Convert.jsonDecode(body);
      var result = Convert.jsonDecode(utf8.decode(response.bodyBytes));
      return result;
    } on Exception catch (e) {
      print('exception e=${e.toString()}');
      return null;
    }
  }

  Future<dynamic> post(String uri, dynamic body, {Map<String, String>? headers}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token= sp.getString('tokenValue')??'';
    try {
      http.Response response = await http.post(Uri.parse(baseUrl + uri), body: body, headers:  {...?headers,'token':token});
      final statusCode = response.statusCode;
      final responseBody = response.body;
      // var result = Convert.jsonDecode(responseBody);
      var result = Convert.jsonDecode(utf8.decode(response.bodyBytes));
      return result;
    } on Exception catch (e) {
      print('exception e=${e.toString()}');
      return null;
    }
  }
}


