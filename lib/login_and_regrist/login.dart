import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import '../../routes/Routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_project/pages/tabs/main.dart';

// import 'package:garbagecan/passwordCheck/setPassword.dart';

class HomeContent extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() =>RegisterContentStates();

}
class RegisterContentStates extends State<HomeContent>
{
  String loginStr ="";
  String loginPas ="";
  bool isChooseTX=false;

  setStatusChoose(bool val) {
    setState(() {
      isChooseTX = val;
    });
  }
  @override
  void postNet_Login() async {


    var dio = new Dio();
    var response = await dio.post('https://interhos.youjiankang.net/doctor/dr-service/ba-doctor-user/doLogin',data:{
      "key":loginStr,
      "password": loginPas,
    });
    String mess=response.data['msg'];

    if(response.data['code']!=200)
     {
       Fluttertoast.showToast(msg: mess,gravity: ToastGravity.CENTER);
       return;
     }else
       {
         Fluttertoast.showToast(msg: '登录成功',gravity: ToastGravity.CENTER);

         SharedPreferences perfer= await SharedPreferences.getInstance();
       bool isSuccess= await  perfer.setString('tokenValue', response.data['data']['tokenValue']);
       print('SharedPreferences$isSuccess'+response.data['data']['tokenValue']);
         Navigator.pushNamed(context, '/TabHome');
       }

    // _content = response.data.toString();
    print(response.data.toString()+""+loginStr+loginPas);

    // Navigator.pushNamed(context, '/registerSuccess');

  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
                    margin: EdgeInsets.fromLTRB(20, 85.0, 0, 0),
                    alignment: Alignment.topLeft,
                    decoration: new BoxDecoration(
                    ),
                    child:Text('登录账号',textDirection: TextDirection.ltr,
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
                    child:Text('登录享受更精彩',textDirection: TextDirection.ltr,
                      textAlign:TextAlign.left ,
                      style:TextStyle(
                        fontSize: 13,
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
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '请输入手机号/用户名',
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 183, 183, 183),
                                    fontSize: 14,
                                  ),
                                ),
                                onChanged: (Value){
                                  setState(() {
                                    loginStr = Value;
                                  });

                                },

                              ),
                              ),
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
                                  hintText: '请输入登录密码',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 183, 183, 183),
                                  ),
                                ),
                                onChanged: (Value){
                                  setState(() {
                                    loginPas = Value;
                                  });
                                },
                              ), ),
                              width: MediaQuery.of(context).size.width-61,
                              margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child:FlatButton(
                                child: Text('快速注册',
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
                            )
                            ,
                            // SizedBox(width: 180),
                            Container(
                              child:FlatButton(
                                child: Text('忘记密码?',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 183, 183, 183),
                                    fontSize: 14,
                                  ),
                                ),
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/setPassword');
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                child:FlatButton(
                                  child: Text('登录',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),

                                  ),

                                  textColor: Colors.white,
                                  onPressed: () {


                                    if(isChooseTX==false)
                                      {
                                        Fluttertoast.showToast(msg: '请勾选服务',gravity: ToastGravity.CENTER);
                                        return;

                                      }

                                    postNet_Login();
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
                        ),
                        // SizedBox(height: 20),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, //横轴居顶对齐

                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 10, 10),
                              child:singChooseBtn( setStatusChoose
                              ) ,
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

//
// class HomeContent extends StatelessWidget{
//   // Future _openAlertDialog() async {
//   //
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
//
//
//
//
// }


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



