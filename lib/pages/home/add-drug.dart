import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddDrug extends StatefulWidget {
  const AddDrug({Key? key}) : super(key: key);

  @override
  _AddDrugState createState() => _AddDrugState();
}

class _AddDrugState extends State<AddDrug> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          CustomAppBar('添加药品',onBackPressed: (){
            Navigator.pop(context);
          },)
        ],
      ),
    );
  }
}
