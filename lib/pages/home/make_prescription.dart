import 'package:flutter/material.dart';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';

import 'chinese_diagnosis.dart';
class MakePrescription extends StatefulWidget {
  const MakePrescription({Key? key}) : super(key: key);

  @override
  _MakePrescriptionState createState() => _MakePrescriptionState();
}

class _MakePrescriptionState extends State<MakePrescription> {
  List list = [];

  @override
  void initState() {
    super.initState();
    list = [{
      'title': '处方类型',
      'detail': '普通处方'
    },
      {
        'title': '诊断',
        'detail': '请选择诊断',
      },
      {
        'title': '药房',
        'detail': '请选择药房'
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          CustomAppBar('开处方', isBack: true, onBackPressed: () {
            Navigator.of(context).pop(this);
          },),
          const SizedBox(height: 13.0,),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                children: [
                  Image.asset(
                    'assets/images/self_mention.png', fit: BoxFit.contain,
                    height: 44,),
                  Positioned(
                      top: 10.0,
                      left: 39.0,
                      child: Text('西药/中成药处方', style: GSYConstant.textStyle(
                          fontSize: 17.0, color: '#06B48D'),))
                ],
              ),
              Flexible(child: Stack(children: [
                Container(
                  transform: Matrix4.translationValues(0, 0, 0),
                  child: Image.asset(
                    'assets/images/express_delivery.png', fit: BoxFit.cover,
                    height: 44,),
                ),
                Positioned(
                    left: 44.0,
                    top: 8.0,
                    child: Text('中药处方', style: GSYConstant.textStyle(
                        fontSize: 16.0, color: '#333333'),))
              ],),)
            ],
          ),
          Column(
            children: ListTile.divideTiles(
                color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),
                tiles: list.asMap().keys.map((index) => ListTile(
              onTap: (){
                switch(index){
                  case 0:

                    break;
                  case 1:
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>const  WesternDiagnosis()));
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const  ChineseDiagnosis()));
                    break;
                  case 2:
                    break;
                }
              },
              tileColor: Colors.white,
              title: Text(list[index]['title'],style: GSYConstant.textStyle(color:'#333333'),),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(list[index]['detail'],style: GSYConstant.textStyle(color:'#666666'),),
                  Icon(Icons.keyboard_arrow_right,color: ColorsUtil.hexStringColor('#888888'),)
                ],
              ),
            ))).toList()
          ),
        ],
      ),
    );
  }
}
