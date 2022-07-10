import 'dart:io';

import 'package:doctor_project/common/event/event_bus.dart';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/model/western_rp_template.dart';
import 'package:doctor_project/pages/home/make_prescription.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/event_bus_util.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_safeArea_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CommonRp extends StatefulWidget {
  String registerId;

  CommonRp({Key? key, required this.registerId}) : super(key: key);

  @override
  _CommonRpState createState() => _CommonRpState(this.registerId);
}

class _CommonRpState extends State<CommonRp> {
  bool tab1Active = true;
  bool tab2Active = false;
  List rpList = [];
  List westernRpList = [
    // {
    //     "checkMsg": "",
    //     "pharmacistSign": "",
    //     "herbalMedicineVOS": "",
    //     "freq": "",
    //     "amt": "17.65",
    //     "type_dictText": "",
    //     "status_dictText": "审核中",
    //     "type": "1",
    //     "useType": "",
    //     "roomId": 2,
    //     "freq_dictText": "未知字典",
    //     "registerId": 451214891395711000,
    //     "category_dictText": "西药/中成药",
    //     "useType_dictText": "未知字典",
    //     "id": 944241327611052400,
    //     "onceDosage": "",
    //     "pharId": "",
    //     "medicineVOS": [
    //       {
    //         "baseUnitid": "",
    //         "wmOnceDosage": 1,
    //         "freq": "bid",
    //         "packageUnitid": "he2",
    //         "amt": "17.65",
    //         "specification": "0.25g*16粒",
    //         "useType": "01",
    //         "baseUnitid_dictText": "未知字典",
    //         "medicineName": "云南白药胶囊0.25g",
    //         "packageUnitid_dictText": "盒",
    //         "medicineNum": 1,
    //         "freq_dictText": "2次/天",
    //         "manuname": "云南白药集团股份有限公司",
    //         "dayNum": "12",
    //         "useType_dictText": "口服",
    //         "id": 74516,
    //         "remarks": "好"
    //       }
    //     ],
    //     "countNum": "",
    //     "doctorSign": "",
    //     "companySign": "",
    //     "recipeNo": "20220530193504348",
    //     "pharName": "未知字典",
    //     "checkDate": "",
    //     "drugRoom": "通海县人民医院中心药房",
    //     "repictDate": "2022-05-30 19:35",
    //     "diagnosisVOS": [
    //       {
    //         "diagnosisName": "诊断会谈和评价  ＮＯＳ",
    //         "isMaster": 1,
    //         "id": 34022,
    //         "isMaster_dictText": "是"
    //       }
    //     ],
    //     "onceDosageDes": "",
    //     "name": "普通处方",
    //     "patientVO": "",
    //     "category": 1,
    //     "remarks": "",
    //     "status": 4
    //   },
    {
      'templateName': '风寒湿热',
      'deptName': '测试科室',
      'medicineName': '云南白药胶囊0.25g/盒',
      'useType_dictText': '口服',
      'freq_dictText': '2次/天',
      'specification': '',
      'countNum': ''
    }
  ];
  List cnRpList = [
    {
      'medicineName': '冬瓜皮',
      'templateName': '热毒炽盛',
      'deptName': '测试科室',
      'useType_dictText': '泡脚',
      'freq_dictText': '每日二次',
      'specification': '甘草20g  陈皮20g...',
      'countNum': '2'
    }
  ];
  String registerId;

  _CommonRpState(this.registerId);

  @override
  void initState() {
    super.initState();
    rpList = westernRpList;
  }

  Widget _renderRow(BuildContext context, int index) {
    var item = rpList[index];
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              // flex: 2,
              onPressed: (BuildContext context) async {
                setState(() {
                  rpList.remove(item);
                });
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '删除',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(
                      color:
                      ColorsUtil.hexStringColor('#cccccc', alpha: 0.3)))),
          child: Row(
            children: <Widget>[
              SvgUtil.svg('checked.svg'),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    item['templateName'],
                                    style: GSYConstant.textStyle(
                                        fontSize: 14.0, color: '#333333'),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 8.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        border: Border.all(
                                            width: 0.5,
                                            color: ColorsUtil.hexStringColor(
                                                '#06b48d'))),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      item['deptName'],
                                      style: GSYConstant.textStyle(
                                          fontSize: 12.0, color: '#06b48d'),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            tab1Active
                                ? item['medicineName']
                                : item['specification'],
                            style: GSYConstant.textStyle(
                                fontSize: 14.0, color: '#333333'),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            '${item['useType_dictText']}：${item['freq_dictText']},${tab1Active
                                ? ''
                                : item['countNum']}',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#888888'),
                          )
                        ],
                      ),
                    ),
                    SvgUtil.svg('forward_more.svg')
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('常用处方'),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          Container(
            height: 48.0,
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(children: <Widget>[
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      rpList = westernRpList;
                      setState(() {
                        tab1Active = true;
                        tab2Active = false;
                      });
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '西药/中成药',
                          textAlign: TextAlign.center,
                          style: GSYConstant.textStyle(
                              fontSize: 16.0,
                              color: tab1Active ? '#06b48d' : '#666666'),
                        ),
                        Positioned(
                            bottom: -ScreenUtil().setHeight(13.0),
                            child: Container(
                              width: ScreenUtil().setWidth(107.0),
                              height: tab1Active ? 1.0 : 0,
                              decoration: BoxDecoration(
                                  color: ColorsUtil.hexStringColor('#06b48d')),
                            ))
                      ],
                    )),
              ),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        rpList = cnRpList;

                        setState(() {
                          tab1Active = false;
                          tab2Active = true;
                        });
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '中药',
                            textAlign: TextAlign.center,
                            style: GSYConstant.textStyle(
                                fontSize: 16.0,
                                color: tab2Active ? '#06b48d' : '#666666'),
                          ),
                          Positioned(
                              bottom: -ScreenUtil().setHeight(13.0),
                              child: Container(
                                width: ScreenUtil().setWidth(48.0),
                                height: tab2Active ? 1.0 : 0,
                                decoration: BoxDecoration(
                                    color:
                                    ColorsUtil.hexStringColor('#06b48d')),
                              ))
                        ],
                      )))
            ]),
          ),
          const SizedBox(
            height: 11.0,
          ),
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: rpList.length,
                    itemBuilder: _renderRow),
                Visibility(
                    visible: rpList.isNotEmpty,
                    child: Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      height: 40.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            '*',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#fe5a6b'),
                          ),
                          Text(
                            '操作提示：左滑删除常用处方',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#666666'),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          )),
          CustomSafeAreaButton(
            margin: const EdgeInsets.only(bottom: 16.0),
            onPressed: () {
              if (tab1Active) {
                // EventBusUtil.getInstance().fire();
                WesternRpTemplate data =WesternRpTemplate.fromJson({
                    "checkMsg": "",
                    "pharmacistSign": "",
                    "herbalMedicineVOS": "",
                    "freq": "",
                    "amt": "17.65",
                    "type_dictText": "",
                    "status_dictText": "审核中",
                    "type": "1",
                    "useType": "",
                    "roomId": 2,
                    "freq_dictText": "未知字典",
                    "registerId": 451214891395711000,
                    "category_dictText": "西药/中成药",
                    "useType_dictText": "未知字典",
                    "id": 944241327611052400,
                    "onceDosage": "",
                    "pharId": "",
                    "medicineVOS": [
                      {
                        "baseUnitid": "",
                        "wmOnceDosage": 1,
                        "freq": "bid",
                        "packageUnitid": "he2",
                        "amt": "17.65",
                        "specification": "0.25g*16粒",
                        "useType": "01",
                        "baseUnitid_dictText": "未知字典",
                        "medicineName": "云南白药胶囊0.25g",
                        "packageUnitid_dictText": "盒",
                        "medicineNum": 1,
                        "freq_dictText": "2次/天",
                        "manuname": "云南白药集团股份有限公司",
                        "dayNum": "12",
                        "useType_dictText": "口服",
                        "id": 74516,
                        "remarks": "好"
                      }
                    ],
                    "countNum": "",
                    "doctorSign": "",
                    "companySign": "",
                    "recipeNo": "20220530193504348",
                    "pharName": "未知字典",
                    "checkDate": "",
                    "drugRoom": "通海县人民医院中心药房",
                    "repictDate": "2022-05-30 19:35",
                    "diagnosisVOS": [
                      {
                        "diagnosisName": "诊断会谈和评价  ＮＯＳ",
                        "isMaster": 1,
                        "id": 34022,
                        "isMaster_dictText": "是"
                      }
                    ],
                    "onceDosageDes": "",
                    "name": "普通处方",
                    "patientVO": "",
                    "category": 1,
                    "remarks": "",
                    "status": 4
                  });

                // EventBusUtil.getInstance().fire({'success':'true'});
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      MakePrescription(registeredId: registerId,westernRp:data)));

              }
            }, title: '引入模板',)

        ],
      ),
    );
  }
}
