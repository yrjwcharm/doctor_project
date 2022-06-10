import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor_project/pages/my/my_doctorCode.dart';
import 'package:doctor_project/utils/common_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/my/my_income.dart';
import 'package:doctor_project/pages/my/settings.dart';
import 'package:doctor_project/pages/my/template_create.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/desensitization_utils.dart';
import '../my/basic_info.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyDoctorCode extends StatefulWidget {
  final String userId;
  const MyDoctorCode({Key? key, required this.userId}) : super(key: key);

  @override
  _MyDoctorCodeState createState() => _MyDoctorCodeState(this.userId);
}

class _MyDoctorCodeState extends State<MyDoctorCode> {

  String userId;

  _MyDoctorCodeState(this.userId);

  Map doctorInfoMap = {};
  String phoneStr = "";
  String doctorName = '';
  String drPhotoUrl = '';
  String deptName = '';
  String orgName = '';
  String protitle = '';
  String receiveNum = '';
  String waitReceiveNum = '';
  String videoRegisterNum = '';
  String codeData = '';
  String expertIn  = '';
//   String user_Id = '';

  //获取医生信息
  getNet_doctorCode() async {
    SharedPreferences perfer = await SharedPreferences.getInstance();
    String phone_str = (perfer.getString("phone") ?? "");
    phoneStr = DesensitizationUtil.desensitizationMobile(phone_str);
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.getDoctorCode, {});
    print("getNet_doctorCode------" + res.toString());

    if (res['code'] == 200) {
        if (res['data'].isNotEmpty) {
        codeData = res['data'];
      }
    //   drPhotoUrl = res['data']['photoUrl'];
    //   doctorName = res['data']['realName'];
    //   orgName = res['data']['orgName'] ?? '';
    //   deptName = res['data']['deptName'] ?? '';
    //   protitle = res['data']['protitle_dictText'] ?? '';
    //   receiveNum = res['data']['receiveNum'].toString();
    //   waitReceiveNum = res['data']['waitReceiveNum'].toString();
    //   videoRegisterNum = res['data']['videoRegisterNum'].toString();
    //   user_Id = res['data']['userId'].toString();
      setState(() {});
    }

  }
  getNet_doctorInfo() async {
    SharedPreferences perfer = await SharedPreferences.getInstance();
    String phone_str = (perfer.getString("phone") ?? "");
    phoneStr = DesensitizationUtil.desensitizationMobile(phone_str);
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.getDoctorInfoUrl, {});
    print("getNet_doctorInfo------" + res.toString());

    if (res['code'] == 200) {
      doctorInfoMap = res['data'];
      drPhotoUrl = res['data']['photoUrl'];
      doctorName = res['data']['realName'];
      orgName = res['data']['orgName'] ?? '';
      deptName = res['data']['deptName'] ?? '';
      protitle = res['data']['protitle_dictText'] ?? '';
      receiveNum = res['data']['receiveNum'].toString();
      waitReceiveNum = res['data']['waitReceiveNum'].toString();
      videoRegisterNum = res['data']['videoRegisterNum'].toString();
      expertIn = res['data']['expertIn'] ?? '';
    //   userId = res['data']['userId'].toString();
      setState(() {});
    }
  }
  @override
  initState() {
    super.initState();
    getNet_doctorCode();
    getNet_doctorInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar('我的名片',onBackPressed: (){
         Navigator.pop(context);
       },),
       backgroundColor: Colors.white,
              body: Column(
        children: <Widget>[
          Container(
            // margin: const EdgeInsets.only(top: 19.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Image.memory(
                    const Base64Decoder().convert(codeData),
                    scale: 1,
                    width: 200.0,
                    height:200.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

