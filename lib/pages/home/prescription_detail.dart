import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/tools/wechat_flutter.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
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
                        '未通过',
                        style: GSYConstant.textStyle(
                            fontSize: 16.0, color: '#ffffff'),
                      ),
                    ),
                    ListTile(
                      subtitle:Text('列表中的克拉霉素胶囊对患者病情有刺激性。',style: GSYConstant.textStyle(color: '#F39E2B'),) ,
                      title: Text('审核不通过的处方原因如下：',style: GSYConstant.textStyle(fontSize: 15.0,fontFamily: 'Medium',fontWeight: FontWeight.w500,color: '#333333'),),
                    ),
                    Divider(height: 0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                                Text('审核药师：',style: GSYConstant.textStyle(fontSize: 13.0,color: '#333333'),),
                                Text('张兰',style: GSYConstant.textStyle(fontSize: 13.0,color: '#06B48D'),)
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text('审核时间：2022-02-22 13:00:56',style: GSYConstant.textStyle(fontSize: 13.0,color: '#333333'),)

                            ],
                          ),
                        ],
                      ),
                    ),
                    // Space(
                    //
                    //   height: 18.0,
                    // ),
                    Container(
                      height: 7.0,
                      decoration: BoxDecoration(
                        color: ColorsUtil.bgColor
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child:Row(
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
              Column(
                children: <Widget>[
                  Space(height: 8.0,),
                  Container(
                    padding: const EdgeInsets.only(left: 16.0),
                    alignment: Alignment.centerLeft,
                    height: 40.0,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white
                    ),
                    child: Text('Rp',style: GSYConstant.textStyle(color: '#333333'),),
                  ),
                  Divider(height: 0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.2),)
                ],
              ),
              Column(
                  children: ListTile.divideTiles(
                      color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                      tiles: list.asMap().keys.map((index) =>
                          Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: const BoxDecoration(color: Colors.white),
                              child:ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  list[index]['label'],
                                  style: GSYConstant.textStyle(color: '#333333'),
                                ),
                                tileColor: Colors.white,
                                trailing: Text(
                                  list[index]['detail'],
                                  style: GSYConstant.textStyle(color: '#666666'),
                                ),
                              ) ,
                            ),
                            index==3?Space(height: 8.0,):Container()
                          ]
                        ),
                      )).toList(),
                ),
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                decoration: const BoxDecoration(
                  color: Colors.white
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('处方医师',style: GSYConstant.textStyle(color: '#333333'),),
                            Space(width: 15.0,),
                            Text('张望国',style: GSYConstant.textStyle(fontSize:18.0,color: '#666666',fontFamily: 'ShouShuti'),)
                          ],
                        ),
                        Space(height: 25.0,),
                        Row(
                          children: <Widget>[
                            Text('审方医师',style: GSYConstant.textStyle(color: '#333333'),),
                            Space(width: 15.0,),
                            Text('苏山寒',style: GSYConstant.textStyle(fontSize:18.0,color: '#666666',fontFamily: 'ShouShuti'),)
                          ],
                        )
                      ],
                    ),
                    Image.asset('assets/images/chapter.png')
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 13.0,bottom: 27.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('备注：',style: GSYConstant.textStyle(fontSize: 13.0,color: '#666666'),),
                    Space(height: 7.0,),
                    Text('该处方有效期为7天。',style: GSYConstant.textStyle(fontSize: 13.0,color: '#666666')),

                    // Text('1、该处方有效期为7天。',style: GSYConstant.textStyle(fontSize: 13.0,color: '#666666')),
                    // Text('2、该处方不支持线下药房购药。',style: GSYConstant.textStyle(fontSize: 13.0,color: '#666666')),
                  ],
                ),
              ),
              SafeArea(
                child:Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0),child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomOutlineButton(
                          height: 40.0,
                          title: '在此提交', onPressed: (){

                      }, borderRadius: BorderRadius.circular(5.0), borderColor:ColorsUtil.primaryColor) ,
                    ),
                    const SizedBox(width: 8.0,),
                    Expanded(
                      child: CustomElevatedButton(
                        height: 40.0,
                        title: '重新开方', onPressed: (){}, borderRadius: BorderRadius.circular(5.0),primary: '#06B48D',) ,
                    )

                  ],
                ),) ,
              )
            ],
          ),
        ));
  }
}
