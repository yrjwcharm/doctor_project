import 'dart:async';

import 'package:doctor_project/utils/regex_util.dart';
import 'package:doctor_project/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import '../../routes/Routes.dart';
import 'package:dio/dio.dart';
// import 'package:garbagecan/passwordCheck/setPassword.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RegisterContent extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>RegisterContentStates();

}

class RegisterContentStates extends State<RegisterContent>
{
  // TextEditingController iphoneTFController = new TextEditingController();//声明controller
   String iphoneStr="";
   String loginPas="";
   String code="";

   bool isChooseTX=false;

   setStatusChoose(bool val) {
     setState(() {
       isChooseTX = val;
     });
   }

  @override

  bool isPasTure(String str) {
    return new RegExp('^(?![A-Za-z0-9]+\$)(?![a-z0-9\\W]+\$)(?![A-Za-z\\W]+\$)(?![A-Z0-9\\W]+\$)[a-zA-Z0-9\\W]{6,20}\$').hasMatch(str);
  }

  void postNet_register() async {

    // FormData formData = new FormData.from({
    //   "phone":iphoneStr,
    //   "password": loginPas,
    //   "code": code,
    // });
    var dio = new Dio();
    if(!RegexUtil.isPwd(loginPas)){
       ToastUtil.showToast(msg: '密码必须包含字母和数字和特殊字符,6-20');
       return;
    }
    var response = await dio.post('https://interhospital.youjiankang.net/doctor/dr-service/ba-doctor-user/register',data:{
      "phone":iphoneStr,
      "password": loginPas,
      "code": code,
    });

    String mess=response.data['msg'];

    if(response.data['code']!=200)
    {
      Fluttertoast.showToast(msg: mess,gravity: ToastGravity.CENTER);
      return;
    }else
    {
      Fluttertoast.showToast(msg: mess,gravity: ToastGravity.CENTER);
      Navigator.of(context).pop();
    }

    print(iphoneStr+loginPas+code);
    // _content = response.data.toString();
    print(response.data.toString()+"");

    // Navigator.pushNamed(context, '/registerSuccess');

  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.white,
          leading: Container(      decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('images/back.png'),
              fit: BoxFit.scaleDown,
            ),
          ),
            child:  FlatButton(
              child:Text(""),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
          ),
        ),
        body:
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image:DecorationImage(
              image: AssetImage('images/2.0x/LoginbackGrond@2x.png'),
              fit: BoxFit.cover,
            ) ,
          ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                textDirection:TextDirection.ltr ,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 30,
                    margin: EdgeInsets.fromLTRB(20, 45, 0, 0),
                    alignment: Alignment.topLeft,
                    decoration: new BoxDecoration(
                    ),
                    child:Text('欢迎注册',textDirection: TextDirection.ltr,
                      textAlign:TextAlign.left ,
                      style:TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ) ,
                    ),
                  )
                ],
              ),
              Row(
                textDirection:TextDirection.ltr ,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 20,
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    alignment: Alignment.topLeft,
                    decoration: new BoxDecoration(
                      // color: Colors.grey,
                    ),
                    child:Text('',textDirection: TextDirection.ltr,
                      textAlign:TextAlign.left ,
                      style:TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ) ,
                    ),
                  )
                ],
              ),
              SizedBox(height: 25),
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          textDirection:TextDirection.ltr ,
                          children: [
                            Container(
                              child: Image.asset('images/2.0x/userIcon@2x.png',
                              ),
                              margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
                              width: 16.0,
                              height: 18,
                            ),
                            SizedBox(width: 5),
                            Container(

                              child: Theme(data:new ThemeData(primaryColor: Colors.red) , child:TextField(
                                // controller: iphoneTFController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '请输入手机号',
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 183, 183, 183),
                                    fontSize: 14,
                                  ),
                                ),
                                onChanged:(value){
                                  setState(() {
                                    iphoneStr=value;
                                  });
                                } ,
                              ), ),
                              width: MediaQuery.of(context).size.width-61,
                              margin: EdgeInsets.fromLTRB(5, 30, 10, 0),
                              height: 30,
                            )
                          ],
                        ),
                        Container(
                          child:Divider(
                            height: 1.0,
                            indent: 0.0,
                            color: Color.fromARGB(255, 239, 239, 239),
                          ),
                          margin: EdgeInsets.fromLTRB(20, 7, 20, 0),
                          width: MediaQuery.of(context).size.width-40,
                        ),
                        SizedBox(height: 10),
                        Row(
                          textDirection:TextDirection.ltr ,
                          children: [
                            Container(
                              child: Image.asset('images/2.0x/pasIcon@2x.png',
                              ),
                              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              width: 16.0,
                              height: 18,
                            ),
                            SizedBox(width: 10),
                            Container(
                              child: Theme(data:new ThemeData(primaryColor: Colors.red) , child:TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '请输入短信验证码',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 183, 183, 183),
                                  ),
                                ),
                                  onChanged:(value){
                                    setState(() {
                                      code=value;
                                    });
                                  }
                              ), ),
                              width: MediaQuery.of(context).size.width-61-120,
                              margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                              height: 30,
                            ),

                            sendIphoneCode(

                              str1: iphoneStr,
                            ),

                          ],
                        ),
                        Container(
                          child:Divider(
                            height: 1.0,
                            indent: 0.0,
                            color: Color.fromARGB(255, 239, 239, 239),
                          ),
                          margin: EdgeInsets.fromLTRB(20, 7, 20, 0),
                          width: MediaQuery.of(context).size.width-40,
                        ),

                        SizedBox(height: 10),
                        Row(
                          textDirection:TextDirection.ltr ,
                          children: [
                            Container(
                              child: Image.asset('images/2.0x/pasIcon@2x.png',
                              ),
                              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              width: 16.0,
                              height: 18,
                            ),
                            SizedBox(width: 10),
                            Container(
                              child: Theme(data:new ThemeData(primaryColor: Colors.red) , child:TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '请输入登录密码（6-16位数字字母组合密码）',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 183, 183, 183),
                                  ),
                                ),
                                  onChanged:(value){
                                    setState(() {
                                      loginPas=value;
                                    });
                                  }
                              ), ),
                              width: MediaQuery.of(context).size.width-61,
                              margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                              height: 30,
                            ),
                          ],
                        ),
                        Container(
                          child:Divider(
                            height: 1.0,
                            indent: 0.0,
                            color: Color.fromARGB(255, 239, 239, 239),
                          ),
                          margin: EdgeInsets.fromLTRB(20, 7, 20, 0),
                          width: MediaQuery.of(context).size.width-40,
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
                                child:FlatButton(
                                  child: Text('立即注册',
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
                                    if(isChooseTX==false)
                                    {
                                      Fluttertoast.showToast(msg: '请勾选服务',gravity: ToastGravity.CENTER);
                                      return;

                                    }
                                    postNet_register();

                                  },
                                ),
                                margin: EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width-40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 84, 184, 146),
                                  borderRadius: BorderRadius.circular(20),
                                )


                            )

                          ],
                        ),
                        // SizedBox(height: 20),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, //横轴居顶对齐

                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 10, 10),
                              child:singChooseBtn(setStatusChoose) ,
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
                                        color: Color.fromARGB(255, 84, 184, 146),                                    ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>{

                                        },
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
                                        color: Color.fromARGB(255, 84, 184, 146),                                    ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                        {

                                        },
                                    ),
                                    TextSpan(
                                      text:
                                      '并授权使用该账号信息（如昵称、头像）进行统一管理',
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
                              width: MediaQuery.of(context).size.width-40-36,

                            )


                          ],
                        )

                      ],

                    ),

                  )
              ),

            ],

          ),

        )
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

class sendIphoneCode extends StatefulWidget
{
  final String str1;

sendIphoneCode({ Key? key, required this.str1}) : super(key: key);
  @override

  State<StatefulWidget> createState() => sendIphoneCodeStates();

}

class sendIphoneCodeStates extends State<sendIphoneCode>
{

   Timer? _timer;
  int _timeCount = 60;
  String _autoCodeText='发送验证码';
  String PostStr='';
  bool buttonDisabled = false;
  @override
  void postNet_3() async {
    setState(() {
      buttonDisabled = true;
    });
    PostStr="https://interhospital.youjiankang.net/doctor/dr-service/verificationCode/get?phone="+widget.str1+'&type=register';

    // FormData formData = new FormData.from({
    //   "username":'15038342183',
    //   "type": "register",
    // });
    var dio = new Dio();

    var response = await dio.get(PostStr);
    // _content = response.data.toString();
    _startTimer();
    print(widget.str1);
    print(response.data.toString()+""+widget.str1);

  }
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) => {
      setState(() {
        if(_timeCount <= 0){
          _autoCodeText = '重新获取';
          _timer?.cancel();
          _timeCount = 60;
          setState(() {
            buttonDisabled = false;
          });
        }else {
          _timeCount -= 1;
          _autoCodeText = "$_timeCount" + 's';
        }
      })
    });
  }
  bool isChinaPhoneLegal(String str) {
    return new RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$').hasMatch(str);
  }

  Widget build(BuildContext context) {
    return  Container(
        child:FlatButton(
          child: Text(_autoCodeText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 84, 184, 146),
              fontSize: 13,
            ),

          ),

          textColor: Color.fromARGB(255, 84, 184, 146),
          onPressed:!buttonDisabled ? () {
            if(isChinaPhoneLegal(widget.str1)==true)
              {

              }else
                {
                  Fluttertoast.showToast(msg: '手机号码格式不正确',gravity: ToastGravity.CENTER);
                  return;

                }

            print("widget.str1="+widget.str1);
            postNet_3();
          }:null,
        ),
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          // color: Color.fromARGB(255, 84, 184, 146),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color.fromARGB(255, 84, 184, 146), width: 1),
        )

    );
    // TODO: implement build
  }

}

class singChooseBtn extends StatefulWidget
{
  singChooseBtn(this.isChooseTx):super();
  Function(bool val) isChooseTx;
  @override
  State<StatefulWidget> createState()=> singChooseBtnStates();
}
class singChooseBtnStates extends State<singChooseBtn>
{
   int  isSelect=0;

  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: this.isSelect==0?AssetImage('images/2.0x/check box@2x.png'):AssetImage('images/2.0x/check box-select@2x.png'),
          fit: BoxFit.cover,
        ),
      ),

      child:
      FlatButton(
        child:Text(""),
        onPressed: () {
          setState(() {
            isSelect=this.isSelect==0?1:0;
            if(isSelect==0)
            {
              widget.isChooseTx(false);



            }else
            {
              widget.isChooseTx(true);
            }

          });
        },
      ),

    );
  }
}


class  DialogPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>DialogPageState();

}


class DialogPageState extends State<DialogPage>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoAlertDialog(
      title: Text("未注册",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),),
      content: Text("\n当前手机号${1500000000}未注册\n请先联系管理员进行注册\n",
        style: TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 126, 126, 126),
        ),),
      actions: [
        FlatButton(
          child: Text("取消",
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 74, 74, 74),
            ),
          ),
          onPressed: (){
            Navigator.pop(context,'Cancle');
          },
        ),
      ],
    );
  }

}



