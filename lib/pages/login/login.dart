import 'dart:io';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/api.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/login/verify_mobile.dart';
import 'package:doctor_project/utils/common_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_project/pages/tabs/main.dart';

import '../../utils/reg_util.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterContentStates();
}

class RegisterContentStates extends State<LoginPage> {
  String loginStr = "";
  String loginPas = "";
  bool obscure = true;
  int isSelect = 0;
  bool isChooseTX = false;

  setStatusChoose(bool val) {
    setState(() {
      isChooseTX = val;
    });
  }

  @override
  void postNet_Login() async {
    if(!RegexUtil.isPhone(loginStr)){
      ToastUtil.showToast(msg: '请输入正确手机号');
      return;
    }
    // if(!RegexUtil.isPwd(loginPas)){
    //   ToastUtil.showToast(msg: '密码必须包含字母数字、特殊字符6-16位');
    //   return;
    // }
    if (isSelect == 0) {
      Fluttertoast.showToast(
          msg: '请勾选服务', gravity: ToastGravity.CENTER);
      return;
    }
    var request = HttpRequest.getInstance();
    var res = await request
        .post(Api.loginApi, {'key': loginStr, 'password': loginPas});
    if (res['code'] == 200) {
      String tokenValueStr = res['data']['tokenValue'];
      SharedPreferences perfer = await SharedPreferences.getInstance();
      perfer.setString('phone', loginStr);
      perfer.setString('tokenValue', tokenValueStr);
      String? jpushTokenStr = perfer.getString("jpushToken");
      var result = await request.post(Api.bindJG, {
        "jigId": jpushTokenStr,
        "channel": Platform.isAndroid ? "Android" : "iOS"
      });
      if (result['code'] == 200) {
        ToastUtil.showToast(msg: '登录成功');
        Navigator.pushNamedAndRemoveUntil(context, '/TabHome', (route) => false);
      } else {
        ToastUtil.showToast(msg: result['msg']);
      }
    } else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  //测试代码
  void jpushTest() async {
    var dio = new Dio();

    print(1111111);
    var response =
        await dio.post(Api.BASE_URL + '/doctor/dr-service/push/test', data: {
      "jigId": "141fe1da9e5fd9aea7e",
      "channel": Platform.isAndroid ? "Android" : "iOS",
      "title": "测试",
      "alert": "testtest",
      "type": "recipe"
      //模块（recipe-处方，register-挂号，logistics-物流，text-图文，video-视频）
    });
    print("data= " +
        response.data.toString() +
        "----url= " +
        response.realUri.toString());
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        '',
        onBackPressed: () {
          // SystemNavigator.pop();
          //or exit(0) 退出应用程序
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
                  '登录账号',
                  style: GSYConstant.textStyle(
                      fontFamily: 'Medium',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  '登录享受更精彩',
                  style: GSYConstant.textStyle(fontSize: 13.0),
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
            transform: Matrix4.translationValues(0, -43.0, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            width: double.infinity,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.only(left: 10.0),
                            hintText: '请输入手机号',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 183, 183, 183),
                              fontSize: 14,
                            ),
                          ),
                          onChanged: (Value) {
                            setState(() {
                              loginStr = Value;
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
                  child: const Divider(
                    height: 0.5,
                    indent: 0.0,
                    color: Color.fromARGB(255, 239, 239, 239),
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 7, 16, 0),
                  width: MediaQuery.of(context).size.width - 40,
                ),

                const SizedBox(height: 10),
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Container(
                      child: SvgUtil.svg('pasIcon.svg'),
                      margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      width: 16.0,
                      height: 18,
                    ),
                    Expanded(
                      child: Container(
                        child: Theme(
                          data: ThemeData(primaryColor: Colors.red),
                          child: TextField(
                            obscureText: obscure,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'[\u4e00-\u9fa5]'))
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '请输入登录密码',
                              contentPadding: const EdgeInsets.only(left: 10.0),
                              isCollapsed: true,
                              suffixIconConstraints: const BoxConstraints(),
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    obscure = !obscure;
                                  });
                                },
                                child: SvgUtil.svg(obscure
                                    ? 'close_eyes.svg'
                                    : 'open_eyes.svg'),
                              ),
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 183, 183, 183),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                loginPas = value;
                              });
                            },
                          ),
                        ),
                        width: MediaQuery.of(context).size.width - 61,
                        margin: const EdgeInsets.fromLTRB(5, 0, 16, 0),
                        height: 30,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    // GestureDetector(
                    //   child:SvgUtil.svg(obscure?'open_eyes.svg':'close_eyes.svg'),
                    // )
                  ],
                ),
                Container(
                  child: const Divider(
                    height: 0.5,
                    indent: 0.0,
                    color: Color.fromARGB(255, 239, 239, 239),
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 7, 16, 0),
                  width: MediaQuery.of(context).size.width - 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: FlatButton(
                        child: const Text(
                          '快速注册',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Color.fromARGB(255, 84, 184, 146),
                            fontSize: 14,
                          ),
                        ),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                      ),
                    ),
                    // SizedBox(width: 180),
                    Container(
                      child: FlatButton(
                        child: const Text(
                          '忘记密码?',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Color.fromARGB(255, 183, 183, 183),
                            fontSize: 14,
                          ),
                        ),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const VerifyMobile()));
                          // Navigator.pushNamed(context, '/setPassword');
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: FlatButton(
                          child: const Text(
                            '登录',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            CommonUtils.throttle(postNet_Login,
                                durationTime: 500);
                          },
                        ),
                        margin: const EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width - 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 84, 184, 146),
                          borderRadius: BorderRadius.circular(16),
                        ))
                  ],
                ),
                // SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelect = this.isSelect == 0 ? 1 : 0;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, //横轴居顶对齐
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: isSelect == 0
                                ? const AssetImage('assets/images/checkbox.png')
                                : const AssetImage('assets/images/checkbox-sel.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        margin: const EdgeInsets.fromLTRB(16, 0, 10, 10),
                        width: 16,
                        height: 16,
                      ),
                      // SizedBox(width: 30),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: '我已阅读并同意',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              TextSpan(
                                text: '《用户协议》',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 84, 184, 146),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => {},
                              ),
                              const TextSpan(
                                text: '、',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              TextSpan(
                                text: '《隐私政策》',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 84, 184, 146),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => {},
                              ),
                              const TextSpan(
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
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
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
          child: Text(
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
