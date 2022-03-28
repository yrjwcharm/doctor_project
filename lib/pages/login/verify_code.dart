import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/login/set_new_password.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({Key? key}) : super(key: key);

  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFifth = TextEditingController();
  final TextEditingController _fieldSixth = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OtpInput(_fieldOne, true),
                  OtpInput(_fieldTwo, false),
                  OtpInput(_fieldThree, false),
                  OtpInput(_fieldFour, false),
                  OtpInput(_fieldFifth, false),
                  OtpInput(_fieldSixth, false)
                ]),
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

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;

  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 47.0,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1.0, color: ColorsUtil.hexStringColor('#999999')))),
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: [],
        decoration: InputDecoration(
            border: InputBorder.none,
            counterText: '',
            hintStyle: GSYConstant.textStyle(fontSize: 20.0, color: '#333333')),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
