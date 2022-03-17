import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/my/create_template.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainSuit extends StatefulWidget {
  const MainSuit({Key? key}) : super(key: key);

  @override
  _MainSuitState createState() => _MainSuitState();
}

class _MainSuitState extends State<MainSuit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('主诉',onBackPressed: (){
        Navigator.pop(context);
      },),
      body: Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Colors.white
            ),
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top:12.0,left: 16.0,bottom: 13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('主诉',style: GSYConstant.textStyle(fontSize: 16.0,color: '#333333'),),
                SizedBox(
                  child:  TextField(
                    cursorColor: ColorsUtil.hexStringColor('#666666'),
                    maxLength: 500,
                    maxLines: 6,
                    style: GSYConstant.textStyle(color: '#666666'),
                    decoration: InputDecoration(
                      // filled: true,
                      contentPadding: const EdgeInsets.only(top: 10.0,right: 16.0),
                      // fillColor: Colors.red,
                      hintText: '请输入内容...',
                      hintStyle: GSYConstant.textStyle(color: '#999999'),
                      // contentPadding: const EdgeInsets.only(left: 16.0,top: 10.0),
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(child:Container(
            alignment: Alignment.bottomCenter,
            child: SafeAreaButton(text: '保存',onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>const CreateTemplate()));
            },),
          ))
        ],
      ),
    );
  }
}
