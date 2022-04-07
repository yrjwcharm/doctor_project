import 'dart:async';
import 'dart:convert' as Convert;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:doctor_project/common/local/local_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../http/api.dart';

typedef RequestCallBack = void Function(Map data);

class HttpRequest {
  // 静态私有成员，没有初始化
  static HttpRequest? _instance;
  CancelToken cancelToken = CancelToken();
  // 静态、同步、私有访问点
  Dio? dio;
  BaseOptions? options;

  static HttpRequest? getInstance() {
    _instance ??= HttpRequest();
    return _instance;
  }

  HttpRequest() {
    String token = LocalStorage.get('tokenValue');
    options = BaseOptions(
        //请求基地址,可以包含子路径
        baseUrl: Api.BASE_URL,
        //连接服务器超时时间，单位是毫秒.
        connectTimeout: 10000,
        //响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: 5000,
        //Http请求头.
        headers: {
          //do something
          "version": "1.0.0",
          "token":token
        },
        //请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
        contentType: Headers.formUrlEncodedContentType,
        //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
        // responseType: ResponseType.json
    );
    dio = Dio(options);

    //Cookie管理
    // dio.interceptors.add(CookieManager(CookieJar()));

    //添加拦截器
    dio?.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options,
        RequestInterceptorHandler requestInterceptorHandler) {
      print("请求之前");
      // Do something before request is sent
    }, onResponse: (Response response,
        ResponseInterceptorHandler responseInterceptorHandler) {
      print("响应之前");
      //状态900 代表token有问题
      if(response.data['code']==900){
         //跳转登录逻辑
      }
      // Do something with response data
    }, onError:
        (DioError error, ErrorInterceptorHandler errorInterceptorHandler) {
      print("错误之前");
    }));
  }

  Future<dynamic> get(String url,data, {bool isHideLoading =false,Options? options,CancelToken? cancelToken}) async {

    if(!isHideLoading) EasyLoading.show(status: '加载中...',dismissOnTap:false );

    try {
      Response? response =  await dio?.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      // http.Response response = await http.get(Uri.parse(uri),
      //     headers: {...?headers, 'token': token});
      final statusCode = response?.statusCode;
      if(isHideLoading)  EasyLoading.dismiss();
      // final body = response.body;
      // var result = Convert.jsonDecode(utf8.decode(response.bodyBytes));
      return response;
    } on DioError catch (e) {
      formatError(e);
      if(isHideLoading)  EasyLoading.dismiss();
      return null;
    }
  }

  Future<dynamic> post(String url,data, {bool isHideLoading =false,Options? options,CancelToken? cancelToken}) async {
    if(!isHideLoading) EasyLoading.show(status: '加载中...',dismissOnTap:false );

    try {
      Response? response =  await dio?.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      final statusCode = response?.statusCode;
      if(isHideLoading)  EasyLoading.dismiss();
      var result = response?.data;
      // var result = Convert.jsonDecode(responseBody);
      // var result = Convert.jsonDecode(utf8.decode(response.bodyBytes));
      return result;
    } on DioError catch (e) {
      if(isHideLoading)  EasyLoading.dismiss();
      formatError(e);
      return null;
    }
  }

  Future<dynamic> downloadFile(urlPath, savePath,{bool isHideLoading =false}) async {
    if(!isHideLoading) EasyLoading.show(status: '加载中...',dismissOnTap:false );
    Response? response;
    try {
      response = await dio?.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
            //进度
            print("$count $total");
          });
      print('downloadFile success---------${response?.data}');
    } on DioError catch (e) {
      print('downloadFile error---------$e');
      formatError(e);
    }
    if(isHideLoading)  EasyLoading.dismiss();
    return response?.data;
  }
  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }
  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
