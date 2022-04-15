import 'dart:async';
import 'dart:convert' as Convert;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:doctor_project/common/local/local_storage.dart';
import 'package:doctor_project/pages/login/login.dart';
import 'package:doctor_project/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../http/api.dart';
import '../main.dart';

typedef RequestCallBack = void Function(Map data);

class HttpRequest {
  // 静态私有成员，没有初始化
  static HttpRequest? _instance;
  // 静态、同步、私有访问点
  late Dio dio;
  BaseOptions? options;

  static HttpRequest getInstance() {
    _instance = HttpRequest();
    return _instance!;
  }


  HttpRequest()  {
    options = BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: Api.BASE_URL,
      //连接服务器超时时间，单位是毫秒.
      // connectTimeout: 10000,
      // 响应流上前后两次接受到数据的间隔，单位为毫秒。
      // receiveTimeout: 5000,
      //Http请求头.
      headers: {
        //do something
        "version": "1.0.0",
      },
      contentType: Headers.jsonContentType,
      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json
    );
    //Cookie管理
    dio = Dio(options);
    //添加拦截器
    dio.interceptors.add(InterceptorsWrapper(onRequest:
        (RequestOptions options,
            RequestInterceptorHandler requestInterceptorHandler) async{
          String? token = await LocalStorage.get('tokenValue');
          options.headers = {'token': token ?? ''};
          EasyLoading.show(status: '加载中...', dismissOnTap: false,maskType: EasyLoadingMaskType.black);
          return requestInterceptorHandler.next(options);
          // Do something before request is sent
    }, onResponse: (Response response,
        ResponseInterceptorHandler responseInterceptorHandler) {
      //状态900 代表token有问题
      print('走了${response.data}');
      if (response.data['code'] == 900) {
        BuildContext? context = navigatorKey.currentState?.overlay?.context;
        if(context!=null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/loginP', ModalRoute.withName("/"));
        }
        //跳转登录逻辑
      }
      EasyLoading.dismiss();
      return responseInterceptorHandler.next(response);
      // Do something with response data
    }, onError:
        (DioError error, ErrorInterceptorHandler errorInterceptorHandler) {
        print('${error.message} ||||| ${error.type} ||||| ${error.error}');
         EasyLoading.dismiss();
    }));
  }


  Future<dynamic> get(String url, Map<String, dynamic>? data,
      {Options? option}) async {
    try {
      Response? response = await dio.get(url,
          queryParameters: data, options: option);
      var result =response.data;
      return result;
    } on DioError catch (e) {
      return null;
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic>? data,
      {Options? option}) async {
    try {
      Response? response = await dio.post(url,
          data: data, options: option);
      var result =response.data;
      return result;
    } on DioError catch (e) {
      return null;
    }
  }

  Future<dynamic> downloadFile(urlPath, savePath) async {
    Response? response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
      });
    } on DioError catch (e) {}
    return response?.data;
  }

}
