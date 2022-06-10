import 'package:doctor_project/common/local/local_storage.dart';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/custom_safeArea_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'case_template.dart';
import 'package:doctor_project/pages/my/write_case_detail.dart';
import '../../http/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class WriteCase extends StatefulWidget {
  String registeredId; //挂号Id
  Map userInfoMap;

  WriteCase({Key? key, required this.registeredId, required this.userInfoMap})
      : super(key: key);

  @override
  _WriteCaseState createState() => _WriteCaseState(
      registeredId: this.registeredId, userInfoMap: this.userInfoMap);
}

class _WriteCaseState extends State<WriteCase> {
  String registeredId; //挂号Id
  Map userInfoMap;

  _WriteCaseState({required this.registeredId, required this.userInfoMap});

  List list = [
    {'label': '就诊卡类型', 'value': '身份证', 'disabled': true, 'isArrow': false},
    {'label': '就诊卡号码', 'value': '', 'disabled': false, 'isArrow': false},
    {'label': '患者姓名', 'value': '', 'disabled': true, 'isArrow': false},
    {'label': '患者性别', 'value': '', 'disabled': true, 'isArrow': false},
    {'label': '出生日期', 'value': '', 'disabled': true, 'isArrow': false},
    {'label': '科室门诊', 'value': '', 'disabled': true, 'isArrow': false},
    {'label': '主诉', 'value': '请输入疾病', 'disabled': true, 'isArrow': true},
    {'label': '病史描述', 'value': '请输入病史描述', 'disabled': true, 'isArrow': true},
    {'label': '现病史', 'value': '请输入现病史', 'disabled': true, 'isArrow': true},
    {'label': '既往史', 'value': '请输入既往史', 'disabled': true, 'isArrow': true},
    {'label': '过敏史', 'value': '请输入过敏史', 'disabled': true, 'isArrow': true},
  ];
  List<Widget> widgets = const <Widget>[];
  Map contentMap = new Map();
  String billid = '';

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    // orderType: 0, sex_dictText: 男, orderId: 438473548739248128, patientId: 434594600976515072, sex: 1, photo: https://thirdwx.qlogo.cn/mmopen/vi_32/Rn6mndkYqAo7nglXbmvVnruEsh29dVRDRiaX89CrIAM8uNyiaHFFiceFaDdxNrv9yCA7guZdEMiawfBm3RFrVnU5Xw/132, type_dictText: 图文问诊, status_dictText: 接诊中, isRepeat_dictText: 是, type: 0, diseaseTime_dictText: 一月内, orderType_dictText: 复诊拿药, times: 2天前, diseaseTime: 2, diseaseData: [http://yywd-1302755873.cos.ap-nanjing.myqcloud.com/1650855302278.png], phone: 18311410379, name: 闫瑞锋, id: 438473548663750656, isRepeat: 2, age: 27, diseaseDesc: 陌陌, status: 1
    // print('222222${userInfoMap.toString()}');
    list[1]['value'] = userInfoMap['cardNo'];
    list[2]['value'] = userInfoMap['name'];
    list[3]['value'] = userInfoMap['sex_dictText'];
    list[4]['value'] = userInfoMap['birthday'];
    list[5]['value'] = userInfoMap['deptName'];
    var request = HttpRequest.getInstance();
    var res = await request
        .get(Api.queryCaseUrl + '?registerId=${userInfoMap["id"]}', {});
    if (res['code'] == 200) {
      billid = res['data']['billid'];
      list[6]["value"] = res['data']['extend8'].isEmpty ? '请输入疾病':res['data']['extend8'];
      list[7]["value"] = res['data']['extend9'].isEmpty ? '请输入病史描述':res['data']['extend9'];
      list[8]["value"] = res['data']['hpi'].isEmpty ? '请输入现病史':res['data']['hpi'];
      list[9]["value"] = res['data']['pasthistory'].isEmpty ? '请输入既往史':res['data']['pasthistory'];
      list[10]["value"] = res['data']['allergichistory'].isEmpty ? '请输入过敏史':res['data']['allergichistory'];
      setState(() {

      });
      // list[6].value =
    }
  }

  loadtDataForWriteCase() async {
    print('3333${billid}');
    Map<String, dynamic> params = {
      "billid": billid,
      //病历Id  非必填
      "registerid": registeredId,
      //挂号Id
      "extend8": list[6]["value"].indexOf("请输入") != -1 ? "" : list[6]["value"],
      //主诉
      "extend9": list[7]["value"].indexOf("请输入") != -1 ? "" : list[7]["value"],
      //病史描述
      "hpi": list[8]["value"].indexOf("请输入") != -1 ? "" : list[8]["value"],
      //现病史
      "pasthistory":
          list[9]["value"].indexOf("请输入") != -1 ? "" : list[9]["value"],
      //既往史
      "allergichistory":
          list[10]["value"].indexOf("请输入") != -1 ? "" : list[10]["value"],
      //过敏史
    };
    var request = HttpRequest.getInstance();
    var res = await request.post(Api.writeCaseUrl, params);
    if (res['code'] == 200) {
      //请求成功
      Fluttertoast.showToast(msg: "保存成功", gravity: ToastGravity.CENTER);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '写病历',
      
        //   isForward:true,child: Text('引入病例模板',style: GSYConstant.textStyle(color: '#06B48D'),),onForwardPressed: (){
        //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const CaseTemplate()));
        // },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: list
                      .asMap()
                      .keys
                      .map(
                        (index) => GestureDetector(
                          onTap: () {
                            if (index == 6 ||
                                index == 7 ||
                                index == 8 ||
                                index == 9 ||
                                index == 10) {
                              String str = list[index]['value'];
                              //判断某个字符串中是否存在amr字符，如果存在执行
                              if (str.contains("请输入")) {
                                contentMap["detail"] = "";
                              } else {
                                contentMap["detail"] = str;
                              }
                              contentMap["name"] = list[index]['label'];

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WriteCaseDetail(
                                            dataMap: contentMap,
                                          ))).then((value) {
                                if (value.isNotEmpty) {
                                  contentMap = value;
                                  Map item = list[index];
                                  setState(() {
                                    item["value"] = contentMap["detail"];
                                  });
                                }
                              });
                            } else if (index == 4) {}
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                height: 44.0,
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      list[index]['label'],
                                      style: GSYConstant.textStyle(
                                          color: '#333333'),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 250.0,
                                          // height: 44.0,
                                          child: TextField(
                                            cursorColor:
                                                ColorsUtil.hexStringColor(
                                                    '#888888'),
                                            enabled: !list[index]['disabled'],
                                            textAlign: TextAlign.end,
                                            // textAlignVertical: TextAlignVertical.center,
                                            style: GSYConstant.textStyle(
                                                color: '#888888'),
                                            decoration: InputDecoration(
                                                isCollapsed: true,
                                                border: InputBorder.none,
                                                hintStyle:
                                                    GSYConstant.textStyle(
                                                        color: '#888888'),
                                                hintText: list[index]['value']),
                                          ),
                                        )
                                        // Text(list[index]['value'],style: GSYConstant.textStyle(color: '#888888'),),
                                        ,
                                        SizedBox(
                                          width:
                                              list[index]['isArrow'] ? 8.0 : 0,
                                        ),
                                        list[index]['isArrow']
                                            ? Image.asset(
                                                'assets/images/arrow_right.png')
                                            : Container()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0,
                                color: ColorsUtil.hexStringColor('#cccccc',
                                    alpha: 0.3),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          )),
          SafeArea(
              child: CustomElevatedButton(
                margin: const EdgeInsets.only(left: 16.0,right:16.0,bottom:16.0,),
                height: 40.0,
                borderRadius: BorderRadius.circular(24.0),
            onPressed: () {
              loadtDataForWriteCase();
            },
            title: '保存',
          ))
        ],
      ),
    );
  }
}
