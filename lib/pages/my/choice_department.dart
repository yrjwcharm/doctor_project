import 'dart:io';

import 'package:doctor_project/http/http_request.dart';
import 'package:flutter/material.dart';

import '../../common/style/gsy_style.dart';
import '../../http/api.dart';
import '../../model/department_modal.dart';
import '../../utils/colors_utils.dart';
import '../../widget/custom_app_bar.dart';

class ChoiceDepartment extends StatefulWidget {
  const ChoiceDepartment({Key? key}) : super(key: key);

  @override
  _ChoiceDepartmentState createState() => _ChoiceDepartmentState();
}

class _ChoiceDepartmentState extends State<ChoiceDepartment> {
  @override
  void initState() {
    super.initState();
    getDepartmentList();
  }
  getDepartmentList() async {
    var response =
    await HttpRequest.getInstance().get(Api.getAllDepartment, {});
    // if(res['code']==200){
    //
    // }
    var res = DepartmentModal.fromJson(response);
    if (res.code == 200) {
      //
      // Pickers.showMultiLinkPicker(
      // context,
      // data: res.data,
      // // 注意数据类型要对应 比如 44442 写成字符串类型'44442'，则找不到
      // // selectData: ['c', 'cc', 'cccc33', 'ccc4-2', 44442],
      // // selectData: ['c', 'cc3'],
      // columeNum: 5,
      // suffix: ['', '', '', '', ''],
      // onConfirm: (List p, List<int> position) {
      // print('longer >>> 返回数据：${p.join('、')}');
      // print('longer >>> 返回数据下标：${position.join('、')}');
      // print('longer >>> 返回数据类型：${p.map((x) => x.runtimeType).toList()}');
      // },
      // );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar('科室选择'),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
               SizedBox(
                 width: 100.0,
                 child: Column(
                   children: <Widget>[
                     Container(
                       height: 44.0,
                       alignment: Alignment.center,
                       child: Text('普通外科',style: GSYConstant.textStyle(color: '#333333'),),
                     )
                   ],
                 ),
               ),
               Expanded(child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 17.0,right: 9.0),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 43.0,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)))
                            ),
                            child: Text('上呼吸道感染',style: GSYConstant.textStyle(color: '#333333'),),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
