import 'package:doctor_project/common/local/local_storage.dart';
import 'package:doctor_project/pages/login/login.dart';
import 'package:doctor_project/pages/splash_screen.dart';
import 'package:doctor_project/pages/tabs/main.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  @override
  void initState() {
    super.initState();
    initJpush();
  }


  // getLoginState() async{
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String isLogin = sharedPreferences.getString('tokenValue');
  // }

  //  监听极光推送 (自定义的方法)
  //  https://github.com/jpush/jpush-flutter-plugin/blob/master/documents/APIs.md
  initJpush() async {
    // 初始化
    JPush jpush = JPush();

    // 获取注册的ID
    jpush.getRegistrationID().then((rid) async {
      SharedPreferences perfer = await SharedPreferences.getInstance();
      bool isSuccess = await perfer.setString('jpushToken', rid);
      print('获取注册的id $isSuccess' + rid);
      // print("获取注册的id:$rid");
    });

    // 初始化
    jpush.setup(
      // 极光官方申请应用的APP KEY
      appKey: Platform.isAndroid
          ? "c1e6cf8c94f962091da3c2f2"
          : "b9af57826f0f309d8535255a",
      channel: "theChannel",
      production: false,
      debug: true,
    );

    // 设置别名实现指定用户推送
    jpush.setAlias("jg6666").then((map) {
      print("设置别名成功");
    });

    // iOS10+ 可以通过此方法来设置推送是否前台展示，是否触发声音，是否设置应用角标 badge
    jpush.applyPushAuthority(
        const NotificationSettingsIOS(sound: true, alert: true, badge: true));

    try {
      // 监听消息通知
      jpush.addEventHandler(
        // 接收通知回调方法。
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
        },
        // 点击通知回调方法。
        onOpenNotification: (Map<String, dynamic> message) async {
          // 当用户点击时，可以做一些路由跳转
          print("flutter onOpenNotification: $message");
        },
        // 接收自定义消息回调方法。
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
        },
      );
    } catch (e) {
      print('极光SDK配置异常');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('zh', 'CN'), //设置语言为中文
      ],
      debugShowCheckedModeBanner: false,
      // 设置这一属性即可
      home: SplashScreen(),
      builder: EasyLoading.init(),
      // home:MakePrescription(),
      routes: routes,
    );
  }
}
