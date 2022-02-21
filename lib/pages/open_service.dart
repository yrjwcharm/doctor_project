import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpenService extends StatefulWidget {
  const OpenService({Key? key}) : super(key: key);

  @override
  _OpenServiceState createState() => _OpenServiceState();
}

class _OpenServiceState extends State<OpenService> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '开通服务',
      theme: ThemeData(
        backgroundColor: Colors.white,
      ),
      home: Scaffold(
        body: Column(
          children: const [
            CustomAppBar('开通服务',isBack: true)
          ],
        )
      ),
    );
  }
}
