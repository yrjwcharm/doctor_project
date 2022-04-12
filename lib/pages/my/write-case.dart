import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'case_template.dart';
import 'package:doctor_project/pages/my/write-caseDetail.dart';
import '../../http/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class WriteCase extends StatefulWidget {
  String registeredId ; //挂号Id
  WriteCase({Key? key, required this.registeredId}) : super(key: key);

  @override
  _WriteCaseState createState() => _WriteCaseState(registeredId: this.registeredId);
}

class _WriteCaseState extends State<WriteCase> {

  String registeredId ; //挂号Id
  _WriteCaseState({required this.registeredId});

  List list = [
    {'label':'就诊卡类型','value':'身份证','disabled':true,'isArrow':false},
    {'label':'就诊卡号码','value':'3714**********6578','disabled':false,'isArrow':false},
    {'label':'患者姓名','value':'张可可','disabled':false,'isArrow':false},
    {'label':'患者性别','value':'女','disabled':true,'isArrow':false},
    {'label':'出生日期','value':'2022-02-11','disabled':true,'isArrow':false},
    {'label':'科室门诊','value':'呼吸内科','disabled':true,'isArrow':false},
    {'label':'主诉','value':'请输入疾病','disabled':true,'isArrow':true},
    {'label':'病史描述','value':'请输入疾病','disabled':true,'isArrow':true},
    {'label':'现病史','value':'请输入现病史','disabled':true,'isArrow':true},
    {'label':'既往史','value':'请输入既往史','disabled':true,'isArrow':true},
    {'label':'过敏史','value':'请输入过敏史','disabled':true,'isArrow':true},
  ];
  List<Widget> widgets =const <Widget>[];
  Map contentMap = new Map();

  @override
  void initState() {
    super.initState();
  }

  loadtDataForWriteCase() async {

    Map params = {
      // "billid"          : "1", //病历Id  非必填
      "registerid"      : registeredId, //挂号Id
      "extend8"         : list[6]["value"].indexOf("请输入") !=-1 ? "" : list[6]["value"] , //主诉
      "extend9"         : list[7]["value"].indexOf("请输入") !=-1 ? "" : list[7]["value"], //病史描述
      "hpi"             : list[8]["value"].indexOf("请输入") !=-1 ? "" : list[8]["value"], //现病史
      "pasthistory"     : list[9]["value"].indexOf("请输入") !=-1 ? "" : list[9]["value"], //既往史
      "allergichistory" : list[10]["value"].indexOf("请输入") !=-1 ? "" : list[10]["value"], //过敏史
    };

    SharedPreferences perfer = await SharedPreferences.getInstance();
    String? tokenValueStr = perfer.getString("tokenValue");
    var dio = new Dio();
    dio.options.headers = {
      "token": tokenValueStr,
    };
    var response = await dio.post(
        Api.BASE_URL +Api.writeCaseUrl,
        data: params);
    String mess = response.data['msg'];
    print("loadtDataForWriteCase------" + response.data.toString());

    if(response.data['code'] == 200){
      //请求成功
      Fluttertoast.showToast(msg: "保存成功", gravity: ToastGravity.CENTER);
      Navigator.pop(context);

    }else{
      Fluttertoast.showToast(msg: response.data['msg'], gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar('写病历',onBackPressed: (){
        Navigator.pop(context);
      },
      //   isForward:true,child: Text('引入病例模板',style: GSYConstant.textStyle(color: '#06B48D'),),onForwardPressed: (){
      //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const CaseTemplate()));
      // },
      ),
      body:SingleChildScrollView(child: Column(
        children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: list.asMap().keys.map((index) =>
                  GestureDetector(
                    onTap: (){
                      if(index ==6 ||index ==7 ||index ==8 ||index ==9 ||index ==10){

                        String str = list[index]['value'];
                        //判断某个字符串中是否存在amr字符，如果存在执行
                        if(str.indexOf("请输入") !=-1){
                          contentMap["detail"] = "";
                        }else{
                          contentMap["detail"] = str;
                        }
                        contentMap["name"] = list[index]['label'];

                        Navigator.push(context, MaterialPageRoute(builder: (context)=> WriteCaseDetail(dataMap: contentMap,))).then((value){
                          if(value.isNotEmpty){
                            contentMap = value ;
                            Map item = list[index];
                            setState(() {
                              item["value"] = contentMap["detail"];
                            });
                          }
                        });
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          height: 44.0,
                          decoration: const BoxDecoration(
                              color: Colors.white
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(list[index]['label'],style: GSYConstant.textStyle(color: '#333333'),),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width:250.0,
                                    // height: 44.0,
                                    child:  TextField(
                                      cursorColor: ColorsUtil.hexStringColor('#888888'),
                                      enabled:!list[index]['disabled'],
                                      textAlign: TextAlign.end,
                                      // textAlignVertical: TextAlignVertical.center,
                                      style: GSYConstant.textStyle(color: '#888888'),
                                      decoration: InputDecoration(
                                          isCollapsed: true,
                                          border: InputBorder.none,
                                          hintStyle: GSYConstant.textStyle(color: '#888888'),
                                          hintText: list[index]['value']
                                      ),
                                    ),)
                                  // Text(list[index]['value'],style: GSYConstant.textStyle(color: '#888888'),),
                                  ,
                                  SizedBox(width:list[index]['isArrow']? 8.0:0,),
                                  list[index]['isArrow']?Image.asset('assets/images/arrow_right.png'):Container()
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),)
                      ],
                    ),
                  ),
              ).toList(),
            ),
           Container(
             margin: const EdgeInsets.only(top: 117.0),
             width: double.infinity,
             padding: const EdgeInsets.symmetric(horizontal: 16.0),
             height: 40.0,
             child: ElevatedButton(
               style:ElevatedButton.styleFrom(
                 primary: ColorsUtil.primaryColor,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))
               ),
               onPressed: () {
                 loadtDataForWriteCase();
               },
             child: Text('保存',style: GSYConstant.textStyle(fontSize: 16.0),),),
           ),
          // Container(
          //     margin: const EdgeInsets.only(top: 8.0),
          //     width: double.infinity,
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   height: 40.0,
          //   child: OutlinedButton(
          //     style:ElevatedButton.styleFrom(
          //         side: BorderSide(width: 1.0,color: ColorsUtil.primaryColor),
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))
          //     ),
          //     onPressed: () {
          //
          //     },
          //     child: Text('另存成模板',style: GSYConstant.textStyle(fontSize: 16.0,color:'#06B48D'),),)
          // )
        ],
      ),)
    );
  }
}
