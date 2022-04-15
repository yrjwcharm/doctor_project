import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicInfo extends StatefulWidget {
  const BasicInfo({Key? key}) : super(key: key);

  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  List list = [
    {'label': '姓名','placeholder':'请输入真实姓名','enabled':true},
    {'label': '证件号码','placeholder':'请输入身份证号','enabled':true},
    {'label': '在职医院','placeholder':'请选择','enabled':false},
    {'label': '所在科室','placeholder':'请选择','enabled':false},
    {'label': '职称','placeholder':'请选择','enabled':false}
  ];
  String name='';
  String idCard='';
  String hospital='';
  String clinic='';
  String job='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '基本信息',
        onBackPressed: () {
          Navigator.pop(context);
        },
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
                ToastUtil.showToast(msg: '点击了');
              },
              child: Column(
                  children: <Widget>[
                    Container(
                      // height: 44,
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
                            child: TextField(
                              onChanged: (name) {
                                setState(() {
                                  name = name;
                                });
                              },
                              cursorColor: ColorsUtil.hexStringColor('#666666'),
                              decoration: InputDecoration(
                                // filled: true,
                                enabled: item['enabled'],
                                contentPadding: const EdgeInsets.only(left:16.0),// fillColor: Colors.red,
                                border: InputBorder.none,
                                hintStyle: GSYConstant.textStyle(color: '#999999'),
                                hintText: item['placeholder'],
                              ),
                              style: GSYConstant.textStyle(color: '#666666'),
                            ),
                          ),
                          !item['enabled']?Icon(Icons.keyboard_arrow_right,color:ColorsUtil.hexStringColor('#999999'),):const SizedBox(width: 0,height: 0,)
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
