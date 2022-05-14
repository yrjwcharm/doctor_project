import 'package:doctor_project/pages/my/verify_old_pwd.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
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
  List list = [
    {'title': '修改密码'},
    {
      'title': '隐私政策',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '设置',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(children: <Widget>[
        const SizedBox(height: 10.0,),
        Expanded(
          child: Column(
              children: list.asMap().keys
                  .map((index) => InkWell(
                        onTap: (){
                          switch(index){
                            case 0:
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyOldPwd()));
                              break;
                            case 1:
                              break;
                          }
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                trailing: SvgUtil.svg('forward.svg'),
                                title: Container(
                                  margin: const EdgeInsets.all(0),
                                  child: Text(
                                    list[index]['title'],
                                    style:
                                        GSYConstant.textStyle(color: '#333333'),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Divider(
                                    height: 0,
                                    color: ColorsUtil.hexStringColor(
                                      '#cccccc',
                                      alpha: 0.3,
                                    )))
                          ],
                        ),
                      ))
                  .toList()),
        ),
        SafeAreaButton(
          margin: const EdgeInsets.only(bottom: 16.0),
          text: '安全退出',
          onPressed: () async {
            SharedPreferences perfer = await SharedPreferences.getInstance();
            // getNet_signOut();
            var res = await HttpRequest.getInstance().post(Api.exitLogin, {});
            if (res['code'] == 200) {
              perfer.remove('tokenValue');
              perfer.remove('phone');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
            } else {
              ToastUtil.showToast(msg: res['msg']);
            }
          },
        )
      ]),
    );
  }
}
