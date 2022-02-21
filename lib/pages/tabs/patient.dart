import 'package:doctor_project/utils/app_bar_utils.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Patient extends StatefulWidget {
  const Patient({Key? key}) : super(key: key);

  @override
  PatientState createState() => PatientState();
}

class PatientState extends State<Patient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBarUtil.buildAppBar(context,'我的患者'),
    );
  }
}
