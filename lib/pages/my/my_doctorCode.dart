import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor_project/pages/my/my_doctorCode.dart';
import 'package:doctor_project/utils/common_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:flutter/painting.dart';
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
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.getDoctorCode, {});
    print("getNet_doctorCode------" + res.toString());

    if (res['code'] == 200) {
      if (res['data'].isNotEmpty) {
        codeData = res['data'];
      }
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
      orgName = res['data']['orgName'] ?? '';//医院名字
      deptName = res['data']['deptName'] ?? '';//科室
      protitle = res['data']['protitle_dictText'] ?? '';
      receiveNum = res['data']['receiveNum'].toString();
      waitReceiveNum = res['data']['waitReceiveNum'].toString();
      videoRegisterNum = res['data']['videoRegisterNum'].toString();
      expertIn = res['data']['expertIn'] ?? '';//擅长
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

    Widget buildBg = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/home/rect.png',
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top:80.0,left: 16.0,right: 16.0),
          height: 500,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/my/code_whiteback.png',
              ),
            ),
          ),
        ),
//        Positioned(
//          top: MediaQuery.of(context).padding.top + 81,
//          left: 16.0,
//          right: 16.0,
//          height: 500,
//          child: Container(
//            width: MediaQuery.of(context).size.width, // 获取屏幕尺寸,
//            padding: const EdgeInsets.only(
//                top: 12.0, bottom: 13.0, left: 16.0, right: 16.0),
//            // margin:const EdgeInsets.symmetric(horizontal: 16.0),
//            decoration: BoxDecoration(
//              color: Colors.white,
//              borderRadius: BorderRadius.circular(5.0),
//            ),
//          ),
//        ),
        Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  <Widget>[
              Container(
                  height: 88.0,
                  width: 88.0,
                  margin: const EdgeInsets.only(top: 33.0,left: 20.0,right: 20.0),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(44.0)),
                  child: Visibility(
                      visible: drPhotoUrl.isNotEmpty,
                      child: Image.network(
                        drPhotoUrl,
                        fit: BoxFit.cover,
                      ))
              ),
              const SizedBox(
                height: 6.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30.0,right: 30.0),
                child:
                Column(
                  children:<Widget>[
                    Container(
                      child:
                      Text(doctorName,style: GSYConstant.textStyle(fontSize: 20.0, color: '#333333',),),),
                    const SizedBox(height: 6.0,),
                    Text(orgName+" | "+deptName,style:GSYConstant.textStyle(fontSize: 16.0, color: '#333333',) ,),
                    const SizedBox(height: 6.0,),
                    RichText(
                      maxLines: 1,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "擅长 : ",
                            style: TextStyle(fontSize: 16.0, color: Color.fromRGBO(51, 51, 51, 1),),
                          ),
                          TextSpan(
                            text: expertIn,
                            style: TextStyle(fontSize: 16.0,color: Color.fromRGBO(136, 136, 136, 1),),
                          ),
                        ],
                      ),),
                    const SizedBox(height: 48.0,),
                    Image.memory(
                      const Base64Decoder().convert(codeData),
                      scale: 1,
                      alignment: Alignment.center,
                      width: 252.0,
                      height:252.0,
                    ),
                    const SizedBox(height: 6.0,),
                    Text("扫一扫上面的二维码，进入小程序",style:GSYConstant.textStyle(fontSize: 16.0, color: '#666666',) ,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '我的名片',
      ),
      body: Column(
        children: [
          buildBg,
        ],
      ),
    );
  }
}
