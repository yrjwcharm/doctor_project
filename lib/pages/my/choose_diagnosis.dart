import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseDiagnosis extends StatefulWidget {
  const ChooseDiagnosis({Key? key}) : super(key: key);

  @override
  _ChooseDiagnosisState createState() => _ChooseDiagnosisState();
}

class _ChooseDiagnosisState extends State<ChooseDiagnosis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('添加诊断'),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[

        ],
      ),
    );
  }
}
