import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_utils.dart';
import 'package:doctor_project/utils/text_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddMultiDiagnosis extends StatefulWidget {
  const AddMultiDiagnosis({Key? key}) : super(key: key);

  @override
  _AddMultiDiagnosisState createState() => _AddMultiDiagnosisState();
}

class _AddMultiDiagnosisState extends State<AddMultiDiagnosis> {
  List list =[
    {'label':'内科','type':'P92.500','symptom':'风寒感冒'},
    {'label':'内科','type':'P92.500','symptom':'痛风'}
  ];
  int groupValue =0;
  final TextEditingController _editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
       appBar: CustomAppBar('诊断',onBackPressed: (){
         Navigator.pop(context);
       },),
       body: Column(
         children: <Widget>[
           Padding(padding:const EdgeInsets.only(top: 11.0,left: 17.0,right: 16.0), child:Row(
            children: <Widget>[
              Expanded(child:Container(
                height: 32.0,
                padding: const EdgeInsets.only(left:8.0,right: 16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorsUtil.bgColor,
                  borderRadius: BorderRadius.circular(19.0),
                ),
                child: TextField(
                  controller: _editingController,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(20)//限制长度
                  ],
                  onChanged: (value)=>{
                    print(_editingController.text.isNotEmpty)
                  },
                  style:GSYConstant.textStyle(color: '#666666'),
                  cursorColor: ColorsUtil.hexStringColor('#666666'),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIconConstraints: const BoxConstraints(
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 31.0
                    ),
                    // isDense: true,
                    isCollapsed: true,
                    prefixIcon: SvgUtil.svg('search.svg'),

                    suffixIcon:_editingController.text.isNotEmpty?SvgUtil.svg('delete.svg'):null,
                    hintStyle: GSYConstant.textStyle(color: '#888888'),
                    hintText: '搜索ICD名称、拼音码',
                  ),
                ),
              ),),
              const SizedBox(width: 16.0,),
              Text('取消',style: GSYConstant.textStyle(color: '#333333'),)
            ]
          ),),
           Expanded(child:
           ListView(
             children:ListTile.divideTiles(
                 color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),
                 tiles:list.map((item) => ListTile(
               title: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[
                   Text(item['label'],style: GSYConstant.textStyle(color: '#888888'),),
                   const SizedBox(width: 10.0,),
                   Text(item['type'],style: GSYConstant.textStyle(color: '#333333'),),
                   const SizedBox(width: 10.0,),
                   Text(item['symptom'],style: GSYConstant.textStyle(color: '#333333'),)
                 ],
               ),
               trailing: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[
                    Text('主诊断',style: GSYConstant.textStyle(color: '#666666',fontSize: 13.0),),
                    Radio(value: 0, activeColor: ColorsUtil.hexStringColor('#06B48D'), groupValue: groupValue, onChanged: (value){
                      setState(() {
                        groupValue = value.toString() as int;
                      });
                    })
                 ],
               ),
             )) ).toList()
           ))
        ],
       ),
    );
  }
}
