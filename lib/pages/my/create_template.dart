import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_safeArea_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main_suit.dart';

class CreateTemplate extends StatefulWidget {
  const CreateTemplate({Key? key}) : super(key: key);

  @override
  _CreateTemplateState createState() => _CreateTemplateState();
}

listRow({required String title, required String detail, GestureTapCallback? onTap}) {
  return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                    width: 1.0))),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 43.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: GSYConstant.textStyle(color: '#333333'),
            ),
            Row(
              children: <Widget>[
                Text(
                  detail,
                  style: GSYConstant.textStyle(color: '#999999'),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Image.asset('assets/images/my/forward.png')
              ],
            ),
          ],
        ),
      ));
}

class _CreateTemplateState extends State<CreateTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        '模版名称',
      
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              color: ColorsUtil.hexStringColor('#cccccc',
                                  alpha: 0.3),
                              width: 1.0))),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 43.0,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '模板名称',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                      Expanded(
                          child: TextField(
                        textAlign: TextAlign.end,
                        style: GSYConstant.textStyle(color: '#666666'),
                        cursorColor: ColorsUtil.hexStringColor('#666666'),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '请输入模板名称',
                            hintStyle: GSYConstant.textStyle(color: '#999999')),
                      ))
                    ],
                  )),
                 listRow(title: '科室', detail: '请选择科室'),
                 const SizedBox(height: 8.0,),
                 listRow(title: '主诉', detail: '胸部憋闷，疼痛一小时...',onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>MainSuit()));
                 }),
                 listRow(title: '病史描述', detail: '请输入'),
                 listRow(title: '过敏史', detail: '否认药物过敏史及食...'),
                 listRow(title: '既往史', detail: '请输入')
            ],
          ),
          Expanded(
              child: Container(
            alignment: Alignment.bottomCenter,
            child: CustomSafeAreaButton(
              title: '保存',
              onPressed: () {},
            ),
          ))
        ],
      ),
    );
  }
}
