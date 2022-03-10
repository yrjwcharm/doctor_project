import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key,  this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  void _goToHealthHutModular() async {
    const platform = const MethodChannel("flutterPrimordialBrige");
    bool result = false;
    try {
      result = await platform.invokeMethod("jumpToCallVideo"); //分析2
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            FlatButton(
                onPressed:() {
                  _goToHealthHutModular();
                },
                child:Text('视频聊天',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                )
            ),
            FlatButton(
                onPressed:() {
                  _goToHealthHutModular();
                },
                child:Text('图文问诊',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                )
            ),
          ],
        ),

      ),
    );
  }
}
