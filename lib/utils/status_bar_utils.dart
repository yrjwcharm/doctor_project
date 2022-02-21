import 'dart:ui';

import 'package:flutter/cupertino.dart';
class StatusBarUtil{
  static get(BuildContext context){
    return MediaQuery.of(context).padding.top;
  }
}