import 'dart:convert';
import 'dart:math';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/picker_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import '../../utils/svg_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doctor_project/utils/EventBus_Utils.dart';

class UseDrugInfo extends StatefulWidget {

  Map drugInfoMap ;
  UseDrugInfo({Key? key,required this.drugInfoMap}) : super(key: key);

  @override
  _UseDrugInfoState createState() => _UseDrugInfoState(drugInfoMap: this.drugInfoMap);
}

class _UseDrugInfoState extends State<UseDrugInfo> {

  /* 新增字段：
     count 个数
     dosage 用量
     frequency 次数
     usage 用法
     medicationDays 用药天数
     remark 备注
  */
  Map drugInfoMap ;
  _UseDrugInfoState({required this.drugInfoMap});

  final TextEditingController _editingController1 = TextEditingController();
  final TextEditingController _editingController2 = TextEditingController();
  final TextEditingController _editingController3 = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List list = [
    {'label': '每次用量：', 'placeholder': '请选择频率'},
    {'label': '次数：', 'placeholder': '粒/次'},
    {'label': '用法：', 'placeholder': '请选择用法'},
    {'label': '持续用药天数：', 'placeholder': '请输入用药天数'}
  ];

  final List<String> pickerData1 = <String>["每日一次","每日两次","每日三次","每日四次","隔日一次","每周一次","每周两次"];
  final List<String> pickerData2 = <String>["片/次","粒/次","袋/次","支/次","丸/次"];
  final List<String> pickerData3 = <String>["口服","外用","含化","吸入用药","局部用药","喷鼻","滴眼","喷喉"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    drugInfoMap['count'] = 1;
    drugInfoMap['dosage'] = "";
    drugInfoMap['frequency'] = "";
    drugInfoMap['usage'] = "";
    drugInfoMap['medicationDays'] = "";
    drugInfoMap['remark'] = "";

  }

  void _showSimpleDialog1() async{

    var result=await showDialog(
        barrierDismissible:true,   //表示点击灰色背景的时候是否消失弹出框
        context:context,
        builder: (context){
          return SimpleDialog(
            // title:Text(""),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(pickerData1[0]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[0];
                    item.update("placeholder", (value) => pickerData1[0]);
                    drugInfoMap.update("dosage", (value) => item["placeholder"]);

                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData1[1]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[0];
                    item.update("placeholder", (value) => pickerData1[1]);
                    drugInfoMap.update("dosage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData1[2]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[0];
                    item.update("placeholder", (value) => pickerData1[2]);
                    drugInfoMap.update("dosage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData1[3]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[0];
                    item.update("placeholder", (value) => pickerData1[3]);
                    drugInfoMap.update("dosage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData1[4]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[0];
                    item.update("placeholder", (value) => pickerData1[4]);
                    drugInfoMap.update("dosage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData1[5]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[0];
                    item.update("placeholder", (value) => pickerData1[5]);
                    drugInfoMap.update("dosage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData1[6]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[0];
                    item.update("placeholder", (value) => pickerData1[6]);
                    drugInfoMap.update("dosage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
            ],

          );
        }
    );
  }

  void _showSimpleDialog2() async{

    var result=await showDialog(
        barrierDismissible:true,   //表示点击灰色背景的时候是否消失弹出框
        context:context,
        builder: (context){
          return SimpleDialog(
            // title:Text(""),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(pickerData2[0]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[1];
                    item.update("placeholder", (value) => pickerData2[0]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData2[1]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[1];
                    item.update("placeholder", (value) => pickerData2[1]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData2[2]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[1];
                    item.update("placeholder", (value) => pickerData2[2]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData2[3]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[1];
                    item.update("placeholder", (value) => pickerData2[3]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData2[4]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[1];
                    item.update("placeholder", (value) => pickerData2[4]);
                  });
                },
              ),
              Divider(),
            ],

          );
        }
    );
  }

  void _showSimpleDialog3() async{

    var result=await showDialog(
        barrierDismissible:true,   //表示点击灰色背景的时候是否消失弹出框
        context:context,
        builder: (context){
          return SimpleDialog(
            // title:Text(""),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(pickerData3[0]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[2];
                    item.update("placeholder", (value) => pickerData3[0]);
                    drugInfoMap.update("usage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData3[1]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[2];
                    item.update("placeholder", (value) => pickerData3[1]);
                    drugInfoMap.update("usage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData3[2]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[2];
                    item.update("placeholder", (value) => pickerData3[2]);
                    drugInfoMap.update("usage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData3[3]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[2];
                    item.update("placeholder", (value) => pickerData3[3]);
                    drugInfoMap.update("usage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData3[4]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[2];
                    item.update("placeholder", (value) => pickerData3[4]);
                    drugInfoMap.update("usage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData3[5]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[2];
                    item.update("placeholder", (value) => pickerData3[5]);
                    drugInfoMap.update("usage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData3[6]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[2];
                    item.update("placeholder", (value) => pickerData3[6]);
                    drugInfoMap.update("usage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text(pickerData3[7]),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {

                    Map item = list[2];
                    item.update("placeholder", (value) => pickerData3[7]);
                    drugInfoMap.update("usage", (value) => item["placeholder"]);
                  });
                },
              ),
              Divider(),
            ],

          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        '用药信息',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 40.0,
                      padding: const EdgeInsets.only(left: 16.0),
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Text(
                        '请依据上传的病历/疾病资料，选择准确的药品名称、剂量和规格',
                        style:
                        GSYConstant.textStyle(fontSize: 12.0, color: '#EC605D'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 14.0, left: 16.0, right: 16.0),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 3.0,
                              ),
                              Text(
                                drugInfoMap["medicinename"],
                                style: GSYConstant.textStyle(
                                    fontSize: 15.0, color: '#333333'),
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                '规格：' +drugInfoMap["specification"] +"/" +drugInfoMap["packageUnitid_dictText"],
                                style: GSYConstant.textStyle(
                                    fontSize: 13.0, color: '#888888'),
                              ),
                              Text(
                                drugInfoMap["manuname"],
                                style: GSYConstant.textStyle(
                                    fontSize: 13.0, color: '#888888'),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                transform: Matrix4.translationValues(0, -3.0, 0),
                                width: 80,
                                height: 20,
                                margin: const EdgeInsets.only(bottom: 7.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.0),
                                    border: Border.all(
                                        width: 1.0,
                                        color:
                                        ColorsUtil.hexStringColor('#cccccc'))),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      width: 26,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  width: 1.0,
                                                  color: ColorsUtil.hexStringColor(
                                                      '#cccccc')))),
                                      child: SvgUtil.svg('minus.svg'),
                                    ),
                                    Container(
                                      width: 26.0,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  width: 1.0,
                                                  color: ColorsUtil.hexStringColor(
                                                      '#cccccc')))),
                                      child: TextField(
                                        style: GSYConstant.textStyle(
                                            fontSize: 12.0, color: '#333333'),
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9]")), //数字包括小数
                                        ],
                                        textAlignVertical: TextAlignVertical.center,
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            fillColor: Colors.transparent,
                                            filled: true,
                                            hintText: '2',
                                            hintStyle: TextStyle(
                                                fontFamily: 'Medium',
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500,
                                                color: ColorsUtil.hexStringColor(
                                                    '#333333')),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 26,
                                      child: SvgUtil.svg('increment_add.svg'),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '库存：' +drugInfoMap["stockNum"],
                                style: GSYConstant.textStyle(
                                    color: '#888888', fontSize: 13.0),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 44.0,
                      padding: const EdgeInsets.only(left: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '用法用量',
                        style: GSYConstant.textStyle(
                            fontFamily: 'Medium',
                            fontWeight: FontWeight.w500,
                            color: '#333333'),
                      ),
                    ),
                    Column(
                      children: list.asMap().keys
                          .map((index) => GestureDetector(
                          onTap:(){

                            if(index==0){
                              // PickerUtil.showPicker(context,_scaffoldKey, confirmCallback: (Picker picker, List<int> selected) {
                              //
                              // }, pickerData: []);
                              _showSimpleDialog1();
                            }else if(index ==1){
                              _showSimpleDialog2();
                            }else if(index ==2){
                              _showSimpleDialog3();
                            }
                          },
                          child: Container(
                              height: 40.0,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: ColorsUtil.hexStringColor(
                                                '#cccccc',
                                                alpha: 0.3)))),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 98.0,
                                      child: Text(
                                        list[index]['label'],
                                        style: GSYConstant.textStyle(
                                            color: '#333333'),
                                      ),
                                    ),

                                    Visibility(
                                      visible: index ==1,
                                      child: Expanded(
                                          flex: 3,
                                          child: TextField(
                                            controller: _editingController1,
                                            cursorColor:
                                            ColorsUtil.hexStringColor('#666666'),
                                            style: GSYConstant.textStyle(
                                                color: '#666666'),
                                            inputFormatters: [],
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                              // filled: true,
                                              // fillColor: Colors.red,
                                                border: InputBorder.none,
                                                hintText: "请输入数量",
                                                hintStyle: GSYConstant.textStyle(
                                                    color: '#999999')),
                                            onChanged: (value){
                                              setState(() {
                                                Map item = list[1];
                                                drugInfoMap.update("frequency", (value) => value +item["placeholder"]);
                                              });
                                            },
                                            onSubmitted: (value){
                                              print(value);
                                              setState(() {
                                                Map item = list[1];
                                                drugInfoMap.update("frequency", (value) => _editingController1.text +item["placeholder"]);
                                              });
                                            } ,
                                          )),
                                    ),

                                    Expanded(
                                        flex: 1,
                                        child: TextField(
                                          controller: index ==3 ? _editingController2 : null,
                                          cursorColor:
                                          ColorsUtil.hexStringColor('#666666'),
                                          style: GSYConstant.textStyle(
                                              color: '#666666'),
                                          inputFormatters: [],
                                          textAlign: TextAlign.right,
                                          enabled: index ==3,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: list[index]['placeholder'],
                                              hintStyle: GSYConstant.textStyle(
                                                  color: '#999999')),

                                          onChanged: (value){
                                            setState(() {

                                              drugInfoMap.update("medicationDays", (value) => _editingController2.text);
                                            });
                                          },

                                          onSubmitted: (value){
                                            setState(() {

                                              drugInfoMap.update("medicationDays", (value) => _editingController2.text);
                                            });
                                          } ,
                                        )),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    SvgUtil.svg('arrow.svg')
                                  ],
                                ),
                              ))))
                          .toList(),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, top: 9.0),
                      constraints: const BoxConstraints(minHeight: 80.0),
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '备注：',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          const SizedBox(
                            width: 6.0,
                          ),
                          Expanded(
                              child: TextField(
                                controller: _editingController3,
                                inputFormatters: [],
                                cursorColor: ColorsUtil.hexStringColor('#666666'),
                                style: GSYConstant.textStyle(color: '#666666'),
                                decoration: InputDecoration(
                                    hintText: '请输入...',
                                    isCollapsed: true,
                                    hintStyle: GSYConstant.textStyle(color: '#999999'),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero),

                                onChanged: (value){

                                  setState(() {
                                    drugInfoMap.update("remark", (value) => _editingController3.text);
                                  });
                                },

                                onSubmitted: (value){

                                  setState(() {
                                    drugInfoMap.update("remark", (value) => _editingController3.text);
                                  });
                                } ,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Container(
            alignment: Alignment.center,
            child: SafeAreaButton(
              text: '确认',
              onPressed: () {

                setState(() {
                  Map item = list[1];
                  drugInfoMap.update("frequency", (value) => _editingController1.text +item["placeholder"]);
                });

                /* 新增字段：
                   count 个数
                   dosage 用量
                   frequency 次数
                   usage 用法
                   medicationDays 用药天数
                   remark 备注
                */
                String dosageStr = drugInfoMap["dosage"];
                String usageStr = drugInfoMap["usage"];
                if(dosageStr.isEmpty
                    ||usageStr.isEmpty
                    ||_editingController1.text.isEmpty
                    ||_editingController2.text.isEmpty){

                  Fluttertoast.showToast(msg: '请选择或输入用法用量', gravity: ToastGravity.CENTER);
                  return ;
                }
                EventBusUtil.getInstance().fire(drugInfoMap);
                Navigator.of(context).pop();

                // Navigator.popUntil(context, ModalRoute.withName('/makePrescription'));
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MakePrescription(),), ModalRoute.withName('chatRoom'));
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MakePrescription(),), (route) => false);

              },
            ),
          )
        ],
      ),
    );
  }
}
