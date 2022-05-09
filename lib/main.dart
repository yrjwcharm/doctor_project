import 'package:doctor_project/pages/home/chat_room.dart';
import 'package:doctor_project/pages/home/make_prescription.dart';
import 'package:doctor_project/pages/login/login.dart';
import 'package:doctor_project/pages/login/register.dart';
import 'package:doctor_project/pages/tabs/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'common/local/local_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    // 强制竖屏
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  // if(Platform.isAndroid) {
  //   SystemChrome.setSystemUIOverlayStyle(
  //       const SystemUiOverlayStyle(
  //           statusBarColor: Colors.transparent,
  //           systemNavigationBarColor: Colors.white,
  //           statusBarIconBrightness: Brightness.light  // dark:一般显示黑色   light：一般显示白色
  //       ));
  // }
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  String? token;

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
      appKey: "b9af57826f0f309d8535255a",
      channel: "theChannel",
      production: false,
      debug: true,
    );

    // 设置别名实现指定用户推送
    jpush.setAlias("1111").then((map) {
      print("设置别名成功");
    });

    // iOS10+ 可以通过此方法来设置推送是否前台展示，是否触发声音，是否设置应用角标 badge
    jpush.applyPushAuthority(
        const NotificationSettingsIOS(sound: true, alert: true, badge: true));

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        setState(() {});
      }, onNotifyMessageUnShow: (Map<String, dynamic> message) async {
        print("flutter onNotifyMessageUnShow: $message");
      });
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
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
            initialRoute: '/',
            builder: EasyLoading.init(),
            routes: {
              '/': (context) => Main(),
              '/login': (context) => LoginPage(),
              '/register': (context) => RegisterContent(),
              '/TabHome': (context) => Main(),
            },
          );
        });
  }
}
