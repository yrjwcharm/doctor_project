import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_safeArea_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCommonWords extends StatefulWidget {
  const AddCommonWords({Key? key}) : super(key: key);

  @override
  _AddCommonWordsState createState() => _AddCommonWordsState();
}

class _AddCommonWordsState extends State<AddCommonWords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        '添加常用语',
        // onBackPressed: () {
        //   Navigator.pop(context);
        // },
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
            Expanded(child:
             TextField(
              maxLines: 5,
              inputFormatters: [],
              cursorColor: ColorsUtil.hexStringColor('#666666'),
              style: GSYConstant.textStyle(fontSize: 14.0, color: '#666666'),
              decoration: InputDecoration(
                  hintText: '请输入您的常用回复，请不要填写QQ、微信等联系方式或广告信息，否则系统将封禁您的账号',
                  // fillColor: Colors.transparent,
                  // filled: true,
                  contentPadding: const EdgeInsets.only(left: 16.0,top: 16.0,right: 16.0),
                  border: InputBorder.none,
                  hintStyle:
                      GSYConstant.textStyle(fontSize: 14.0, color: '#999999')),
            ),),
           CustomSafeAreaButton(
             margin: const EdgeInsets.only(bottom: 16.0),
             onPressed: (){
                Navigator.pop(context);
           },title: '保存',)
        ],
      ),
    );
  }
}
