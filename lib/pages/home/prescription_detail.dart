import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/tools/wechat_flutter.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrescriptDetail extends StatefulWidget {
  const PrescriptDetail({Key key}) : super(key: key);

  @override
  _PrescriptDetailState createState() => _PrescriptDetailState();
}

class _PrescriptDetailState extends State<PrescriptDetail> {
  List list = [
    {'label': '甘草', 'detail': '2000g'},
    {'label': '陈皮', 'detail': '2000g'},
    {'label': '红枣', 'detail': '2000g'},
    {'label': '红蚂蚁', 'detail': '500g'},
    {'label': '服用贴数', 'detail': '7剂'},
    {'label': '用法', 'detail': '水煎服'},
    {'label': '频次', 'detail': '每日一剂'},
    {'label': '备注', 'detail': '请保持药品放在干燥通风的地方存储。'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          '处方详情',
          onBackPressed: () {
            Navigator.of(context).pop(this);
          },
        ),
        backgroundColor: ColorsUtil.bgColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: ColorsUtil.hexStringColor('#06B48D')),
                      child: Text(
                        '待患者支付',
                        style: GSYConstant.textStyle(
                            fontSize: 16.0, color: '#ffffff'),
                      ),
                    ),
                    Space(
                      height: 18.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '通海县人民医院电子处方',
                                style: GSYConstant.textStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: '#333333'),
                              ),
                              Text(
                                '医疗机构编码：346987654321123H',
                                style: GSYConstant.textStyle(
                                    fontSize: 12.0, color: '#888888'),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 23.0, right: 19.0),
                          child: Image.asset('assets/images/audit_pass.png'),
                        )
                      ],
                    ),
                    Space(
                      height: 18.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Space(
                              width: 16.0,
                            ),
                            Text(
                              '姓名：',
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                            Text(
                              '王建国',
                              style: GSYConstant.textStyle(color: '#666666'),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('性别：',
                                style: GSYConstant.textStyle(color: '#333333')),
                            Text('男',
                                style: GSYConstant.textStyle(color: '#666666'))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('年龄：',
                                style: GSYConstant.textStyle(color: '#333333')),
                            Text('38岁',
                                style: GSYConstant.textStyle(color: '#666666')),
                            Space(
                              width: 16.0,
                            )
                          ],
                        ),
                      ],
                    ),
                    Space(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Space(
                              width: 16.0,
                            ),
                            Text(
                              '费用：',
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                            Text(
                              '医保',
                              style: GSYConstant.textStyle(color: '#666666'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                transform:
                                    Matrix4.translationValues(-10.0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '科别：',
                                      style: GSYConstant.textStyle(
                                          color: '#333333'),
                                    ),
                                    Text(
                                      '心内科门诊',
                                      style: GSYConstant.textStyle(
                                          color: '#666666'),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Space(
                      height: 7.0,
                    ),
                    Divider(
                      height: 0,
                      color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.2),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      height: 39.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'NO：',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          Text(
                            '9899008766',
                            style: GSYConstant.textStyle(color: '#666666'),
                          ),
                          Space(
                            width: 25.0,
                          ),
                          Text(
                            '开方：',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          Text(
                            '2021-07-29 10:56',
                            style: GSYConstant.textStyle(color: '#666666'),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.2),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      height: 39.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            '诊断：',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          Text(
                            '气质眩晕',
                            style: GSYConstant.textStyle(color: '#666666'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                decoration: const BoxDecoration(color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: ListTile.divideTiles(
                      color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                      tiles: list.map((item) =>
                          Column(
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                item['label'],
                                style: GSYConstant.textStyle(color: '#333333'),
                              ),
                              tileColor: Colors.white,
                              trailing: Text(
                                item['label'],
                                style: GSYConstant.textStyle(color: '#666666'),
                              ),
                            )
                          ]
                        ),
                      )).toList(),
                ),
              )
            ],
          ),
        ));
  }
}
