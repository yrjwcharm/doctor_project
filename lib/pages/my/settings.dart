import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/tools/wechat_flutter.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/safe_area_button.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List list =[{'title':'修改密码'},{'title':'隐私政策'}];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: ColorsUtil.bgColor,
       body: Column(
        children: <Widget>[
          CustomAppBar('设置',onBackPressed: (){Navigator.of(context).pop(this);},),
          Space(height: 10.0,),
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
          SafeAreaButton(text: '安全退出', onPressed: () {  },)
        ]
      ),
    );
  }
}
