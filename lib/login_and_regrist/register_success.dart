import 'package:flutter/material.dart';

class RegisterSuccessHomeConent extends StatelessWidget
{
  @override
  final double fontSi=14;
  var col =Color.fromARGB(255, 81, 81, 81);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录成功",
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

      body:Column(
        children: [
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child:Image.asset('images/2.0x/success@2x.png'),
                width: 62.0,
                height: 63.0,
              ),

            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                 Text(
                  '恭喜您成功注册',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),


            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '需完善个人信息认证才能继续使用',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),



          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child:FlatButton(
                    child: Text('医师认证',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),

                    ),

                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, '/JumpToVideoList');
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
        ],




      ) ,
    );
    // TODO: implement build
  }

}

