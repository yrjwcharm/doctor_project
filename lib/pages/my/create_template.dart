import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/tools/wechat_flutter.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateTemplate extends StatefulWidget {
  const CreateTemplate({Key key}) : super(key: key);

  @override
  _CreateTemplateState createState() => _CreateTemplateState();
}

class _CreateTemplateState extends State<CreateTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        '模版名称',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  decoration: const BoxDecoration(color: Colors.white),
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
              Divider(
                height: 0,
                color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 43.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '科室',
                      style: GSYConstant.textStyle(color: '#333333'),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '请选择科室',
                          style: GSYConstant.textStyle(color: '#999999'),
                        ),
                        Space(
                          width: 8.0,
                        ),
                        Image.asset('assets/images/my/forward.png')
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
            child: SafeAreaButton(
              text: '保存',
              onPressed: () {},
            ),
          ))
        ],
      ),
    );
  }
}
