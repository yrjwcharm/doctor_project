import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/login/set_new_password.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widget/code_input_row.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({Key? key}) : super(key: key);

  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final TextEditingController _controller = TextEditingController(text: '');
  String _code = '';
  final int _length = 6; //验证码长度，输入框框的个数
  final _type = CodeInputType.squareBox;
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
            child:Text('验证码已发送至+86 176 6774 3453',style: GSYConstant.textStyle(fontSize: 12.0,color: '#333333'),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 16.0),
            child: Stack(
              children: <Widget>[
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InputCell(isFocused: _code.length == 0, text: _code.length>=1?_code.substring(0,1):''),
                    InputCell(isFocused: _code.length == 1, text: _code.length>=2?_code.substring(1,2):''),
                    InputCell(isFocused: _code.length == 2, text: _code.length>=3?_code.substring(2,3):''),
                    InputCell(isFocused: _code.length == 3, text: _code.length>=4?_code.substring(3,4):''),
                    InputCell(isFocused: _code.length == 4, text: _code.length>=5?_code.substring(4,5):''),
                    InputCell(isFocused: _code.length == 5, text: _code.length>=6?_code.substring(5,6):'',),
                  ],
                )*/

                ///[CodeInputRow]其实就是上面这段注释的代码里的Row封装一下
                //验证码输入框整行，
                CodeInputRow(code: _code, length: _length, type: _type),
                Opacity(
                  opacity: 0,
                  child: TextField(
                    //只能输入字母与数字
                    inputFormatters: [
                      // FilteringTextInputFormatter.allow(filterPattern)
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    controller: _controller,
                    onChanged: (String str) {
                      _code = str;
                      setState(() {});
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
            child: CustomElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SetNewPassword()));
            }, title: '立即设置密码',borderRadius: BorderRadius.circular(22.0),),
          )
        ],
      ),
    );
  }
}