import 'dart:convert';
import 'dart:typed_data';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../http/api.dart';

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
  Map<String, dynamic> medicineMap = {};

  _RecipeDetailState(this.rpDetailItem, this.diagnosis);

  @override
  void initState() {
    super.initState();
    print('${this.rpDetailItem}');
    initData();
  }

  initData() async {
    var request = HttpRequest.getInstance();
    var res = await request
        .get(Api.getRpDetailApi + '?recipeId=${rpDetailItem['id']}', {});
    if (res['code'] == 200) {
      print('111111,${res['data']['doctorSign']}');
      setState(() {
        medicineMap = res['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      // primary: true,
      appBar: CustomAppBar(
        '处方详情',
        onBackPressed: () {
          Navigator.pop(context);
        },
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
                                        ? '审核超时'
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
                          '列表中的克拉霉素胶囊对患者病情有刺激性。',
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
                            '审核药师：',
                            style: GSYConstant.textStyle(
                              fontSize: 13.0,
                              color: '#333333',
                            ),
                          ),
                          Text(
                            '张兰',
                            style: GSYConstant.textStyle(
                                color: '#06B48D', fontSize: 13.0),
                          )
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
                            '2022-02-22 13:00:56',
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
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                                        : 'timeout.svg'),
                        const SizedBox(
                          width: 19.0,
                        )
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 18.0, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
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
                            Row(
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
                            Row(
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  '费用：',
                                  style:
                                      GSYConstant.textStyle(color: '#333333'),
                                ),
                                Text(
                                  '自费',
                                  style: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#666666'),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 72.0,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '科别：',
                                  style:
                                      GSYConstant.textStyle(color: '#333333'),
                                ),
                                Text(
                                  rpDetailItem['deptName'],
                                  style: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#666666'),
                                )
                              ],
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
                                    'NO：',
                                    style:
                                        GSYConstant.textStyle(color: '#333333'),
                                  ),
                                  Flexible(
                                    child: Text(
                                      rpDetailItem['recipeNo'],
                                      style: GSYConstant.textStyle(
                                          color: '#666666'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 25.0,
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '开方：',
                                    style:
                                        GSYConstant.textStyle(color: '#333333'),
                                  ),
                                  Flexible(
                                    child: Text(
                                      rpDetailItem['repictDate'],
                                      style: GSYConstant.textStyle(
                                          color: '#666666'),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 39.0,
                        padding: const EdgeInsets.only(left: 16.0),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '诊断：',
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                            Text(
                              diagnosis,
                              style: GSYConstant.textStyle(color: '#666666'),
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
                    Column(
                      children: (medicineMap['herbalMedicineVOS'] ?? medicineMap['medicineVOS']?? []).map<Widget>(
                                (item) => Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            item['manuname'] ?? '',
                                            style: GSYConstant.textStyle(
                                                color: '#333333'),
                                          ),
                                          Text(
                                            '规格：${item['specification']}',
                                            style: GSYConstant.textStyle(
                                                fontSize: 13.0,
                                                color: '#666666'),
                                          ),
                                          Text(
                                            '${medicineMap['herbalMedicineVOS']!=null?medicineMap['useType']:item['useType']}：${medicineMap['herbalMedicineVOS']!=null?medicineMap['freq']:item['freq']}',
                                            style: GSYConstant.textStyle(
                                                fontSize: 13.0,
                                                color: '#666666'),
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
                              ).toList(),
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
                                  const SizedBox(width: 15.0,),
                                  medicineMap['doctorSign'] != null
                                      ? Transform.rotate(
                                          angle: 270.15,
                                          child: Image.memory(
                                            const Base64Decoder()
                                                .convert(medicineMap['doctorSign']),
                                            scale: 1,
                                            width: 54.0,
                                            height: 18.0,
                                          ),
                                        )
                                      : Container()
                                  //     gaplessPlayback: true),) ,),
                                ],
                              ),
                              const SizedBox(
                                height: 24.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '审方医师',
                                    style:
                                        GSYConstant.textStyle(color: '#333333'),
                                  ),
                                  medicineMap['pharmacistSign'] != null
                                      ? Transform.rotate(
                                          angle: 270.15,
                                          child: Image.memory(
                                            const Base64Decoder()
                                                .convert(medicineMap['pharmacistSign']),
                                            scale: 1,
                                            width: 54.0,
                                            height: 18.0,
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ],
                          ),
                          medicineMap['companySign'] != null
                              ? Image.memory(
                                  const Base64Decoder()
                                      .convert(medicineMap['companySign']),
                                  scale: 0.5,
                                  width: 54.0,
                                  height: 54.0,
                                )
                              : Container()
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
                              '1、处方有效期为7天。 ',
                              style: GSYConstant.textStyle(
                                  fontSize: 13.0, color: '#666666'),
                            ),
                            Text(
                              '2、该处方不支持线下药房购药。',
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
                                    visible: rpDetailItem['status'] == 4,
                                    child: Expanded(
                                        child: CustomOutlineButton(
                                            title: '撤销',
                                            onPressed: () async {
                                              showDialog(
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
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                )),
                                                                const SizedBox(
                                                                  width: 8.0,
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        CustomElevatedButton(
                                                                  onPressed:
                                                                      () {},
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
                                Visibility(
                                    visible: rpDetailItem['status'] == 4 ||
                                        rpDetailItem['status'] == 2,
                                    child: Expanded(
                                        child: CustomOutlineButton(
                                            title: '重新开方',
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
                                    visible: rpDetailItem['status'] == 3 ||
                                        rpDetailItem['status'] == 4 ||
                                        rpDetailItem['status'] == 2 ||
                                        rpDetailItem['status'] == 5,
                                    child: Expanded(
                                        child: CustomElevatedButton(
                                      title: '患者通知',
                                      onPressed: () {},
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
