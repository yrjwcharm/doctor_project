import 'package:doctor_project/http/api.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/login/set_new_password.dart';
import 'package:doctor_project/pages/my/upate_password.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/style/gsy_style.dart';
import '../../utils/svg_util.dart';

class VerifyOldPwd extends StatefulWidget {
  const VerifyOldPwd({Key? key}) : super(key: key);

  @override
  _VerifyOldPwdState createState() => _VerifyOldPwdState();
}

class _VerifyOldPwdState extends State<VerifyOldPwd> {
  String oldPwd ='';
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('修改密码',onBackPressed: (){
        Navigator.pop(context);
      },),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top:25.0,left: 16.0,right:16.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color:
                        ColorsUtil.hexStringColor('#cccccc', alpha: 0.3)))),
            child: Row(
              children: <Widget>[
                Text('旧密码',style: GSYConstant.textStyle(fontSize: 16.0,color: '#333333'),),
                Expanded(
                  // width: double.infinity,
                child:TextField(
                  obscureText: obscure,
                  onChanged: (value){
                    setState(() {
                      oldPwd = value;
                    });
                  },
                  cursorColor: ColorsUtil.hexStringColor('#666666'),
                  style: GSYConstant.textStyle(fontSize: 15.0, color: '#666666'),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入旧密码',
                      contentPadding: const EdgeInsets.only(left: 30.0),
                      suffixIconConstraints: const BoxConstraints(),
                      suffixIcon: GestureDetector(
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
          SafeAreaButton(margin: const EdgeInsets.only(top: 90.0), text: '下一步', onPressed:() async{
            var res = await HttpRequest.getInstance().post(Api.verifyOldPwdApi, {'password':oldPwd});
            if(res['code']==200){
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>const UpdatePassword()));
            }else{
              ToastUtil.showToast(msg: res['msg']);
            }
          })
        ],
      ),
    );
  }
}
