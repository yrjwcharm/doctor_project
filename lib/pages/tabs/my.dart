import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class My extends StatefulWidget {
  const My({Key? key}) : super(key: key);

  @override
  MyState createState() => MyState();
}

class MyState extends State<My> {
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(
        child: Text('my'),
      ),
    );
  }
}
