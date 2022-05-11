import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/api.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/login/set_new_password.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widget/code_input_row.dart';

class VerifyCode extends StatefulWidget {
   const VerifyCode({Key? key, required this.phone}) : super(key: key);
  final String phone;
  @override
  _VerifyCodeState createState() => _VerifyCodeState(this.phone);
}

class _VerifyCodeState extends State<VerifyCode> {
  final TextEditingController _controller = TextEditingController(text: '');
  String _code = '';
  final FocusNode _focusNode = FocusNode();
  final int _length = 6; //验证码长度，输入框框的个数
  final _type = CodeInputType.squareBox;
  final String phone;
  _VerifyCodeState(this.phone);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        '验证码',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 40.0,left: 16.0),
            child: Text('输入验证码',style: GSYConstant.textStyle(fontSize: 24.0,color: '#333333'),),
          ),
          const SizedBox(height: 9.0,),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 16.0),
            child:Text('验证码已发送至+86 $phone',style: GSYConstant.textStyle(fontSize: 12.0,color: '#333333'),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 16.0),
            child: Stack(
              children: <Widget>[
                ///[CodeInputRow]其实就是上面这段注释的代码里的Row封装一下
                //验证码输入框整行，
                CodeInputRow(code: _code, length: _length, type: _type),
                Opacity(
                  opacity: 0,
                  child: TextField(
                    //只能输入字母与数字
                    focusNode: _focusNode,
                    inputFormatters: [
                      // FilteringTextInputFormatter.allow(filterPattern)
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    controller: _controller,
                    onChanged: (String str) {
                      _code = str;
                      setState(() {

                      });
                      if(str.length==_length){
                         _focusNode.unfocus();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12.0),
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('接收短信大约需要20秒，请耐心等待',style: GSYConstant.textStyle(fontSize: 12.0,color: '#999999'),),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 13.0,left: 16.0),
            child: Text('59 秒后可重新获取短信验证码',style: GSYConstant.textStyle(fontSize: 12.0,color: '#666666'),),
          ),
          Container(
            margin: const EdgeInsets.only(top: 75.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomElevatedButton(onPressed: () async{
              var res = await HttpRequest.getInstance().post(Api.checkVerifyCode,
                  {"phone": phone, //手机号
                  "type": "reset", //操作类型，register=注册；reset=重置密码
                  "code": _code});
              if(res['code']==200) {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SetNewPassword()));
              }
            }, title: '立即设置密码',borderRadius: BorderRadius.circular(22.0),),
          )
        ],
      ),
    );
  }
}