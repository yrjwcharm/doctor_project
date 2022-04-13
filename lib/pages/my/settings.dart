import 'package:fluttertoast/fluttertoast.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/safe_area_button.dart';
import 'package:doctor_project/pages/login/login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List list =[{'title':'修改密码'},{'title':'隐私政策'}];


  //退出登录接口
  void getNet_signOut() async{

    SharedPreferences perfer = await SharedPreferences.getInstance();
    String? tokenValueStr = perfer.getString("tokenValue");
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request?.post(Api.signOutUrl,{
      "token"   : tokenValueStr,
    });
    print("getNet_signOut------" +res.toString());
    if (res['code'] == 200 ||res['code'] == 900) {
      // perfer.clear();//清空键值对
      perfer.remove("phone");
      perfer.remove("tokenValue");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage()), (route) => false);

    }else{
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: ColorsUtil.bgColor,
       body: Column(
        children: <Widget>[
          CustomAppBar('设置',onBackPressed: (){Navigator.of(context).pop(this);},),
          SizedBox(height: 10.0,),
          Column(
              children:list.map((item) =>
                  Column(
                          children: <Widget>[
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child:ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                trailing: Image.asset('assets/images/my/more.png'),
                                title: Container(
                                  margin: const EdgeInsets.all(0),
                                  child: Text(item['title'],style: GSYConstant.textStyle(color: '#333333'),
                                  ),),
                              ) ,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child:Divider(height:0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3,))
                            )
                          ],
                        ),
                    ).toList()
          ),
          SafeAreaButton(text: '安全退出', onPressed: () {

            getNet_signOut();
          },)
        ]
      ),
    );
  }
}
