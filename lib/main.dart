import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doctor_project/login_and_regrist/login.dart';
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
      debugShowCheckedModeBanner: false, // 设置这一属性即可
      home: HomeContent(),
      routes:routes,



    );
    HomeContent();
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