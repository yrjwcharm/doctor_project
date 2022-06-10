import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/my/case_template.dart';
import 'package:doctor_project/pages/my/common_words.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_drug.dart';

class TemplateCreate extends StatefulWidget {
  const TemplateCreate({Key? key}) : super(key: key);

  @override
  _TemplateCreateState createState() => _TemplateCreateState();
}

class _TemplateCreateState extends State<TemplateCreate> {
  List list = [
    {'id': 1,'icon':'assets/images/my/common_diagnosis.png', 'title': '医生常用语', 'subTitle': '图文问诊时医生的常用语维护'},
    {'id': 2,'icon':'assets/images/my/common_words.png', 'title': '常用诊断', 'subTitle': 'ICD10常用诊断标准'},
    {'id': 3, 'icon':'assets/images/my/common_drugs.png','title': '常用药品', 'subTitle': '常用处方药品管理'},
    {
      'id': 4,
      'icon':'assets/images/my/medical_records.png',
      'title': '常用病例',
      'subTitle': '常用病历模板维护',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: [
          CustomAppBar(
            '模版创建',
            
          ),
          Column(
            children: ListTile.divideTiles(
                color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                tiles: list.asMap().keys.map((index) => ListTile(
                      onTap: (){
                        switch(index){
                          case 0:
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>CommonWords()));
                            break;
                          case 1:
                            break;
                          case 2:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const CommonDrug()));
                            break;
                          case 3:
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const CaseTemplate()));
                            break;
                        }
                      },
                      leading: Image.asset(
                        list[index]['icon'],
                        width: 34,
                        height: 34,
                      ),
                      tileColor: Colors.white,
                      subtitle: Text(
                        list[index]['subTitle'],
                        style: GSYConstant.textStyle(
                            fontSize: 13.0, color: '#999999'),
                      ),
                      title: Text(
                        list[index]['title'],
                        style: GSYConstant.textStyle(
                            color: '#333333',
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Medium'),
                      ),
                      trailing: Image.asset(
                        'assets/images/my/arrow.png',
                      ),
                    ))).toList(),
          )
        ],
      ),
    );
  }
}
