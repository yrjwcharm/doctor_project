import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/login/login.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../http/api.dart';
import '../../utils/reg_util.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  bool obscure = true;
  bool obscure1 = true;
  String pwd='';
  String _pwd='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        '修改密码',
      
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 16.0,right: 16.0,top: 25.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color:
                            ColorsUtil.hexStringColor('#cccccc', alpha: 0.3)))),
            child: Row(
              children: <Widget>[
                Text('新密码',style: GSYConstant.textStyle(fontSize: 16.0,color: '#333333'),),
                Expanded(child: TextField(
                  obscureText: obscure,
                  onChanged: (value){
                    setState(() {
                      this.pwd = value;
                    });
                  },
                  cursorColor: ColorsUtil.hexStringColor('#666666'),
                  style: GSYConstant.textStyle(fontSize: 15.0, color: '#666666'),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入新密码',
                      contentPadding:  EdgeInsets.only(left: ScreenUtil().setWidth(30.0)),
                      suffixIconConstraints: const BoxConstraints(),
                      suffixIcon: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                        child: obscure
                            ? SvgUtil.svg('close_eyes.svg')
                            : SvgUtil.svg('open_eyes.svg'),
                      ),
                      hintStyle:
                      GSYConstant.textStyle(fontSize: 15.0, color: '#999999')),
                ),)
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color:
                            ColorsUtil.hexStringColor('#cccccc', alpha: 0.3)))),
            child: Row(
              children: <Widget>[
                Text('确认密码',style: GSYConstant.textStyle(fontSize: 16.0,color: '#333333'),),
                Expanded(child: TextField(

                  onChanged: (value){

                    setState(() {
                      this._pwd = value;
                    });
                  },
                  obscureText: obscure1,
                  cursorColor: ColorsUtil.hexStringColor('#666666'),
                  style: GSYConstant.textStyle(fontSize: 15.0, color: '#666666'),
                  decoration: InputDecoration(
                      contentPadding:  EdgeInsets.only(left: ScreenUtil().setWidth(15.0)),
                      border: InputBorder.none,
                      hintText: '请再次输入新密码',
                      suffixIconConstraints: const BoxConstraints(),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscure1 = !obscure1;
                            });
                          },
                          child: obscure1
                              ? SvgUtil.svg('close_eyes.svg')
                              : SvgUtil.svg('open_eyes.svg')),
                      hintStyle:
                      GSYConstant.textStyle(fontSize: 15.0, color: '#999999')),
                ),)
              ],
            ), 
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 12.0),
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '密码为6-16位，必须包含字母、数字、特殊字符',
              style: GSYConstant.textStyle(fontSize: 14.0, color: '#999999'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 55.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomElevatedButton(
              borderRadius: BorderRadius.circular(22.0),
              onPressed: () async {
               // if(!RegexUtil.isPwd(pwd)){
               //   ToastUtil.showToast(msg: '密码输入格式有误');
               //   return;
               // }
               if(pwd!=_pwd){
                 ToastUtil.showToast(msg: '请确认密码');
                 return;
               }
               SharedPreferences preference = await SharedPreferences.getInstance();
                var res = await HttpRequest.getInstance().post(Api.updatePwdApi, {
                  "password1":pwd , //密码
                  "password2": _pwd
                });
                if(res['code']==200){
                  preference.remove('tokenValue');
                  preference.remove('phone');
                  ToastUtil.showToast(msg: '修改成功，请您重新登录');
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => route == null);
                }else{
                  ToastUtil.showToast(msg: res['msg']);
                }
              },
              title: '提交',
            ),
          )
        ],
      ),
    );
  }
}
