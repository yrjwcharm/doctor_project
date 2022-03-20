// import 'dart:html';

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctor_project/model/CheckCode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class changePas extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() =>changePasStates();

}

class changePasStates extends State<changePas>
{

  final double fontSi=14;
  var col =Color.fromARGB(255, 81, 81, 81);
  int ClickStutes=0;
  String iphne ="";
  String code="";
  String pas='';
  String pasCof='';
  Checkcode? data;


  setIphone(String val) {
    setState(() {
      iphne = val;
    });
  }
  setcode(String val) {
    setState(() {
      code = val;
    });
  }
  setPas(String val)
  {
    setState(() {
      pas = val;
    });
  }

  setComfPas(String val)
  {
    setState(() {
      pasCof = val;
    });
  }

  void postCheck_code() async {

    var dio = new Dio();
    var response = await dio.post('https://interhospital.youjiankang.net/doctor/dr-service/verificationCode/check',data: {
      "phone": iphne, //手机号
      "type": "reset", //操作类型，register=注册；reset=重置密码
      "code": code //验证码
    });
    // _content = response.data.toString();
    print(response.data.toString()+"checkCode");
    String mess=response.data['msg'];
    if(response.data["code"] != 200) {
      Fluttertoast.showToast(msg: mess,gravity: ToastGravity.CENTER);
      return;
    }else
      {
        setState(() {
          // data = Checkcode.fromJson(response.data['data']);
          ClickStutes=2;
        });
      }

    print(data?.tokenName);
  }
  void postChange_Pas(BuildContext context) async {
    SharedPreferences perfer= await SharedPreferences.getInstance();
    String? tokenValueStr=  perfer.getString('tokenValue');

    var dio = new Dio();
    // Options options = Options(headers: {HttpHeaders.:"accept: application/json"});
    dio.options.headers = {
      "token": tokenValueStr,
    };
    var response = await dio.post('https://interhospital.youjiankang.net/doctor/dr-service/ba-doctor-user/editPwd',data: {
      "password1": pas, //密码
      "password2": pasCof,
    } );
    // _content = response.data.toString();
    print(response.data.toString()+"checkCode");
    String mess=response.data['msg'];
    if(response.data["code"] != 200) {
      Fluttertoast.showToast(msg: mess,gravity: ToastGravity.CENTER);
      return;
    }else
    {
      Fluttertoast.showToast(msg: '修改成功',gravity: ToastGravity.CENTER);
      Navigator.of(context).pop();



    }

    print(data?.tokenName);
  }

  nextStepStatus(){

    print(ClickStutes.toString()+"code"+code);
if(ClickStutes==0)
  {
    fristClick();
  }else if(ClickStutes==1)
    {
      secondClick();
    }else
{
  thirdClick();
}
  }

  bool isChinaPhoneLegal(String str) {
    return new RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$').hasMatch(str);
  }
  fristClick(){
    if(isChinaPhoneLegal(iphne))
      {
        setState(() {
          ClickStutes=1;
        });
      }else
        {
          Fluttertoast.showToast(msg: '手机号码格式不正确',gravity: ToastGravity.CENTER);

          return;
        }
}

secondClick(){
    if(code=='')
      {
        Fluttertoast.showToast(msg: '请输入验证码');
       // Fluttertoast.showToast(msg: '请输入验证码');

      }else

        {
          postCheck_code();

        }



}
thirdClick(){

  if(pas !=pasCof)
  {
    Fluttertoast.showToast(msg: '密码不一致');

  }else
  {
    postChange_Pas(context);

  }

}



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("修改密码",
          style:  TextStyle(color: col,fontSize: fontSi),
        ),
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
      body: Column(
        children: [
          SizedBox(height: 30),
          Offstage(
              offstage: ClickStutes!=0,
              child:  EnterAccountNumberStr(),
          ),
          Offstage(
            offstage: ClickStutes!=2,
            child:  setNewPas(
              setPas
            ),
          ),

          // ,

          Offstage(
            offstage: ClickStutes==2,
            child:  EnterAccountNumber(setIphone),
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


          ClickStutes ==0?SizedBox(height: 0):SizedBox(height: 10),
          Offstage(
            offstage: ClickStutes!=1,
            child:  EnterAccountCodeNumber(
              setcode,
              str1: iphne,
            ) ,
          ),
          Offstage(
            offstage: ClickStutes!=2,
            child:  setNewComfPas(
              setComfPas,
            ),
          ),


          Offstage(
            offstage: ClickStutes==0,
            child:  Container(
              child:Divider(
                height: 1.0,
                indent: 0.0,
                color: Color.fromARGB(255, 239, 239, 239),
              ),
              margin: EdgeInsets.fromLTRB(20, 7, 20, 0),
              width: MediaQuery.of(context).size.width-40,
            ),
          ),
         SizedBox(height: 10),
          netStep(nextStepStatus),
        ],
      ),
    );

  }

}

class EnterAccountNumberStr extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    // TODO: implement buil
    //
    return Container(
      child: Text(
        '请输入您要修改密码的账号',
        style:
        TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 81, 81, 81),
        ),
      ),
      margin: EdgeInsets.fromLTRB(0,0, 0, 0),
      width:MediaQuery.of(context).size.width-40 ,
      height: 30,
    );

  }

}
class EnterAccountCodeNumber extends StatefulWidget
{
  @override
  final String str1;
  Function(String val) setCode;
  EnterAccountCodeNumber(this.setCode,{ Key? key, required this.str1}) : super(key: key);
  State<StatefulWidget> createState() =>EnterAccountCodeNumberStates();

}

class EnterAccountCodeNumberStates extends State<EnterAccountCodeNumber>
{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return Row(

  children: [
    SizedBox(width: 20),

    Text('验证码',style: TextStyle(
      color: Color.fromARGB(255, 81, 81, 81),
      fontSize: 12,
    ),),

    SizedBox(width: 10),
    Expanded(
      flex: 1,
        child: Container(
          child: Theme(data:new ThemeData(primaryColor: Colors.red) , child:TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入短信验证码',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 183, 183, 183),
                ),
              ),
              onChanged:(value){
                setState(() {
                  widget.setCode(value);
                });
              }
          ), ),
          padding: EdgeInsets.fromLTRB(5, 0, 20, 0),
          height: 30,
        ),
    ),


    sendIphoneCode(

      str1: widget.str1,
    ),

    SizedBox(width: 20),

  ],


);
  }

}

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

  @override


  void postNet_3() async {
    PostStr="https://interhospital.youjiankang.net/doctor/dr-service/verificationCode/get?phone="+widget.str1+'&type=reset';
    // FormData formData = new FormData.from({
    //   "username":'15038342183',
    //   "type": "register",
    // });
    var dio = new Dio();
    var response = await dio.get(PostStr);
    // _content = response.data.toString();
    print(widget.str1);
    print(response.data.toString()+""+widget.str1);

  }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) => {
      setState(() {
        if(_timeCount <= 0){
          _autoCodeText = '重新获取';
          _timer?.cancel();
          _timeCount = 60;
        }else {
          _timeCount -= 1;
          _autoCodeText = "$_timeCount" + 's';
        }
      })
    });
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
          onPressed: () {
            print("widget.str1="+widget.str1);
            postNet_3();
            _startTimer();
          },
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
class  EnterAccountNumber extends StatefulWidget
{
  EnterAccountNumber(this.setIphone):super();
  Function(String val) setIphone;
  @override
  State<StatefulWidget> createState() =>EnterAccountNumberStates();

}
class  EnterAccountNumberStates extends State<EnterAccountNumber>
{
  @override


  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         SizedBox(width: 20),
        Text('+86'
        ,style:TextStyle(
            color: Color.fromARGB(255, 81, 81, 81),
            fontSize: 12,
          ),),
        SizedBox(width: 4),
        Container(
          // margin: EdgeInsets.fromLTRB(0,7 , 0, 10),
          child:Image(image: AssetImage("images/2.0x/more@2x.png")) ,
          width: 4,
          height: 7,
        ),
        SizedBox(width: 4),
        Container(
          child: Theme(data:new ThemeData(primaryColor: Colors.red) , child:TextField(
            decoration: InputDecoration(

              border: InputBorder.none,
              hintText: '请输入手机号/用户名',
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 183, 183, 183),
                fontSize: 12,

              ),
            ),
            onChanged: (Value){
              setState(() {
                widget.setIphone(Value);
                // loginStr = Value;
              });

            },

          ),
          ),
          padding:EdgeInsets.fromLTRB(5, 0, 20, 0) ,
          width: MediaQuery.of(context).size.width-100,
          // margin: EdgeInsets.fromLTRB(5, 0, 20, 0),
          height: 30,
        )

      ],

    );
    // TODO: implement build
  }

}

class netStep extends StatelessWidget
{
  netStep(this.nextStepStatus):super();
  Function() nextStepStatus;
  @override


  Widget build(BuildContext context) {

    // TODO: implement build
    return                         Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            child:FlatButton(
              child: Text('下一步',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),

              ),

              textColor: Colors.white,
              onPressed: () {

                nextStepStatus();
                // showDialog(context: context, builder: (BuildContext context) {
                //   return DialogPage();
                // });

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
    );
  }

}

class  setNewPas extends StatefulWidget
{
  setNewPas(this.setPas):super();
  Function(String val) setPas;
  @override
  State<StatefulWidget> createState() =>setNewPasStates();

}
class  setNewPasStates extends State<setNewPas>
{
  bool isCanSee=false;
  @override

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 20),
        Text('新密码'
          ,style:TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),),

        SizedBox(width: 4),

        Expanded(child:         Container(
          child: Theme(data:new ThemeData(primaryColor: Colors.red) , child:TextField(
            decoration: InputDecoration(

              border: InputBorder.none,
              hintText: '请输入新密码',
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 183, 183, 183),
                fontSize: 12,

              ),
              suffixIcon: GestureDetector(
                child: isCanSee==false? Image.asset('images/hidePas.png'):Image.asset('images/showPsa.png'),
                onTap: () {
                  setState(() {
                    isCanSee = !isCanSee;
                    // loginStr = Value;
                  });
                  },
              ),

            ),
            obscureText: !isCanSee,
            onChanged: (Value){
              setState(() {
                widget.setPas(Value);
                // loginStr = Value;
              });

            },

          ),
          ),
          padding:EdgeInsets.fromLTRB(5, 0, 0, 0) ,
          // margin: EdgeInsets.fromLTRB(5, 0, 20, 0),
          height: 30,
        ),)

        // Container(
        //   child:FlatButton(
        //     child: Image.asset('images/2.0x/hidePas@2x.png'),
        //     onPressed: () {
        //       setState(() {
        //         isCanSee = !isCanSee;
        //       });
        //     },
        //   ),
        //   padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
        //   width:20 ,
        //   height: 22,
        // )

      ],

    );
    // TODO: implement build
  }

}

class  setNewComfPas extends StatefulWidget
{
  setNewComfPas(this.setComfPas):super();
  Function(String val) setComfPas;
  @override
  State<StatefulWidget> createState() =>setNewComfPasStates();

}
class  setNewComfPasStates extends State<setNewComfPas>
{
  @override
  bool isCanSee=false;
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 20),
        Text('确认密码'
          ,style:TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),),
        SizedBox(width: 4),

        Expanded(
          flex: 1,
            child: Container(
          child: Theme(data:new ThemeData(primaryColor: Colors.red) , child:TextField(
            decoration: InputDecoration(

              border: InputBorder.none,
              hintText: '请再次输入新密码',
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 183, 183, 183),
                fontSize: 12,

              ),
              suffixIcon: GestureDetector(
                child: isCanSee==false? Image.asset('images/hidePas.png'):Image.asset('images/showPsa.png'),
                onTap: () {
                  setState(() {
                    isCanSee = !isCanSee;
                    // loginStr = Value;
                  });
                },
              ),
            ),
            obscureText: !isCanSee,
            onChanged: (Value){
              setState(() {
                widget.setComfPas(Value);
                // loginStr = Value;
              });

            },

          ),
          ),
          padding:EdgeInsets.fromLTRB(5, 0, 0, 0) ,
          // width: MediaQuery.of(context).size.width-100,
          // margin: EdgeInsets.fromLTRB(5, 0, 20, 0),
          height: 30,
        ) ),


        // Container(
        //
        //   child:FlatButton(
        //
        //     child: Image.asset('images/2.0x/hidePas@2x.png'),
        //     onPressed: () {
        //       setState(() {
        //         isCanSee = !isCanSee;
        //       });
        //       },
        //
        //   ),
        //
        //
        //   padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
        //   width:20 ,
        //   height: 22,
        // )

      ],

    );
    // TODO: implement build
  }

}


// class  setNewPasStr extends StatelessWidget
// {
//   final String phone;
//
//   setNewPasStr({ Key? key,required this.phone}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return
//       Container(
//         margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
//         child: Text.rich(
//           TextSpan(
//             children: [
//               TextSpan(
//                 text: '请为你的账户',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Color.fromARGB(255, 81, 81, 81),
//                 ),
//               ),
//               TextSpan(
//                 text: '+86 '+phone,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black,                                    ),
//
//               ),
//               TextSpan(
//                 text: '\n设置一个新密码',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Color.fromARGB(255, 81, 81, 81),
//                 ),
//               ),
//
//
//             ],
//           ),
//           maxLines: 2,
//         ),
//         height: 40,
//         width: MediaQuery.of(context).size.width,
//         alignment: Alignment.center,
//       );
//     //   Container(
//     //   child: Text('请为你的账户+86 '+phone+'\n设置一个新密码'),
//     //
//     //
//     // );
//   }
// }
//
// class NewPasTF extends StatefulWidget
// {
//   @override
//   State<StatefulWidget> createState() =>NewPasTFState();
//
// }
// class NewPasTFState extends State<NewPasTF>
// {
//   bool isExect=false;
//   bool isShowPas=false;
//
//   @override
//
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Row(
//       children: [
//         Container(
//           child: Theme(data:new ThemeData(primaryColor: Colors.red) , child:TextField(
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               hintText: '请输入登录密码',
//               hintStyle: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(255, 183, 183, 183),
//               ),
//             ),
//             onChanged: (Value){
//               setState(() {
//                 if (Value ==''){
//                   isExect=false;
//
//                 }else
//                   {
//                     isExect=true;
//                     loginPas = Value;
//                   }
//
//
//               });
//             },
//           ), ),
//           width: MediaQuery.of(context).size.width-80,
//           margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
//           height: 30,
//         ),
//
//
//
//         Container(
//           child:FlatButton(
//             child: Image.asset('images/2.0x/hidePas@2x.png'),
//
//             onPressed: () {
//               Navigator.pushNamed(context, '/setPassword');
//             },
//           ),
//           margin: EdgeInsets.fromLTRB(5, 0, 20, 0),
//           width:20 ,
//           height: 22,
//         )
//       ],
//
//
//     );
//   }
//
// }