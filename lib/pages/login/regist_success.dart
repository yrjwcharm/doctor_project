import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterSuccess extends StatefulWidget {
  const RegisterSuccess({Key? key}) : super(key: key);

  @override
  _RegisterSuccessState createState() => _RegisterSuccessState();
}

class _RegisterSuccessState extends State<RegisterSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('注册成功',),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 52.0,),
          SvgUtil.svg('success.svg'),
          Container(
            margin: const EdgeInsets.only(top: 28.0),
            child: Text('恭喜您成功注册',style: GSYConstant.textStyle(fontSize: 16.0,color: '#333333'),),
          ),
          Container(
            margin: const EdgeInsets.only(top: 9.0),
            child: Text('需完善个人信息认证才能继续使用',style: GSYConstant.textStyle(fontSize: 14.0,color:'#888888' ),),
          ),
          Container(
            margin: const EdgeInsets.only(top: 120.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomElevatedButton(onPressed: () {

            },title: '医师认证',borderRadius: BorderRadius.circular(22.0),),
          )
        ],
      ),
    );
  }
}
