import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoctorQualification extends StatefulWidget {
  const DoctorQualification({Key? key}) : super(key: key);

  @override
  _DoctorQualificationState createState() => _DoctorQualificationState();
}

class _DoctorQualificationState extends State<DoctorQualification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('医师资质认证'),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[

        ],
      ),
    );
  }
}
