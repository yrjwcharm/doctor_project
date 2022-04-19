import 'dart:io';
import 'package:doctor_project/pages/my/my_prescription.dart';
import 'package:doctor_project/utils/svg_util.dart';

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

import '../my/basic_info.dart';
import 'package:cached_network_image/cached_network_image.dart';

class My extends StatefulWidget {
  const My({Key? key}) : super(key: key);

  @override
  MyState createState() => MyState();
}

class MyState extends State<My> {
  late File _image;
  List<Widget> items = [];
  Map doctorInfoMap = new Map();
  String phoneStr = "";

  //获取医生信息
  getNet_doctorInfo() async {
    SharedPreferences perfer = await SharedPreferences.getInstance();
    phoneStr = (perfer.getString("phone") ?? "");

    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.getDoctorInfoUrl, {});
    print("getNet_doctorInfo------" + res.toString());

    if (res['code'] == 200) {
      setState(() {
        doctorInfoMap = res['data'];
      });
    }
  }

  @override
  initState() {
    super.initState();
    items = [
      _buildListTile(
          id: 0,
          icon: 'assets/images/my/qualifications.png',
          title: '医生资质上传',
          onTap: () {}),
      _buildListTile(
          id: 1,
          icon: 'assets/images/my/information.png',
          title: '基本信息',
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BasicInfo()));
          }),
      _buildListTile(
          id: 2,
          icon: 'assets/images/my/consultation_information.png',
          title: '维护问诊信息',
          onTap: () {}),
      _buildListTile(
          id: 3,
          icon: 'assets/images/my/consultation_record.png',
          title: '问诊记录',
          onTap: () {}),
      _buildListTile(
          id: 4,
          icon: 'assets/images/my/my_rp.png',
          title: '我的处方',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyPrescription()));
          }),
      _buildListTile(
          id: 5,
          icon: 'assets/images/my/my_income.png',
          title: '我的收入',
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyIncome()));
          }),
      _buildListTile(
          id: 6,
          icon: 'assets/images/my/template_creation.png',
          title: '模版创建',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TemplateCreate()));
          }),
    ];

    getNet_doctorInfo();
  }

  _buildListTile(
      {required int id,
      required String icon,
      required String title,
      required GestureTapCallback onTap}) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: (id == 0 || id == 2)
                ? const BorderRadius.vertical(top: Radius.circular(5.0))
                : (id == 1 || id == 5)
                    ? const BorderRadius.vertical(bottom: Radius.circular(5.0))
                    : BorderRadius.circular(0.0)),
        margin: EdgeInsets.only(
            left: 16.0, right: 16.0, bottom: id == 2 ? 10.0 : 0, top: 0),
        child: Column(
          children: [
            ListTile(
              onTap: onTap,
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage(icon),
                    fit: BoxFit.cover,
                    width: 15.0,
                    height: 17.0,
                  ),
                  const SizedBox(
                    width: 9.0,
                  ),
                  Text(title, style: GSYConstant.textStyle(color: '#333333'))
                ],
              ),
              trailing: const Image(
                image: AssetImage('assets/images/my/more.png'),
                fit: BoxFit.cover,
                width: 8.0,
                height: 14.0,
              ),
            ),
            (id == 0 || id == 2 || id == 3 || id == 4)
                ? Divider(
                    height: 1,
                    color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.4))
                : const Divider(
                    height: 0,
                  )
          ],
        ));
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, maxWidth: 150, maxHeight: 150);
    // this._uploadImage(File(image.path));
    // print(image.path);

    _image = File((image?.path)!);
    // print(_image);

    setState(() {
      this._image = File((image?.path)!);
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 150, maxHeight: 150);
    _image = File((image?.path)!);
    setState(() {
      this._image = File((image?.path)!);
    });
  }

  Future<void> _handleClickMe(BuildContext context) async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('上传图片'),
          message: Text('请选择上传方式'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('拍照上传'),
              onPressed: () {
                _takePhoto();
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('相册'),
              onPressed: () {
                _openGallery();
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text('取消'),
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
    Widget headerSection = Container(
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
                  child: Container(
                    height: 55.0,
                    width: 55.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27.5)
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      // 加载网络图片过程中显示的内容 , 这里显示进度条
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      // 网络图片地址
                      imageUrl: doctorInfoMap.isEmpty
                          ? ""
                          : doctorInfoMap["photoUrl"] ?? '',
                      fit: BoxFit.cover,
                      // width: 55.0,
                      // height: 55.0,
                    ),
                  )),
              const SizedBox(
                width: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorInfoMap.isEmpty ? "" : doctorInfoMap["realName"],
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Medium',
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    phoneStr,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'PingFangSC-Regular-Medium, PingFang SC',
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
    Widget captionSection = Container(
      transform: Matrix4.translationValues(0, -38.0, 0),
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
                  size: 16.0, color: ColorsUtil.hexStringColor('#FF9C00')),
              const SizedBox(
                width: 9.0,
              ),
              Text(
                '4.8',
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
                '1064',
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
    );

    return Scaffold(
        backgroundColor: ColorsUtil.hexStringColor('#f9f9f9'),
        appBar: CustomAppBar(
          '我的',
          isBack: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              headerSection,
              captionSection,
              Column(
                children: items,
              )
            ],
          ),
        ));
  }
}
