import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/my/choose_diagnosis.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_textField_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCommonDiagnosis extends StatefulWidget {
  const AddCommonDiagnosis({Key? key}) : super(key: key);
  @override
  _AddCommonDiagnosisState createState() => _AddCommonDiagnosisState();
}

class _AddCommonDiagnosisState extends State<AddCommonDiagnosis> {
  String templateName='';
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
