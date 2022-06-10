import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/my/create_template.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_safeArea_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main_suit.dart';

class CaseTemplate extends StatefulWidget {
  const CaseTemplate({Key? key}) : super(key: key);

  @override
  _CaseTemplateState createState() => _CaseTemplateState();
}

class _CaseTemplateState extends State<CaseTemplate> {
  Widget _renderRow(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 7.0),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '高血压病历模板',
                  style: GSYConstant.textStyle(color: '#333333'),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  '内科',
                  style:
                      GSYConstant.textStyle(fontSize: 13.0, color: '#888888'),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text('个人模板',
                    style:
                        GSYConstant.textStyle(fontSize: 13.0, color: '#888888'))
              ],
            ),
            trailing: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MainSuit()));
              },
              child: Text(
                '引入模板',
                style: GSYConstant.textStyle(color: '#06B48D'),
              ),
            ),
          ),
          Divider(
            height: 0,
            color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 14.0, bottom: 14.0, left: 16.0, right: 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '主诉：',
                      style: GSYConstant.textStyle(
                          fontSize: 13.0, color: '#333333'),
                    ),
                    Text(
                      '胸部憋闷，疼痛1小时。',
                      overflow: TextOverflow.ellipsis,
                      style: GSYConstant.textStyle(
                          fontSize: 13.0, color: '#666666'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 11.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '现病史：',
                      style: GSYConstant.textStyle(
                          fontSize: 13.0, color: '#333333'),
                    ),
                    Flexible(
                        child: Text(
                      '患者1小时前因与人争执后出现胸部憋闷、刺痛…',
                      overflow: TextOverflow.ellipsis,
                      style: GSYConstant.textStyle(
                          fontSize: 13.0, color: '#666666'),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 11.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '过敏史：',
                      style: GSYConstant.textStyle(
                          fontSize: 13.0, color: '#333333'),
                    ),
                    Text(
                      '否认药物过敏史及食物过敏史。',
                      overflow: TextOverflow.ellipsis,
                      style: GSYConstant.textStyle(
                          fontSize: 13.0, color: '#666666'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 11.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '既往史：',
                      style: GSYConstant.textStyle(
                          fontSize: 13.0, color: '#333333'),
                    ),
                    Flexible(
                        child: Text(
                      '既往体健。否认高血压、糖尿病、冠心病史。',
                      overflow: TextOverflow.ellipsis,
                      style: GSYConstant.textStyle(
                          fontSize: 13.0, color: '#666666'),
                    ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        '病历模板',
      
      ),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 43.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Text('共',style: GSYConstant.textStyle(fontSize: 15.0,color: '#666666'),),
                      const SizedBox(width: 3.0,),
                      Text('3',style: GSYConstant.textStyle(fontSize: 15.0,color: '#f34c35'),),
                      const SizedBox(width: 3.0,),
                      Text('条常用诊断',style: GSYConstant.textStyle(fontSize: 15.0,color: '#666666')),
                    ],
                  ),
                ),
                Container(
                  height: 48.0,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '全部',
                          textAlign: TextAlign.center,
                          style: GSYConstant.textStyle(
                              fontSize: 15.0, color: '#06B48D'),
                        ),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: ColorsUtil.hexStringColor('#cccccc',
                                  alpha: 0.4)),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '个人模板',
                          textAlign: TextAlign.center,
                          style: GSYConstant.textStyle(
                              fontSize: 15.0, color: '#333333'),
                        ),
                      ),
                      Container(
                        width: 1.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: ColorsUtil.hexStringColor('#cccccc',
                                  alpha: 0.4)),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        '平台模板',
                        textAlign: TextAlign.center,
                        style: GSYConstant.textStyle(
                            fontSize: 15.0, color: '#333333'),
                      ))
                    ],
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: _renderRow)
              ],
            ),
          )),
          CustomSafeAreaButton(
              margin: const EdgeInsets.only(bottom: 16.0),
              custom:true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SvgUtil.svg('increment.svg'),
                  const SizedBox(width: 9.0,),
                  Text('添加病例模板',style: GSYConstant.textStyle(fontSize: 16.0),)
                ],
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateTemplate()));
              })
        ],
      ),
    );
  }
}
