import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctor_project/pages/my/my_prescription.dart';
import 'package:doctor_project/pages/my/my_doctorCode.dart';
import 'package:doctor_project/pages/home/service_settings.dart';
import 'package:doctor_project/pages/home/inquiry_record.dart';
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

class My extends StatefulWidget {
  const My({Key? key}) : super(key: key);

  @override
  MyState createState() => MyState();
}

class MyState extends State<My> {
  late File _image;
  List listRow = [
    // {
    //   'label': '医生资质上传',
    //   'borderRadius': const BorderRadius.vertical(top: Radius.circular(5.0)),
    //   'icon': 'assets/images/my/qualifications.png'
    // },
    {
      'label': '基本信息',
      'borderRadius': const BorderRadius.vertical(bottom: Radius.circular(5.0)),
      'icon': 'assets/images/my/information.png'
    },
    {
      'label': '维护问诊信息',
      'borderRadius': const BorderRadius.vertical(top: Radius.circular(5.0)),
      'icon': 'assets/images/my/consultation_information.png'
    },
    {
      'label': '问诊记录',
      'borderRadius': const BorderRadius.vertical(bottom: Radius.circular(0)),
      'icon': 'assets/images/my/consultation_record.png'
    },
    {
      'label': '我的处方',
      'borderRadius': const BorderRadius.vertical(bottom: Radius.circular(0.0)),
      'icon': 'assets/images/my/my_rp.png'
    },
    // {
    //   'label': '我的收入',
    //   'borderRadius': const BorderRadius.vertical(bottom: Radius.circular(0.0)),
    //   'icon': 'assets/images/my/my_income.png'
    // },
    {
      'label': '模版创建',
      'borderRadius': const BorderRadius.vertical(bottom: Radius.circular(5.0)),
      'icon': 'assets/images/my/template_creation.png'
    },
    {
      'label': '我的名片',
      'borderRadius': const BorderRadius.vertical(bottom: Radius.circular(5.0)),
      'icon': 'assets/images/my/card.png'
    },
    // {
    //   'label': '基本信息',
    //   'borderRadius': const BorderRadius.vertical(bottom: Radius.circular(5.0)),
    //   'icon': 'assets/images/my/information.png'
    // }
  ];
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
  String userId = '';

  //获取医生信息
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
      userId = res['data']['userId'].toString();
      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
    getNet_doctorInfo();
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, maxWidth: 150, maxHeight: 150);
    setState(() {
      _image = File((image?.path)!);
    });
    String? path = image?.path;
    _uploadAvatar(path!);
  }

  _uploadAvatar(String path) async {
    var request = HttpRequest.getInstance();
    FormData formData =
        FormData.fromMap({'file': await MultipartFile.fromFile(path)});
    var result = await request.uploadFile(Api.uploadImgApi, formData);
    var $result =
        await request.post(Api.updateAvatar, {'avatar': result['data']['url']});
    if ($result['code'] == 200) {
      getNet_doctorInfo();
    }
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 150, maxHeight: 150);
    _image = File((image?.path)!);
    setState(() {
      _image = File((image?.path)!);
    });
    String? path = image?.path;
    _uploadAvatar(path!);
  }

  Future<void> _handleClickMe(BuildContext context) async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('上传图片'),
          message: const Text('请选择上传方式'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('拍照上传'),
              onPressed: () {
                _takePhoto();
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('相册'),
              onPressed: () {
                _openGallery();
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: const Text('取消'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget headerSection = Stack(clipBehavior: Clip.none, children: [
      Container(
        padding: const EdgeInsets.only(top: 24.0, right: 16.0, left: 16.0),
        height: 169,
        decoration: BoxDecoration(color: ColorsUtil.hexStringColor('#07CF9D')),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Settings()));
              },
              child: Container(
                alignment: Alignment.topRight,
                child: const Image(
                  image: AssetImage('assets/images/my/setup.png'),
                  fit: BoxFit.cover,
                  width: 18.0,
                  height: 18.0,
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      _handleClickMe(context);
                    },
                    child: Visibility(
                        visible: drPhotoUrl.isNotEmpty,
                        child: Container(
                            height: 55.0,
                            width: 55.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27.5)),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              drPhotoUrl,
                              fit: BoxFit.cover,
                            )))),
                const SizedBox(
                  width: 15.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Medium',
                        color: Colors.white,
                      ),
                    ),
                    Visibility(
                        visible: phoneStr.isNotEmpty,
                        child: Text(
                          phoneStr,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            fontFamily:
                                'PingFangSC-Regular-Medium, PingFang SC',
                            color: Colors.white,
                          ),
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
      Positioned(
          top: 130.0,
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star,
                        size: 16.0,
                        color: ColorsUtil.hexStringColor('#FF9C00')),
                    const SizedBox(
                      width: 9.0,
                    ),
                    Text(
                      '5',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Medium',
                          fontWeight: FontWeight.w500,
                          color: ColorsUtil.hexStringColor('#FF9C00')),
                    ),
                  ],
                )),
                Image.asset('assets/images/my/line.png'),
                // const Image(width:1.0,height:16.0,image: AssetImage('assets/images/my/line.png'),fit:BoxFit.cover),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '接诊量',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'PingFangSC-Regular, PingFang SC',
                          color: ColorsUtil.hexStringColor('#999999')),
                    ),
                    const SizedBox(
                      width: 9.0,
                    ),
                    Text(
                      receiveNum,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Medium',
                          color: ColorsUtil.hexStringColor('#06B48D')),
                    )
                  ],
                ))
              ],
            ),
          ))
    ]);
    return Scaffold(
      backgroundColor: ColorsUtil.hexStringColor('#f9f9f9'),
      appBar: CustomAppBar(
        '我的',
        isBack: false,
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        headerSection,
        const SizedBox(
          height: 30.0,
        ),
        Column(
            children: listRow
                .asMap()
                .keys
                .map<Widget>(
                  (index) => GestureDetector(
                    onTap: () {
                      switch (index) {
                        // case 0:
                        //   break;
                        case 0:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BasicInfo()));
                          break;
                        case 1:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const ServiceSettings()));
                          break;
                        case 2:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InquiryRecord(userId: userId)));
                          break;
                        case 3:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyPrescription(userId: userId)));
                          break;
                        // case 5:
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => const MyIncome()));

                          // break;
                        case 4:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                       TemplateCreate(doctorId: userId,)));
                          break;
                        case 5:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyDoctorCode(userId: userId)));
                          break;
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 48.0,
                          margin: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              top: (index == 0 || index == 2) ? 8.0 : 0.0),
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: listRow[index]['borderRadius'],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  // font-size: 16px;
                                  //     font-family: PingFangSC-Regular, PingFang SC;
                                  // font-weight: 400;
                                  // color: #333333;
                                  Image.asset(listRow[index]['icon']),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(listRow[index]['label'],
                                      style: GSYConstant.textStyle(
                                          fontSize: 16.0, color: '#333333')),
                                ],
                              ),
                              SvgUtil.svg('_more.svg')
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(
                            height: 0,
                            color: ColorsUtil.hexStringColor('#cccccc',
                                alpha: 0.4),
                          ),
                        )
                      ],
                    ),
                  ),
                )
                .toList())
      ])),
    );
  }
}
