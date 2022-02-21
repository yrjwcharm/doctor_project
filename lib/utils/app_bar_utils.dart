
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/status_bar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarUtil{
  static AppBar buildAppBar(BuildContext context,String title) {
    return AppBar(
      title: Text(title),
      titleTextStyle:TextStyle(
        fontSize:16.0,
        fontFamily: 'PingFangSC-Regular, PingFang SC',
        fontWeight: FontWeight.w400,
        color: ColorsUtil.hexStringColor('#333333'),
        //   font-family: PingFangSC-Regular, PingFang SC;
        // font-weight: 400;
        // color: #333333;
      ),
      backgroundColor: Colors.white,
    ) ;
  }
  static Widget  customAppBar(BuildContext context,String title){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top:StatusBarUtil.get(context)),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        child:  Text(title,style:GSYConstant.textStyle(fontSize:16.0 ,color: '#333333')),
      ),
    );
  }
}

