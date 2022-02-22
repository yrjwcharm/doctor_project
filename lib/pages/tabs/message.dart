import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
           CustomAppBar('消息')
        ],
      )
    );
  }
}
