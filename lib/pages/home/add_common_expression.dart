import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddUsefulExpression extends StatefulWidget {
  const AddUsefulExpression({Key? key}) : super(key: key);
  @override
  _AddUsefulExpressionState createState() => _AddUsefulExpressionState();
}

class _AddUsefulExpressionState extends State<AddUsefulExpression> {
  String text='';
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBar('添加常用语',isBack: true,onBackPressed: (){
            Navigator.pop(context);
          },),
          CustomInputWidget(hintText: '请输入您的常用回复，请不要填写QQ、微信等联系方式或广告信息，否则系统将封禁您的账号', onChanged: (String value) {

          }, textStyle: TextStyle(fontSize: 16.0, color: ColorsUtil.hexStringColor('#666666')),)
        ],
      ),
    );
  }
}
