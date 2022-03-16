import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/tools/wechat_flutter.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'case_template.dart';

class WriteCase extends StatefulWidget {
  const WriteCase({Key key}) : super(key: key);

  @override
  _WriteCaseState createState() => _WriteCaseState();
}

class _WriteCaseState extends State<WriteCase> {
  List list = [
    {'label':'就诊卡类型','value':'身份证','disabled':true,'isArrow':false},
    {'label':'就诊卡号码','value':'3714**********6578','disabled':false,'isArrow':false},
    {'label':'患者姓名','value':'张可可','disabled':false,'isArrow':false},
    {'label':'患者性别','value':'女','disabled':true,'isArrow':false},
    {'label':'出生日期','value':'2022-02-11','disabled':true,'isArrow':false},
    {'label':'科室门诊','value':'呼吸内科','disabled':true,'isArrow':false},
    {'label':'主诉','value':'请输入疾病','disabled':true,'isArrow':true},
    {'label':'病史描述','value':'请输入疾病','disabled':true,'isArrow':true},
    {'label':'现病史','value':'请输入现病史','disabled':true,'isArrow':true},
    {'label':'既往史','value':'请输入既往史','disabled':true,'isArrow':true},
    {'label':'过敏史','value':'请输入过敏史','disabled':true,'isArrow':true},
  ];
  List<Widget> widgets =const <Widget>[];
   @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar('写病历',onBackPressed: (){
        Navigator.pop(context);
      }, isForward:true,child: Text('引入病例模板',style: GSYConstant.textStyle(color: '#06B48D'),),onForwardPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const CaseTemplate()));
      },),
      body: Column(
        children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: list.asMap().keys.map((index) =>
                  Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        height: 44.0,
                        decoration: const BoxDecoration(
                            color: Colors.white
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(list[index]['label'],style: GSYConstant.textStyle(color: '#333333'),),
                            Row(
                              children: <Widget>[
                                    SizedBox(
                                      width:250.0,
                                      // height: 44.0,
                                      child:  TextField(
                                        cursorColor: ColorsUtil.hexStringColor('#888888'),
                                        enabled:!list[index]['disabled'],
                                        textAlign: TextAlign.end,
                                        // textAlignVertical: TextAlignVertical.center,
                                        style: GSYConstant.textStyle(color: '#888888'),
                                        decoration: InputDecoration(
                                            isCollapsed: true,
                                            border: InputBorder.none,
                                            hintStyle: GSYConstant.textStyle(color: '#888888'),
                                            hintText: list[index]['value']
                                        ),
                                ),)
                                // Text(list[index]['value'],style: GSYConstant.textStyle(color: '#888888'),),
                                 ,
                                Space(width:list[index]['isArrow']? 8.0:0,),
                                list[index]['isArrow']?Image.asset('assets/images/arrow_right.png'):Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),)
                    ],
                  ),
              ).toList(),
            )
        ],
      ),
    );
  }
}
