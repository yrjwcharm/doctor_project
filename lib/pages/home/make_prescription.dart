import 'package:doctor_project/pages/home/add-drug.dart';
import 'package:doctor_project/utils/svg_utils.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'package:flutter/material.dart';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'chinese_diagnosis.dart';

class MakePrescription extends StatefulWidget {
  const MakePrescription({Key? key}) : super(key: key);

  @override
  _MakePrescriptionState createState() => _MakePrescriptionState();
}

class _MakePrescriptionState extends State<MakePrescription> {
  List list = [];
  List list1 = [];

  @override
  void initState() {
    super.initState();
    list = [
      {
        'title': '处方类型',
        'detail': '普通处方',
        'isArrow': true,
      },
      {
        'title': '诊断',
        'detail': '请选择诊断',
        'isArrow': false,
      },
      {
        'title': '药房',
        'detail': '请选择药房',
        'isArrow': false,
      },
    ];
    list1 = [
      {
        'title': '处方贴数',
        'subTitle': '(付/剂)',
        'detail': '请输入数量',
        'isArrow': false,
      },
      {
        'title': '用法',
        'detail': '请选择用法',
        'isArrow': true,
      },
      {
        'title': '频次',
        'detail': '请选择频次',
        'isArrow': true,
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          CustomAppBar(
            '开处方',
            isBack: true,
            onBackPressed: () {
              Navigator.of(context).pop(this);
            },
          ),
          const SizedBox(
            height: 13.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                children: [
                  Image.asset(
                    'assets/images/self_mention.png',
                    fit: BoxFit.contain,
                    height: 44,
                  ),
                  Positioned(
                      top: 10.0,
                      left: 39.0,
                      child: Text(
                        '西药/中成药处方',
                        style: GSYConstant.textStyle(
                            fontSize: 17.0, color: '#06B48D'),
                      ))
                ],
              ),
              Flexible(
                child: Stack(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0, 0, 0),
                      child: Image.asset(
                        'assets/images/express_delivery.png',
                        fit: BoxFit.cover,
                        height: 44,
                      ),
                    ),
                    Positioned(
                        left: 44.0,
                        top: 8.0,
                        child: Text(
                          '中药处方',
                          style: GSYConstant.textStyle(
                              fontSize: 16.0, color: '#333333'),
                        ))
                  ],
                ),
              )
            ],
          ),
          Column(
              children: ListTile.divideTiles(
                  color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                  tiles: list.asMap().keys.map((index) => ListTile(
                        onTap: () {
                          switch (index) {
                            case 0:
                              break;
                            case 1:
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>const  WesternDiagnosis()));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ChineseDiagnosis()));
                              break;
                            case 2:
                              break;
                          }
                        },
                        tileColor: Colors.white,
                        title: Row(
                          children: <Widget>[
                            Text(
                              list[index]['title'],
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                            Text(
                              list[index]['subTitle'] ?? '',
                              style: GSYConstant.textStyle(color: '#333333'),
                            )
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              list[index]['detail'],
                              style: GSYConstant.textStyle(color: '#666666'),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            list[index]['isArrow']
                                ? Image.asset(
                                    'assets/images/home/arrow_right.png')
                                : Container()
                          ],
                        ),
                      ))).toList()),
          const SizedBox(
            height: 8.0,
          ),
          Column(
            children: list1.map(
                  (item) => Column(
                    children: <Widget>[
                      Container(
                        height: 44.0,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: const BoxDecoration(color: Colors.white),
                        // margin: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  item['title'],
                                  style:
                                      GSYConstant.textStyle(color: '#333333'),
                                ),
                                // Text('(付/剂)',style: GSYConstant.textStyle(color: '#999999'),)
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(
                                    width:250.0,
                                    child: TextField(
                                      textAlign: TextAlign.right,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: GSYConstant.textStyle(
                                          color: '#999999'),
                                      decoration: InputDecoration(
                                          hintText: item['detail'],
                                          isCollapsed: true,
                                          contentPadding: EdgeInsets.zero,
                                          // suffixIcon: Image.asset('assets/images/home/arrow_right.png'),
                                          border: InputBorder.none,
                                          // isCollapsed: true,
                                          hintStyle: GSYConstant.textStyle(
                                              color: '#999999')),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0,),
                                  item['isArrow']?Image.asset('assets/images/home/arrow_right.png'):Container()
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                      )
                    ],
                  ),
                )
                .toList(),
          ),
          ListTile(
            title: const Text('RP'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SvgUtil.svg(
                  'add.svg',
                ),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddDrug()));
                }, child: Text('添加药品',style: GSYConstant.textStyle(color: '#06B48D'),))
              ],
            ),
          ),
          SafeAreaButton(text: '电子签名', onPressed:(){})
        ],
      ),
    );
  }
}
