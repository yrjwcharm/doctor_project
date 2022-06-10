import 'dart:convert';
import 'dart:typed_data';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/home/chat_room.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../http/api.dart';
import '../../utils/num_util.dart';
import '../home/electronicSgnature.dart';
import '../home/webviewVC.dart';
import '../tabs/main.dart';

class RecipeDetail extends StatefulWidget {
  RecipeDetail({Key? key, required this.rpDetailItem, required this.diagnosis})
      : super(key: key);
  Map rpDetailItem;

  String diagnosis;

  @override
  _RecipeDetailState createState() =>
      _RecipeDetailState(this.rpDetailItem, this.diagnosis);
}

class _RecipeDetailState extends State<RecipeDetail> {
  Map rpDetailItem;
  String diagnosis;
  List<dynamic> list = [];
  List<dynamic> herbalMedicineVOS = [];
  List<dynamic> medicineVOS = [];
  String doctorSign = '';
  String pharmacistSign = '';
  String companySign = '';
  String countNum = '';
  String pharmacistsName = '';
  String auditingTime = '';
  String  useType_dictText='';
  String freq_dictText='';
  String remarks ='';
  Map<String, dynamic> medicineMap = {};

  _RecipeDetailState(this.rpDetailItem, this.diagnosis);

  @override
  void initState() {
    super.initState();
    initData();
    // getNet_userSignature();
  }

  //医信签电子签名接口
  void getNet_userSignature() async {
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.userSignatureUrl, {});
    print("getNet_userSignature------" + res.toString());
    Map data = res['data'];
    if (res['code'] == 200) {
      if (data["signatureImg"] != null) {
        Navigator.pop(context);
      } else {
        String url = data["data"]["oauthURL"];
        // Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebviewVC(
                      url: url,
                    )));
      }
    } else {
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER);
    }
  }

  initData() async {
    var request = HttpRequest.getInstance();
    var res = await request
        .get(Api.getRpDetailApi + '?recipeId=${rpDetailItem['id']}', {});
    if (res['code'] == 200) {
      medicineMap = res['data'];
      print("medicineMap------" + medicineMap.toString());
      if (medicineMap['doctorSign'].isNotEmpty) {
        doctorSign = medicineMap['doctorSign'];
      }
      if (medicineMap['pharmacistSign'].isNotEmpty) {
        pharmacistSign = medicineMap['pharmacistSign'];
      }
      if (medicineMap['companySign'].isNotEmpty) {
        companySign = medicineMap['companySign'];
      }

      if (medicineMap['herbalMedicineVOS'].isNotEmpty) {
        herbalMedicineVOS = medicineMap['herbalMedicineVOS'];
      }
      if (medicineMap['medicineVOS'].isNotEmpty) {
        medicineVOS = medicineMap['medicineVOS'];
      }
      // if(medicineMap['countNum'].toString.isNotEmpty) {
        countNum = medicineMap['countNum'].toString();
      // }
      if(null !=res['data']['pharName']) {
        pharmacistsName = res['data']['pharName'];
      }
      auditingTime = res['data']['checkDate']??'';
      useType_dictText=res['data']['useType_dictText']??'';
      freq_dictText=res['data']['freq_dictText']??'';
      remarks = res['data']['remarks']??'';
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      // primary: true,
      appBar: CustomAppBar(
        '处方详情',
      
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 40.0,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    rpDetailItem['status'] == 1
                        ? '已撤销'
                        : rpDetailItem['status'] == 2
                            ? '再次提交，待审方'
                            : rpDetailItem['status'] == 3
                                ? '已审核'
                                : rpDetailItem['status'] == 4
                                    ? '审核中'
                                    : rpDetailItem['status'] == 5
                                        ? '审核超时失效'
                                        : '已取消',
                    style: GSYConstant.textStyle(fontSize: 16.0),
                  ),
                  decoration: BoxDecoration(
                      color:
                          ColorsUtil.hexStringColor(rpDetailItem['status'] == 5
                              ? '#F39E2B'
                              : rpDetailItem['status'] == 2
                                  ? '#DE5347'
                                  : '#06B48D')),
                ),
                Visibility(
                  visible: rpDetailItem['status'] == 2,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.only(
                        top: 13.0, left: 16.0, right: 16.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '审核不通过的处方原因如下：',
                          style: GSYConstant.textStyle(
                              fontSize: 15.0,
                              fontFamily: 'Medium',
                              fontWeight: FontWeight.w500,
                              color: '#333333'),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          medicineMap['checkMsg'] ?? '',
                          style: GSYConstant.textStyle(color: '#F39E2B'),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: rpDetailItem['status'] == 2,
                  child: Divider(
                    height: 0,
                    color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.2),
                  ),
                ),
                Visibility(
                  visible: rpDetailItem['status'] == 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    height: 39.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Text(
                            '审方药师：',
                            style: GSYConstant.textStyle(
                              fontSize: 13.0,
                              color: '#333333',
                            ),
                          ),
                          Text(
                            pharmacistsName,
                            style: GSYConstant.textStyle(
                            fontSize: 14.0, color: '#666666'),
                          )
                          // medicineMap['pharmacistSign'] != null
                          //     ? Transform.rotate(
                          //   angle: 270.17,
                          //   child: Image.memory(
                          //     const Base64Decoder().convert(
                          //         medicineMap['pharmacistSign']),
                          //     scale: 1,
                          //     width: 54.0,
                          //     height: 24.0,
                          //   ),
                          // )
                          //     : Container()
                        ]),
                        Row(children: <Widget>[
                          Text(
                            '审核时间：',
                            style: GSYConstant.textStyle(
                              fontSize: 13.0,
                              color: '#333333',
                            ),
                          ),
                          Text(
                            auditingTime,
                            style: GSYConstant.textStyle(
                                color: '#06B48D', fontSize: 13.0),
                          )
                        ])
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(
                    top: 18.0,
                  ),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Expanded(
                            //   child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '通海县人民医院电子处方',
                                  style: GSYConstant.textStyle(
                                      fontSize: 18.0,
                                      color: '#333333',
                                      fontFamily: 'Medium',
                                      fontWeight: FontWeight.w500),
                                ),
                                Text('医疗机构编码：346987654321123H',
                                    style: GSYConstant.textStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: '#888888')),
                              ],
                            ),
                            const SizedBox(
                              width: 23.0,
                            ),
                            SvgUtil.svg(rpDetailItem['status'] == 1
                                ? 'revoke.svg'
                                : rpDetailItem['status'] == 2
                                    ? 'in_pass.svg'
                                    : rpDetailItem['status'] == 3
                                        ? 'already_audit.svg'
                                        : rpDetailItem['status'] == 4
                                            ? 'audit.svg'
                                            : rpDetailItem['status'] == 5
                                                ? 'timeout.svg'
                                                : 'cancel.svg'),
                          ]),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Wrap(
                        runSpacing: 10.0,
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(16.0)),
                            width: MediaQuery.of(context).size.width / 3,
                            // padding:const EdgeInsets.only(left: 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '姓名：',
                                  style:
                                      GSYConstant.textStyle(color: '#333333'),
                                ),
                                Text(
                                  rpDetailItem['name'] ?? '',
                                  style: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#666666'),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(16.0)),
                            width: MediaQuery.of(context).size.width / 3,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '性别：',
                                  style:
                                      GSYConstant.textStyle(color: '#333333'),
                                ),
                                Text(
                                  rpDetailItem['sex'] == '1' ? '男' : '女',
                                  style: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#666666'),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '年龄：',
                                  style:
                                      GSYConstant.textStyle(color: '#333333'),
                                ),
                                Text(
                                  '${rpDetailItem['age']}岁',
                                  style: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#666666'),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(16.0)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '费用：',
                                  style:
                                      GSYConstant.textStyle(color: '#333333'),
                                ),
                                Text(
                                  '自费 ',
                                  style: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#666666'),
                                )
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   width: ScreenUtil().setWidth(72.0),
                          // ),
                          Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(16.0)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    '科别：',
                                    style:
                                        GSYConstant.textStyle(color: '#333333'),
                                  ),
                                  Text(
                                    rpDetailItem['deptName'] ?? '',
                                    style: GSYConstant.textStyle(
                                        fontSize: 14.0, color: '#666666'),
                                  )
                                ],
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 1,
                                  color: ColorsUtil.hexStringColor('#cccccc',
                                      alpha: 0.2))),
                        ),
                        height: 39.0,
                        // margin: const EdgeInsets.only(left: 25.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'NO：',
                                    style:
                                        GSYConstant.textStyle(color: '#333333'),
                                  ),
                                  Text(
                                    rpDetailItem['recipeNo'],
                                    style:
                                        GSYConstant.textStyle(color: '#666666'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 1,
                                  color: ColorsUtil.hexStringColor('#cccccc',
                                      alpha: 0.2)),
                              bottom: BorderSide(
                                  width: 1,
                                  color: ColorsUtil.hexStringColor('#cccccc',
                                      alpha: 0.2))),
                        ),
                        height: 39.0,
                        // margin: const EdgeInsets.only(left: 25.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '开方：',
                                    style:
                                        GSYConstant.textStyle(color: '#333333'),
                                  ),
                                  Text(
                                    rpDetailItem['repictDate'],
                                    style:
                                        GSYConstant.textStyle(color: '#666666'),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        // height: 39.0,
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 8.0, bottom: 8.0),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '诊断：',
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                            Flexible(
                              child: Text(
                                diagnosis,
                                style: GSYConstant.textStyle(color: '#666666'),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 16.0),
                      height: 41.0,
                      child: Text(
                        'Rp',
                        style: GSYConstant.textStyle(
                            fontSize: 16.0, color: '#333333'),
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                    ),
                    Visibility(
                        visible: herbalMedicineVOS.isNotEmpty,
                        child: Column(children: <Widget>[
                          Column(
                              children: herbalMedicineVOS
                                  .asMap()
                                  .keys
                                  .map((index) => Container(
                                        height: 40.0,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: index ==
                                                            herbalMedicineVOS
                                                                    .length -
                                                                1
                                                        ? 0
                                                        : 1.0,
                                                    color: ColorsUtil
                                                        .hexStringColor(
                                                            '#cccccc',
                                                            alpha: 0.3))),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                herbalMedicineVOS[index]
                                                    ['medicineName'],
                                                style: GSYConstant.textStyle(
                                                    fontSize: 14.0,
                                                    color: '#333333'),
                                              ),
                                              Text(
                                                herbalMedicineVOS[index]
                                                    ['medicineNum'].toString() + herbalMedicineVOS[index]
                                                    ['packageUnitid_dictText'],
                                                style: GSYConstant.textStyle(
                                                    fontSize: 14.0,
                                                    color: '#666666'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList()),
                          Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            height: 41.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '服用贴数',
                                  style: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#333333'),
                                ),
                                Text(
                                  countNum,
                                  style: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#666666'),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                  width: 1.0,
                                  color: ColorsUtil.hexStringColor('#cccccc',
                                      alpha: 0.3),
                                ))),
                          ),
                          Container(
                            height: 40.0,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: ColorsUtil.hexStringColor(
                                            '#cccccc',
                                            alpha: 0.3))),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '用法',
                                    style: GSYConstant.textStyle(
                                        fontSize: 14.0, color: '#333333'),
                                  ),
                                  Text(
                                    useType_dictText,
                                    style: GSYConstant.textStyle(
                                        fontSize: 14.0, color: '#666666'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 40.0,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: ColorsUtil.hexStringColor(
                                            '#cccccc',
                                            alpha: 0.3))),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '频次',
                                    style: GSYConstant.textStyle(
                                        fontSize: 14.0, color: '#333333'),
                                  ),
                                  Text(
                                    freq_dictText,
                                    style: GSYConstant.textStyle(
                                        fontSize: 14.0, color: '#666666'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 40.0,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: ColorsUtil.hexStringColor(
                                            '#cccccc',
                                            alpha: 0.3))),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '备注',
                                    style: GSYConstant.textStyle(
                                        fontSize: 14.0, color: '#333333'),
                                  ),
                                  const SizedBox(width:15.0),
                                  Text(
                                    remarks,
                                    style: GSYConstant.textStyle(
                                        fontSize: 14.0, color: '#666666'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ])),
                    Visibility(
                      visible: medicineVOS.isNotEmpty,
                      child: Column(
                        children: medicineVOS
                            .map<Widget>(
                              (item) => Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 8.0,
                                    bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // "medicineVOS": [
                                    //   {
                                    //   "manuname": "",
                                    //   "freq": "1片,1次/12h",
                                    //   "amt": "2.79",
                                    //   "dayNum": "1",
                                    //   "specification": "0.25g*6片",
                                    //   "id": 75776,
                                    //   "useType": "冲化",
                                    //   "remarks": "gvv",
                                    //   "medicineNum": 1
                                    //   }
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          item['medicineName'] ?? '',
                                          style: GSYConstant.textStyle(
                                              color: '#333333'),
                                        ),
                                        Text(
                                          '规格：${item['specification']}',
                                          style: GSYConstant.textStyle(
                                              fontSize: 13.0, color: '#666666'),
                                        ),
                                        Text(
                                          '${item['useType_dictText']}：${item['freq_dictText']}',
                                          style: GSYConstant.textStyle(
                                              fontSize: 13.0, color: '#666666'),
                                        )
                                      ],
                                    ),
                                    Text(
                                      'x${item['medicineNum']}',
                                      style: GSYConstant.textStyle(
                                          color: '#666666'),
                                    )
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: const EdgeInsets.only(
                          top: 12.0, bottom: 12.0, left: 16.0, right: 29.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    '处方医师',
                                    style:
                                        GSYConstant.textStyle(color: '#333333'),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  Visibility(
                                      visible: doctorSign.isNotEmpty,
                                      child: Transform.rotate(
                                        angle: 270.17,
                                        child: Image.memory(
                                          const Base64Decoder()
                                              .convert(doctorSign),
                                          scale: 1,
                                          width: 54.0,
                                          height: 24.0,
                                        ),
                                      ))
                                  //     gaplessPlayback: true),) ,),
                                ],
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '审方医师',
                                    style:
                                        GSYConstant.textStyle(color: '#333333'),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  Visibility(
                                      visible: pharmacistSign.isNotEmpty,
                                      child: Transform.rotate(
                                        angle: 270.17,
                                        child: Image.memory(
                                          const Base64Decoder()
                                              .convert(pharmacistSign),
                                          scale: 1,
                                          width: 54.0,
                                          height: 24.0,
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                          Visibility(
                              visible: companySign.isNotEmpty,
                              child: Image.memory(
                                const Base64Decoder().convert(companySign),
                                scale: 1,
                                width: 54.0,
                                height: 54.0,
                              ))
                        ],
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 13.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '备注：',
                              style: GSYConstant.textStyle(
                                  fontSize: 13.0, color: '#666666'),
                            ),
                            const SizedBox(
                              height: 7.0,
                            ),
                            Text(
                              '1、处方有效期为3天，请及时取药',
                              style: GSYConstant.textStyle(
                                  fontSize: 13.0, color: '#666666'),
                            ),
                            Text(
                              '2、本处方限于通海互联网医院使用，自行下载配药不具有处方效力。',
                              style: GSYConstant.textStyle(
                                  fontSize: 13.0, color: '#666666'),
                            ),
                            Text(
                              '3、按照卫生部、国家中医药管理局卫医发[2002]24号文件规定：为保证患者用药安全，药品一经发出，不得退换。',
                              style: GSYConstant.textStyle(
                                  fontSize: 13.0, color: '#666666'),
                            ),
                            Text(
                              '4、按照网订店送的方式，您的处方将由门店发药药师审核，确认用药无误签字后方可生效。',
                              style: GSYConstant.textStyle(
                                  fontSize: 13.0, color: '#666666'),
                            ),
                            Text(
                              '5、服用三天症状未见好转，建议及时复诊或线下就医。',
                              style: GSYConstant.textStyle(
                                  fontSize: 13.0, color: '#666666'),
                            ),
                            const SizedBox(
                              height: 17.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // border-radius: 5px;
                                // border: 1px solid #06B48D;
                                Visibility(
                                    visible: rpDetailItem['status'] == 2,
                                    child: Expanded(
                                        child: CustomOutlineButton(
                                            title: '再次提交',
                                            onPressed: () {},
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderColor:
                                                ColorsUtil.hexStringColor(
                                                    '#06B48D')))),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                Visibility(
                                    visible: rpDetailItem['status'] == 2 ||
                                        rpDetailItem['status'] == 4,
                                    child: Expanded(
                                        child: CustomOutlineButton(
                                            title: '撤销',
                                            onPressed: () async {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (_) => WillPopScope(
                                                        onWillPop: () async {
                                                          return Future.value(
                                                              false);
                                                        },
                                                        child: AlertDialog(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 27.0,
                                                                  bottom: 28.0),
                                                          contentTextStyle: TextStyle(
                                                              fontSize: 16.0,
                                                              color: ColorsUtil
                                                                  .hexStringColor(
                                                                      '#333333')),
                                                          content: const Text(
                                                            "请确认是否撤单\n撤单后将自动退款给患者",
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          buttonPadding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          actions: [
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                    child:
                                                                        CustomOutlineButton(
                                                                  height: 40.0,
                                                                  borderColor:
                                                                      ColorsUtil
                                                                          .hexStringColor(
                                                                              '#06B48D'),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  title: '取消',
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pop();
                                                                    // Navigator.of(context).pop();
                                                                  },
                                                                )),
                                                                const SizedBox(
                                                                  width: 8.0,
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        CustomElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    var request =
                                                                        HttpRequest
                                                                            .getInstance();
                                                                    var res = await request.post(
                                                                        Api.revokeRpApi +
                                                                            '',
                                                                        {
                                                                          'id':
                                                                              rpDetailItem['id']
                                                                        });
                                                                    if (res['code'] ==
                                                                        200) {
                                                                      Navigator.of(
                                                                              context,
                                                                              rootNavigator: true)
                                                                          .pop();
                                                                      Navigator.pop(
                                                                          context);
                                                                    } else {
                                                                      Navigator.of(
                                                                              context,
                                                                              rootNavigator: true)
                                                                          .pop();
                                                                      Navigator.pop(
                                                                          context);
                                                                      ToastUtil.showToast(
                                                                          msg: res[
                                                                              'msg']);
                                                                    }
                                                                  },
                                                                  height: 40.0,
                                                                  title: '确定',
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ))
                                                              ],
                                                            ),
                                                          ],
                                                          // title: Text("请确认是否撤单")
                                                        ),
                                                      ));
                                              // var request = HttpRequest.getInstance();
                                              // var res = await request.get(Api.revokeRpApi+'?orderId=${medicineMap['orderId']}', {});
                                              // if(res['code']==200){
                                              //   Navigator.pop(context);
                                              // }
                                            },
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderColor:
                                                ColorsUtil.hexStringColor(
                                                    '#06B48D')))),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                // Visibility(
                                //     visible: rpDetailItem['status'] == 4 ||
                                //         rpDetailItem['status'] == 2,
                                //     child: Expanded(
                                //         child: CustomOutlineButton(
                                //             title: '重新开方',
                                //             onPressed: () {
                                //               // Navigator.popUntil(context, (route) => false);
                                //             },
                                //             borderRadius:
                                //                 BorderRadius.circular(5.0),
                                //             borderColor:
                                //                 ColorsUtil.hexStringColor(
                                //                     '#06B48D')))),
                                // const SizedBox(
                                //   width: 8.0,
                                // ),
                                Visibility(
                                    visible: rpDetailItem['status'] == 3 ||
                                        rpDetailItem['status'] == 4 ||
                                        rpDetailItem['status'] == 2 ||
                                        rpDetailItem['status'] == 5,
                                    child: Expanded(
                                        child: CustomElevatedButton(
                                      title: '患者通知',
                                      onPressed: () {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (_) => WillPopScope(
                                                  onWillPop: () async {
                                                    return Future.value(false);
                                                  },
                                                  child: AlertDialog(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 21.0),
                                                    contentTextStyle: TextStyle(
                                                        fontSize: 15.0,
                                                        color: ColorsUtil
                                                            .hexStringColor(
                                                                '#333333')),
                                                    // title: Text("提示信息"),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          80),
                                                              child: Text(
                                                                '就诊人',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: GSYConstant
                                                                    .textStyle(
                                                                        fontSize:
                                                                            16.0,
                                                                        color:
                                                                            '#666666'),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                child: Text(
                                                                  rpDetailItem[
                                                                          'name'] ??
                                                                      '',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: GSYConstant.textStyle(
                                                                      fontSize:
                                                                          16.0,
                                                                      color:
                                                                          '#333333'),
                                                                ))
                                                          ],
                                                        ),
                                                        // const SizedBox(height: 9.0,),
                                                        // Row(
                                                        //   mainAxisAlignment:
                                                        //       MainAxisAlignment
                                                        //           .center,
                                                        //   children: <Widget>[
                                                        //     SizedBox(
                                                        //       width: 65.0,
                                                        //       child: Text(
                                                        //         '数量',
                                                        //         textAlign: TextAlign.right,
                                                        //         style: GSYConstant
                                                        //             .textStyle(
                                                        //                 fontSize:
                                                        //                     16.0,
                                                        //                 color:
                                                        //                     '#666666'),
                                                        //       ),
                                                        //     ),
                                                        //     const SizedBox(width: 15.0,),
                                                        //     SizedBox(
                                                        //       width: 72.0,
                                                        //       child: Text(
                                                        //         '5',
                                                        //         textAlign: TextAlign.left,
                                                        //         style: GSYConstant
                                                        //             .textStyle(
                                                        //                 fontSize:
                                                        //                     16.0,
                                                        //                 color:
                                                        //                     '#DE5347'),
                                                        //       ),
                                                        //     )
                                                        //   ],
                                                        // ),
                                                        const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          80),
                                                              child: Text(
                                                                '待缴费',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: GSYConstant
                                                                    .textStyle(
                                                                        fontSize:
                                                                            16.0,
                                                                        color:
                                                                            '#666666'),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                child: Text(
                                                                  '${NumUtil.getNumByValueStr(medicineMap['amt'], fractionDigits: 2)}元',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: GSYConstant.textStyle(
                                                                      fontSize:
                                                                          16.0,
                                                                      color:
                                                                          '#DE5347'),
                                                                ))
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 11.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          80),
                                                              child: Text(
                                                                '缴费类型',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: GSYConstant
                                                                    .textStyle(
                                                                        fontSize:
                                                                            16.0,
                                                                        color:
                                                                            '#666666'),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 15.0,
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                child: Text(
                                                                  '医药费',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: GSYConstant.textStyle(
                                                                      fontSize:
                                                                          16.0,
                                                                      color:
                                                                          '#DE5347'),
                                                                ))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    buttonPadding:
                                                        EdgeInsets.zero,
                                                    actions: [
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                              child:
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context,
                                                                                rootNavigator: true)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            40.0,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration:
                                                                            BoxDecoration(border: Border(right: BorderSide(width: 0.5, color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.4)), top: BorderSide(width: 1.0, color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.4)))),
                                                                        child:
                                                                            Text(
                                                                          '取消',
                                                                          style: GSYConstant.textStyle(
                                                                              fontSize: 16.0,
                                                                              color: '#333333'),
                                                                        ),
                                                                      ))),
                                                          Expanded(
                                                              child:
                                                                  GestureDetector(
                                                            onTap: () async {
                                                              var request =
                                                                  HttpRequest
                                                                      .getInstance();
                                                              var res =
                                                                  await request
                                                                      .post(
                                                                          Api.sendRpNoticeApi,
                                                                          {
                                                                    'id':
                                                                        rpDetailItem[
                                                                            'id']
                                                                  });
                                                              if (res['code'] ==
                                                                  200) {
                                                                // Navigator.of(
                                                                //         context,
                                                                //         rootNavigator:
                                                                //             true)
                                                                //     .pop();
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop();
                                                                if (rpDetailItem[
                                                                        'isFlag'] !=
                                                                    '1') {
                                                                  ToastUtil
                                                                      .showToast(
                                                                          msg:
                                                                              '发送成功');
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushReplacement(MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Main()));
                                                                } else {
                                                                  Navigator.pop(
                                                                      context);
                                                                }

                                                                // Navigator.popUntil(context, ModalRoute.withName("/TabHome"));
                                                              } else {
                                                                ToastUtil.showToast(
                                                                    msg: res[
                                                                        'msg']);
                                                              }
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 40.0,
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      left: BorderSide(
                                                                          width:
                                                                              0.5,
                                                                          color: ColorsUtil.hexStringColor(
                                                                              '#cccccc',
                                                                              alpha:
                                                                                  0.4)),
                                                                      top: BorderSide(
                                                                          width:
                                                                              1.0,
                                                                          color: ColorsUtil.hexStringColor(
                                                                              '#cccccc',
                                                                              alpha: 0.4)))),
                                                              child: Text(
                                                                '发送提醒',
                                                                style: GSYConstant
                                                                    .textStyle(
                                                                        fontSize:
                                                                            16.0,
                                                                        color:
                                                                            '#06B48D'),
                                                              ),
                                                            ),
                                                          ))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                      },
                                      borderRadius: BorderRadius.circular(5.0),
                                    )))
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
