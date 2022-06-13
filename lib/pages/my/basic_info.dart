import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';
import '../../utils/desensitization_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_project/utils/svg_util.dart';


class BasicInfo extends StatefulWidget {
  const BasicInfo({Key? key}) : super(key: key);

  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  List list = [];
  String name='';
  String idCard='';
  String hospital='';
  String clinic='';
  String job='';

  String phoneStr = "";
  String drPhotoUrl = '';
  String deptName = '';
  String orgName = '';
  String protitle = '';
  String receiveNum = '';
  String waitReceiveNum = '';
  String videoRegisterNum = '';
  String codeData = '';
  String expertIn  = '';

  getNet_doctorInfo() async {
    SharedPreferences perfer = await SharedPreferences.getInstance();
    String phone_str = (perfer.getString("phone") ?? "");
    phoneStr = DesensitizationUtil.desensitizationMobile(phone_str);
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.getDoctorInfoUrl, {});
    print("getNet_doctorInfo------" + res.toString());

    if (res['code'] == 200) {
      drPhotoUrl = res['data']['photoUrl'];
      name = res['data']['realName'];
      orgName = res['data']['orgName'] ?? '';
      deptName = res['data']['deptName'] ?? '';
      protitle = res['data']['protitle_dictText'] ?? '';
      receiveNum = res['data']['receiveNum'].toString();
      waitReceiveNum = res['data']['waitReceiveNum'].toString();
      videoRegisterNum = res['data']['videoRegisterNum'].toString();
      expertIn = res['data']['expertIn'] ?? '';

      list.add({'label':'姓名','placeholder':name,'enabled':false});
      list.add({'label':'性别','placeholder':'','enabled':false});
      list.add({'label':'出生日期','placeholder':'','enabled':false});
      list.add({'label':'手机号','placeholder':phoneStr,'enabled':false});
      list.add({'label':'所属医院','placeholder':orgName,'enabled':false});
      list.add({'label':'所在科室','placeholder':deptName,'enabled':false});
      list.add({'label':'职称','placeholder':protitle,'enabled':false});
      list.add({'label':'擅长','placeholder':expertIn,'enabled':false});
      list.add({'label':'医生简介','placeholder':'','enabled':false});
      list.add({'label':'所在城市','placeholder':'','enabled':false});

      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
    getNet_doctorInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '基本信息',
      
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 32.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: ColorsUtil.hexStringColor('#CE8E55', alpha: 0.12),
            ),
            child: Row(children: <Widget>[
              Image.asset(
                'assets/images/pass.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                '为了您顺利通过认证，请务必填写真实信息',
                style: GSYConstant.textStyle(fontSize: 13.0, color: '#C78C4C'),
              ),
            ]),
          ),
          Column(
            children: list.map((item) => GestureDetector(
              onTap:item['enabled']?null:(){
                // ToastUtil.showToast(msg: '点击了');
              },
              child: Column(
                  children: <Widget>[
                    Container(
                      height: 44,
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 56,
                            child: Text(
                              item['label'],
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                          ),
                          Expanded(
                            child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  item['placeholder'],
                                  textAlign: TextAlign.right,
                                  style: GSYConstant.textStyle(
                                      color: '#666666'),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              SvgUtil.svg('arrow_rp.svg')
                            ],
                          ),
                            // child: TextField(
                            //   onChanged: (name) {
                            //     setState(() {
                            //       name = name;
                            //     });
                            //   },
                            //   cursorColor: ColorsUtil.hexStringColor('#666666'),
                            //   decoration: InputDecoration(
                            //     // filled: true,
                            //     enabled: item['enabled'],
                            //     contentPadding: const EdgeInsets.only(right:8.0),// fillColor: Colors.red,
                            //     border: InputBorder.none,
                            //     hintStyle: GSYConstant.textStyle(color: '#999999'),
                            //     hintText: item['placeholder'],
                            //   ),
                            //   style: GSYConstant.textStyle(color: '#666666'),
                            // ),
                          ),
                          // !item['enabled']?Icon(Icons.keyboard_arrow_right,color:ColorsUtil.hexStringColor('#999999'),):const SizedBox(width: 0,height: 0,)
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        height: 0,
                        color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                      ),
                    )
                  ]),
            ) ).toList(),
          ),
        ],
      ),
    );
  }
}
