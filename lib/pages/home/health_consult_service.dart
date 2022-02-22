import 'dart:collection';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HealthConsultService extends StatefulWidget {
  const HealthConsultService({Key? key}) : super(key: key);

  @override
  _HealthConsultServiceState createState() => _HealthConsultServiceState();
}

class _HealthConsultServiceState extends State<HealthConsultService> {
  List list = [];
  bool isChecked = true;
  @override
  void initState() {
    super.initState();
     list.add({'title':'价格','detail':59.00,'isFlag':true});
     list.add({'title':'价格','detail':59.00,'isFlag':false});
     list.add({'title':'接诊人数','detail':20,'isFlag':false});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsUtil.hexStringColor('#f9f9f9'),
        body: Column(
          children: <Widget>[
            CustomAppBar('健康咨询',onBackPressed: (){
              Navigator.pop(context);
            },isBack: true,),
           Column(
             children:ListTile.divideTiles(tiles: list.asMap().keys.map((index) => ListTile(
               leading: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Text(list[index]['title'],style: GSYConstant.textStyle(color: '#333333'),)
                 ],
               ),
               trailing:list[index]['isFlag']?Switch( value: isChecked, activeColor:ColorsUtil.hexStringColor('#06B48D') , onChanged: openHealthConsult): Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Text(list[index]['detail'].toString(),style: GSYConstant.textStyle(color: '#333333'),),
                   const SizedBox(width:9.0),
                   Image.asset('static/images/my/more.png',width: 8.0,height: 14.0,)
                 ],
               ),
               tileColor: Colors.white,
             )),color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)).toList(),
           )
          ],
        ),
    );
  }

  void openHealthConsult(bool value) {
    setState(() {
       isChecked = value;
    });
  }
}
