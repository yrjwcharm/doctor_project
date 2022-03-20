import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';


class settingContent extends StatelessWidget
{
  void postNet_doExit(BuildContext context) async {
    SharedPreferences perfer= await SharedPreferences.getInstance();
    String? tokenValueStr=  perfer.getString('tokenValue');

    var dio = new Dio();
    dio.options.headers = {
      "token": tokenValueStr,
    };

    var response = await dio.post('https://interhospital.youjiankang.net/doctor/dr-service/ba-doctor-user/doExit');
    String mess=response.data['msg'];

    if(response.data['code']!=200)
    {
      Fluttertoast.showToast(msg: mess,gravity: ToastGravity.CENTER);
      return;
    }else
    {
      Fluttertoast.showToast(msg: '退出登录',gravity: ToastGravity.CENTER);

      Navigator.of(context).pop();

    }

    // _content = response.data.toString();

    // Navigator.pushNamed(context, '/registerSuccess');

  }
  @override
  final double fontSi=14;
  var col =Color.fromARGB(255, 81, 81, 81);
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("设置",
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
      body:
      Container(
        color: Color.fromARGB(255, 247, 247, 247),
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            SizedBox(height: 10),
        Container(
        decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        width: double.infinity-20,
        height: 88,
          child: Column(
            children: [
              Container(
                child:GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center, //横轴居顶对齐
                      children: [
                        Container(
                          alignment: Alignment(-1, 0),
                          child: Text(
                            "修改密码",
                            style:
                            TextStyle(
                              fontSize: fontSi,
                              color: col,
                            ),
                          ),
                          margin: EdgeInsets.fromLTRB(10,0, 0, 0),
                          width:MediaQuery.of(context).size.width-40-8-20 ,
                          height: 44,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0,5 , 0, 10),
                          child:Image(image: AssetImage("images/2.0x/more@2x.png")) ,
                          width: 8,
                          height: 14,
                        )
                      ],

                    ),

                    onTap: () {
                      Navigator.pushNamed(context, '/changePas');
                    }
                ),
              ),
              Container(
                child:GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center, //横轴居顶对齐
                      children: [
                        Container(
                          alignment: Alignment(-1, 0),
                          child: Text(
                            "隐私协议",
                            style:
                            TextStyle(
                              fontSize: fontSi,
                              color: col,
                            ),


                          ),
                          width:MediaQuery.of(context).size.width-40-8-20 ,
                          height: 44,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),

                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child:Image(image: AssetImage("images/2.0x/more@2x.png")) ,
                          width: 8,
                          height: 14,
                        )
                      ],

                    ),

                    onTap: () {

                    }
                ),

              ),




            ],
          ),
        ),

            SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              alignment: Alignment.center,
              child:  FlatButton(
                child:Text("安全退出",
                  style: TextStyle(color: col,fontSize: fontSi),),

                onPressed: () {
                  postNet_doExit(context);



                  

                },
              ),

              width:MediaQuery.of(context).size.width-40 ,
              height: 44,
            ),
          ],
        ),


      ),

    );
  }



}
