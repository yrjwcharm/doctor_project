import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCommonDiagnosis extends StatefulWidget {
  const AddCommonDiagnosis({Key? key}) : super(key: key);
  @override
  _AddCommonDiagnosisState createState() => _AddCommonDiagnosisState();
}

class _AddCommonDiagnosisState extends State<AddCommonDiagnosis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('添加诊断'),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 44.0,
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
