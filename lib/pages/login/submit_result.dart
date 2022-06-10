import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitResult extends StatefulWidget {
  const SubmitResult({Key? key}) : super(key: key);

  @override
  _SubmitResultState createState() => _SubmitResultState();
}

class _SubmitResultState extends State<SubmitResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('提交结果',),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 52.0,),
          SvgUtil.svg('success.svg'),
          Container(
            margin: const EdgeInsets.only(top: 28.0),
            child: Text('资质提交成功',style: GSYConstant.textStyle(fontSize: 16.0,color: '#333333'),),
          ),
          Container(
            margin: const EdgeInsets.only(top: 9.0),
            child: Text('审核结果需要1-3个工作日',style: GSYConstant.textStyle(fontSize: 14.0,color:'#888888' ),),
          ),
          Container(
            margin: const EdgeInsets.only(top: 120.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomElevatedButton(onPressed: () {
            },title: '返回首页',borderRadius: BorderRadius.circular(22.0),),
          )
        ],
      ),
    );
  }
}
