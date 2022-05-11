import 'dart:async';

import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/reg_util.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/style/gsy_style.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../http/api.dart';
import '../../widget/custom_app_bar.dart';

class RegisterContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterContentStates();
}

class RegisterContentStates extends State<RegisterContent> {
  // TextEditingController iphoneTFController = new TextEditingController();//声明controller
  String iphoneStr = "";
  String loginPas = "";
  String code = "";
  int isSelect = 0;
  bool isChooseTX = false;
  bool obscure = true;

  setStatusChoose(bool val) {
    setState(() {
      isChooseTX = val;
    });
  }

  @override
  bool isPasTure(String str) {
    return new RegExp(
            '^(?![A-Za-z0-9]+\$)(?![a-z0-9\\W]+\$)(?![A-Za-z\\W]+\$)(?![A-Z0-9\\W]+\$)[a-zA-Z0-9\\W]{6,16}\$')
        .hasMatch(str);
  }

  void postNet_register() async {
    // FormData formData = new FormData.from({
    //   "phone":iphoneStr,
    //   "password": loginPas,
    //   "code": code,
    // });
    var dio = Dio();
    if (!RegexUtil.isPwd(loginPas)) {
      ToastUtil.showToast(msg: '密码必须包含字母和数字和特殊字符,6-16');
      return;
    }
    var response = await dio.post(
        Api.BASE_URL + '/doctor/dr-service/ba-doctor-user/register',
        data: {
          "phone": iphoneStr,
          "password": loginPas,
          "code": code,
        });

    String mess = response.data['msg'];

    if (response.data['code'] != 160) {
      Fluttertoast.showToast(msg: mess, gravity: ToastGravity.CENTER);
    } else {
      Fluttertoast.showToast(msg: mess, gravity: ToastGravity.CENTER);
      Navigator.of(context).pop();
    }

    print(iphoneStr + loginPas + code);
    // _content = response.data.toString();
    print(response.data.toString() + "");

    // Navigator.pushNamed(context, '/registerSuccess');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        '',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 16.0, top: 32.0),
            height: 157.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/background.png',
                  ),
                  fit: BoxFit.cover
                  // fit: BoxFit.cover,
                  ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '欢迎注册',
                  style: GSYConstant.textStyle(
                      fontFamily: 'Medium',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 4.0,
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            transform: Matrix4.translationValues(0, -43.0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Container(
                      child: SvgUtil.svg('userIcon.svg'),
                      margin: EdgeInsets.fromLTRB(16, 30, 0, 0),
                      width: 16.0,
                      height: 18,
                    ),
                    Container(
                      child: Theme(
                        data: new ThemeData(primaryColor: Colors.red),
                        child: TextField(
                          // controller: iphoneTFController,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.only(left: 10.0),
                            border: InputBorder.none,
                            hintText: '请输入手机号',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 183, 183, 183),
                              fontSize: 14,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              iphoneStr = value;
                            });
                          },
                        ),
                      ),
                      width: MediaQuery.of(context).size.width - 61,
                      margin: EdgeInsets.fromLTRB(5, 30, 10, 0),
                      height: 30,
                      alignment: Alignment.centerLeft,
                    )
                  ],
                ),
                Container(
                  child: Divider(
                    height: 1.0,
                    indent: 0.0,
                    color: Color.fromARGB(255, 239, 239, 239),
                  ),
                  margin: EdgeInsets.fromLTRB(16, 7, 16, 0),
                  width: MediaQuery.of(context).size.width - 40,
                ),
                SizedBox(height: 10),
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Container(
                      child: SvgUtil.svg(
                        'pasIcon.svg',
                      ),
                      margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      width: 16.0,
                      height: 18,
                    ),
                    Container(
                      child: Theme(
                        data: new ThemeData(primaryColor: Colors.red),
                        child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: const EdgeInsets.only(left: 10.0),
                              hintText: '请输入短信验证码',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 183, 183, 183),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                code = value;
                              });
                            }),
                      ),
                      width: MediaQuery.of(context).size.width - 61 - 116,
                      margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                      height: 30,
                      alignment: Alignment.centerLeft,
                    ),
                    sendIphoneCode(
                      str1: iphoneStr,
                    ),
                  ],
                ),
                Container(
                  child: Divider(
                    height: 1.0,
                    indent: 0.0,
                    color: Color.fromARGB(255, 239, 239, 239),
                  ),
                  margin: EdgeInsets.fromLTRB(16, 7, 16, 0),
                  width: MediaQuery.of(context).size.width - 40,
                ),

                SizedBox(height: 10),
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Container(
                      child: SvgUtil.svg('pasIcon.svg'),
                      margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      width: 16.0,
                      height: 18,
                    ),
                    Container(
                      child: Theme(
                        data: new ThemeData(primaryColor: Colors.red),
                        child: TextField(
                            obscureText: obscure,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              suffixIconConstraints: const BoxConstraints(),
                              suffixIcon:GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      obscure =!obscure;
                                    });
                                  },
                                  child: SvgUtil.svg(obscure?'open_eyes.svg':'close_eyes.svg')),
                              contentPadding: const EdgeInsets.only(left: 10.0),
                              border: InputBorder.none,
                              hintText: '请输入登录密码（6-16位数字大小写字母符号组合）',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 183, 183, 183),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                loginPas = value;
                              });
                            }),
                      ),
                      width: MediaQuery.of(context).size.width - 61,
                      margin: EdgeInsets.fromLTRB(5, 0, 16, 0),
                      height: 30,
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
                Container(
                  child: Divider(
                    height: 1.0,
                    indent: 0.0,
                    color: Color.fromARGB(255, 239, 239, 239),
                  ),
                  margin: EdgeInsets.fromLTRB(16, 7, 16, 0),
                  width: MediaQuery.of(context).size.width - 40,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // SizedBox(width: 180),
                    // Container(
                    //   child:FlatButton(
                    //     child: Text('忘记密码?',
                    //       textAlign: TextAlign.end,
                    //       style: TextStyle(
                    //         color: Color.fromARGB(255, 183, 183, 183),
                    //         fontSize: 12,
                    //       ),
                    //     ),
                    //     textColor: Colors.white,
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, '/setPassword');
                    //     },
                    //   ),
                    // )
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: FlatButton(
                          child: Text(
                            '立即注册',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            // if(isPasTure(loginPas)){
                            //   Fluttertoast.showToast(msg: '密码格式需包含数字，字母以及字符大小写',gravity: ToastGravity.CENTER);
                            //   return;
                            // }
                            if (isSelect == 0) {
                              Fluttertoast.showToast(
                                  msg: '请勾选服务', gravity: ToastGravity.CENTER);
                              return;
                            }
                            postNet_register();
                          },
                        ),
                        margin: EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width - 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 84, 184, 146),
                          borderRadius: BorderRadius.circular(16),
                        ))
                  ],
                ),
                // SizedBox(height: 16),
                GestureDetector(
                  onTap: (){
                    isSelect= this.isSelect==0?1:0;
                   setState(() {

                   });
                  },
                  child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start, //横轴居顶对齐

                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 10, 10),
                       decoration: BoxDecoration(
                         image: DecorationImage(
                           image: isSelect == 0
                               ? AssetImage('assets/images/checkbox.png')
                               : AssetImage('assets/images/checkbox-sel.png'),
                           fit: BoxFit.cover,
                         ),
                       ),
                      width: 16,
                      height: 16,
                    ),
                    // SizedBox(width: 30),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '我已阅读并同意',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            TextSpan(
                              text: '《用户协议》',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 84, 184, 146),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => {},
                            ),
                            TextSpan(
                              text: '、',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            TextSpan(
                              text: '《隐私政策》',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 84, 184, 146),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => {},
                            ),
                            TextSpan(
                              text: '并授权使用该账号信息（如昵称、头像）进行统一管理',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 3,
                      ),
                      height: 40,
                      width: MediaQuery.of(context).size.width - 40 - 36,
                    )
                  ],
                ),)
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// class RegisterContent extends StatelessWidget{
//   // Future _openAlertDialog() async {
//   //
//   // }
//
//   TextEditingController iphoneTFController = new TextEditingController();//声明controller
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
//
// }

class sendIphoneCode extends StatefulWidget {
  final String str1;

  sendIphoneCode({Key? key, required this.str1}) : super(key: key);

  @override
  State<StatefulWidget> createState() => sendIphoneCodeStates();
}

class sendIphoneCodeStates extends State<sendIphoneCode> {
  Timer? _timer;
  int _timeCount = 60;
  String _autoCodeText = '发送验证码';
  String PostStr = '';
  bool buttonDisabled = false;

  @override
  void postNet_3() async {
    setState(() {
      buttonDisabled = true;
    });
    PostStr = Api.BASE_URL +
        "/doctor/dr-service/verificationCode/get?phone=" +
        widget.str1 +
        '&type=register';

    // FormData formData = new FormData.from({
    //   "username":'15038342183',
    //   "type": "register",
    // });
    var dio = new Dio();

    var response = await dio.get(PostStr);
    // _content = response.data.toString();
    _startTimer();
    print(widget.str1);
    print(response.data.toString() + "" + widget.str1);
  }

  void _startTimer() {
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => {
              setState(() {
                if (_timeCount <= 0) {
                  _autoCodeText = '重新获取';
                  _timer?.cancel();
                  _timeCount = 60;
                  setState(() {
                    buttonDisabled = false;
                  });
                } else {
                  _timeCount -= 1;
                  _autoCodeText = "$_timeCount" + 's';
                }
              })
            });
  }

  bool isChinaPhoneLegal(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  Widget build(BuildContext context) {
    return CustomOutlineButton(
          width: 90.0,
          height: 27.0,
          title: _autoCodeText,
           textStyle: GSYConstant.textStyle(
              color: '#09BB8F',
              fontSize: 13.0,
            ),
          borderRadius: BorderRadius.circular(14.0),
          borderColor: ColorsUtil.hexStringColor('#09BB8F'),
          onPressed:(){
            if(!buttonDisabled){
              if (isChinaPhoneLegal(widget.str1) == true) {
              } else {
                Fluttertoast.showToast(
                    msg: '手机号码格式不正确', gravity: ToastGravity.CENTER);
                return;
              }
              print("widget.str1=" + widget.str1);
              postNet_3();
            }
          });
    // TODO: implement build
  }
}
class DialogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DialogPageState();
}

class DialogPageState extends State<DialogPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoAlertDialog(
      title: Text(
        "未注册",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        "\n当前手机号${1500000000}未注册\n请先联系管理员进行注册\n",
        style: TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 126, 126, 126),
        ),
      ),
      actions: [
        FlatButton(
          child: const Text(
            "取消",
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 74, 74, 74),
            ),
          ),
          onPressed: () {
            Navigator.pop(context, 'Cancle');
          },
        ),
      ],
    );
  }
}
