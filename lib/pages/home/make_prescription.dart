import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MakePrescription extends StatefulWidget {
  const MakePrescription({Key? key}) : super(key: key);

  @override
  _MakePrescriptionState createState() => _MakePrescriptionState();
}

class _MakePrescriptionState extends State<MakePrescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          CustomAppBar('开处方',isBack: true,onBackPressed: (){
              Navigator.of(context).pop(this);
          },),
          Row(
            children: <Widget>[
              Image.asset('assets/images/self_mention.png',fit: BoxFit.cover,),
              Image.asset('assets/images/express_delivery.png',fit: BoxFit.cover,),

            ],
          ),
        ],
      ),
    );
  }
}
