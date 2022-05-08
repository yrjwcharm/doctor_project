import 'package:doctor_project/pages/my/rp_detail.dart';
import 'package:doctor_project/utils/common_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';

import 'dart:io';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'dart:async';
import 'dart:convert';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/prescription_detail.dart';
import 'dart:math' as math;

class electronicSignaturePage extends StatefulWidget {
  Map YXQDataMap ; //医信签数据map
  String registeredId ; //挂号Id
  String category ; //处方类别（1-西药/中成药，2-中药）
  String prescriptionId ; //处方id
  electronicSignaturePage({Key? key, required this.YXQDataMap, required this.registeredId, required this.category, required this.prescriptionId}) : super(key: key);

  @override
  _electronicSignaturePageState createState() => _electronicSignaturePageState(YXQDataMap: this.YXQDataMap, registeredId:this.registeredId, category:category, prescriptionId:prescriptionId);
}

class _electronicSignaturePageState extends State<electronicSignaturePage> {

  Map YXQDataMap ; //医信签数据map
  String registeredId ; //挂号Id
  String category ; //处方类别（1-西药/中成药，2-中药）
  String prescriptionId ; //处方id
  _electronicSignaturePageState({required this.YXQDataMap, required this.registeredId, required this.category, required this.prescriptionId});

  // String base64Str =
  //     "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";


  //医信签提交数据电子签名
  void getNet_YXQSignData() async{
    // print('111111111,${YXQDataMap.toString()}');
    // return;
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.post(Api.YXQSignDataUrl,{
      // "userId"          : "123124", //医护人员userid   944241327611052102
      "transactionId"   : prescriptionId, //业务编号 处方id
      "authKey"         : YXQDataMap["authKEY"].toString(), //临时密钥
      "fileName"        : "储存电子处方", //文件名
      "data"            : "姓名：张三,性别：男,年龄：26,费用：自费,科别：全科", //返回数据
    });
    print("getNet_YXQSignData------" +res.toString());
    if (res['code'] == 200) {
       var request = HttpRequest.getInstance();
       var result = await request.get(Api.prescriptionListUrl+'?registerId=$registeredId&category=$category', {});
        Map<String,dynamic> patientVO={},item={};
       if(result['code']==200){
         print('11111${result['data']}');
         patientVO = result['data'][0]['patientVO'];
         item= result['data'][0];
       }
       List<String>  diagnosis = [];
       (item['diagnosisVOS']??[]).forEach((element) {
         diagnosis.add(element['diagnosisName']);
       });
       String str = '';
       diagnosis.forEach((f){
         if(str == ''){
           str = "$f";
         }else {
           str = "$str"",""$f";
         }
       });
      Navigator.push(context, MaterialPageRoute(builder: (context)=> RecipeDetail(rpDetailItem: {...item,...patientVO}, diagnosis: str,)));

    }else{
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER);
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> PrescriptDetail(registeredId: registeredId, category: category, imageStr: YXQDataMap["signatureImg"],)));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          '电子签名',
          onBackPressed: () {
            Navigator.pop(context);
            // Navigator.of(context).pop(this);
          },
        ),
        backgroundColor: ColorsUtil.bgColor, //Container
        body: Column(
          children: [
            const SizedBox(height: 10.0,),
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 240,
              child: Transform.rotate(
                angle: 270.17,
                child: Image.memory(
                  const Base64Decoder().convert(YXQDataMap["signatureImg"]),
                ),),
            ),
            Spacer(),
            SafeArea(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 40.0,
                child: ElevatedButton(
                  style:ElevatedButton.styleFrom(
                      primary: ColorsUtil.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))
                ),
                  onPressed: () {
                    CommonUtils.throttle(getNet_YXQSignData,durationTime: 500);
                    // getNet_YXQSignData();
                  },
                  child: Text('提交',style: GSYConstant.textStyle(fontSize: 16.0),),),
            ),),
          ],
        ),

    );
  }
}
