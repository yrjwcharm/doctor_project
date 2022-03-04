import 'package:flutter/material.dart';
import 'package:doctor_project/pages/tabs/main.dart';
import 'dart:io';

import 'package:flutter/services.dart';

void main()  {
      runApp(const MaterialApp(
        home: Main(),
      ));
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
}
