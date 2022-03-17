import 'package:flutter/material.dart';
import 'package:doctor_project/pages/tabs/main.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'routes/Routes.dart';

void main()
{
  runApp(MyApp() );
}
//自定义组建
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
        debugShowCheckedModeBanner: false, // 设置这一属性即可
        home:Main(),
        routes:routes,

      //   void main()  {
      // runApp(const MaterialApp(
      //   home: Main(),
      // ));
      // if (Platform.isAndroid) {
      //   //设置Android头部的导航栏透明
      //   SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      //       statusBarColor: Colors.transparent, //全局设置透明
      //       statusBarIconBrightness: Brightness.dark
      //     //light:黑色图标 dark：白色图标
      //     //在此处设置statusBarIconBrightness为全局设置
      //   );
      //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      // }


    );
  }

}

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//
//
//   void _goToHealthHutModular() async {
//     const platform = const MethodChannel("flutterPrimordialBrige");
//     bool result = false;
//     try {
//       result = await platform.invokeMethod("jumpToCallVideo"); //分析2
//     } on PlatformException catch (e) {
//       print(e.toString());
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           children: [
//             FlatButton(
//                 onPressed:() {
//                   _goToHealthHutModular();
//                 },
//                 child:Text('视频聊天',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontSize: 13,
//                   ),
//                 )
//             ),
//             FlatButton(
//                 onPressed:() {
//                   _goToHealthHutModular();
//                 },
//                 child:Text('图文问诊',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontSize: 13,
//                   ),
//                 )
//             ),
//           ],
//         ),
//
//       ),
//     );
//   }
// }


// void main() async {
//
//
//   /// 确保初始化
//   WidgetsFlutterBinding.ensureInitialized();
//
//   /// 数据初始化
//   await Data.initData();
//   /// 配置初始化
//   await StorageManager.init();
//   /// APP入口并配置Provider
//   runApp(ProviderConfig.getInstance().getGlobal(MyApp()));
//   /// 自定义报错页面
//   ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
//     debugPrint(flutterErrorDetails.toString());
//     return new Center(child: new Text("App错误，快去反馈给作者!"));
//   };
//   /// Android状态栏透明
//   if (Platform.isAndroid) {
//     SystemUiOverlayStyle systemUiOverlayStyle =
//     SystemUiOverlayStyle(statusBarColor: Colors.transparent);
//     SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
//   }
// }