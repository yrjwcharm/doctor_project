import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/login/login.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({Key? key}) : super(key: key);

  @override
  _SetNewPasswordState createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  bool isShowPass = false;
  bool _isShowPass = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('设置新密码',onBackPressed: (){
        Navigator.pop(context);
      },),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 40.0),
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('设置新密码',style: GSYConstant.textStyle(fontSize: 24.0,color: '#333333'),),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.6)))
              ),
              child: TextField(
                obscureText: isShowPass?false:true,
                cursorColor: ColorsUtil.hexStringColor('#666666'),
                 style: GSYConstant.textStyle(fontSize: 15.0,color: '#666666'),
                 decoration:InputDecoration(
                   border: InputBorder.none,
                   hintText: '请输入新密码',
                   suffixIconConstraints: const BoxConstraints(),
                   suffixIcon:GestureDetector(
                     onTap: (){
                       setState(() {
                         isShowPass=!isShowPass;
                       });
                     },
                     child: isShowPass?SvgUtil.svg('close_eyes.svg'):SvgUtil.svg('open_eyes.svg'),
                   ),
                   hintStyle: GSYConstant.textStyle(fontSize: 15.0,color: '#999999')
                 ),
              ),
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.6)))
            ),
            child: TextField(
              obscureText: _isShowPass?false:true,
              cursorColor: ColorsUtil.hexStringColor('#666666'),
              style: GSYConstant.textStyle(fontSize: 15.0,color: '#666666'),
              decoration:InputDecoration(
                  border: InputBorder.none,
                  hintText: '请再次输入新密码',
                  suffixIconConstraints: const BoxConstraints(),
                  suffixIcon:GestureDetector(
                    onTap: (){
                      setState(() {
                        _isShowPass=!_isShowPass;
                      });
                    },
                    child:_isShowPass?SvgUtil.svg('close_eyes.svg'):SvgUtil.svg('open_eyes.svg')
                  ),
                  hintStyle: GSYConstant.textStyle(fontSize: 15.0,color: '#999999')
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 12.0),
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('密码为6-18位，且仅为数字，字母或者符号',style: GSYConstant.textStyle(fontSize: 14.0,color: '#999999'),),
          ),
          Container(
            margin: const EdgeInsets.only(top: 55.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomElevatedButton(
              borderRadius: BorderRadius.circular(22.0),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => route == null);
              }, title: '设置完成',

            ),
          )
        ],
      ),
    );
  }
}
