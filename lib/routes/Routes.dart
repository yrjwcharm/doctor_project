


import 'package:flutter/material.dart';
import 'package:doctor_project/login_and_regrist/login.dart';
import 'package:doctor_project/login_and_regrist/register.dart';
import 'package:doctor_project/login_and_regrist/register_success.dart';
import 'package:doctor_project/login_and_regrist/setPassword.dart';
import 'package:doctor_project/login_and_regrist/changePas.dart';
import 'package:doctor_project/login_and_regrist/JumpToVideoList.dart';
import 'package:doctor_project/pages/tabs/main.dart';

final routes={

  '/loginP':(context)=>HomeContent(),
  '/register':(context)=>RegisterContent(),
  '/registerSuccess':(context)=>RegisterSuccessHomeConent(),
  '/setPassword':(context)=>settingContent(),
  '/changePas':(context)=>changePas(),
  '/JumpToVideoList':(context)=>MyHomePage(title: ''),
  '/TabHome':(context)=>Main(),


};