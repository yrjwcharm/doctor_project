import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/api.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/my/choose_diagnosis.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_textField_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';

import '../../model/department_modal.dart';
class AddCommonDiagnosis extends StatefulWidget {
  const AddCommonDiagnosis({Key? key}) : super(key: key);
  @override
  _AddCommonDiagnosisState createState() => _AddCommonDiagnosisState();
}

class _AddCommonDiagnosisState extends State<AddCommonDiagnosis> {
  String templateName='';
  @override
  void initState() {
    super.initState();
    getDepartmentList();
  }
  getDepartmentList() async{
    var response = await HttpRequest.getInstance().get(Api.getAllDepartment, {});
    // if(res['code']==200){
    //
    // }
    var res = DepartmentModal.fromJson(response);
    if(res.code==200){
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
      appBar: CustomAppBar('诊断',child: SvgUtil.svg('add_diagnosis.svg'),isForward: true, onForwardPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChooseDiagnosis()));
      },),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CustomTextFieldInput(label: '模板名称', hintText: '请输入模板名称', onChanged: (value){
                    setState(() {
                      templateName = value;
                    });
                }),
                Container(
                  height: 43.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('科室选择',style: GSYConstant.textStyle(color: '#333333'),),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                           Text('请选择科室',style: GSYConstant.textStyle(color: '#999999'),),
                          const SizedBox(width: 8.0,),
                          SvgUtil.svg('forward_arrow.svg')
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
