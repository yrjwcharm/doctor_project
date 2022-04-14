import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_project/pages/my/write-caseDetail.dart';
import '../../http/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class MyPrescription extends StatefulWidget {
  const MyPrescription({Key? key}) : super(key: key);

  @override
  _MyPrescriptionState createState() => _MyPrescriptionState();
}

class _MyPrescriptionState extends State<MyPrescription> {

  List list =["审核中", "待支付", "已失效", "已审核", "已撤销", "未通过"];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar('我的处方',onBackPressed: (){
        Navigator.pop(context);
      },
      ),
      body:Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {

                GlobalKey key = GlobalKey();
                return Column(
                  children: [
                    Container(
                      height: 100.0,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 16.0,top: 16.0),
                      child: Row(
                        children: [
                          ClipOval(child: const Image(image: AssetImage('assets/images/home/avatar.png'),fit: BoxFit.cover,width: 40.0,height: 40.0,),),
                          const SizedBox(width: 16.0,),
                          Expanded(
                            flex: 5,
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(children: [
                                Text('李史市',style: TextStyle(
                                    fontSize:14.0,
                                    fontFamily: 'Medium',
                                    fontWeight: FontWeight.w400,
                                    color: ColorsUtil.hexStringColor('#333333')
                                )),
                                const SizedBox(width: 16.0,),
                                Text('男 | 22岁 | 内科',style: GSYConstant.textStyle(color: '#666666'),),
                              ],),
                              const SizedBox(height: 4.0,),
                              Text('处方编号：9899008766',style: GSYConstant.textStyle(color: '#333333'),),
                              const SizedBox(height: 4.0,),
                              Text('最近诊断：上呼吸道感染',style: GSYConstant.textStyle(color: '#333333'),),
                            ],),),
                          const SizedBox(width: 10.0,),
                          Expanded(
                            flex: 1,
                            child: Text(list[index],style: GSYConstant.textStyle(color: '#DE5347'),),),
                          const SizedBox(width: 16.0,),
                        ],),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(bottom: BorderSide(width: 1.0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)))
                      ),
                    ),
                    Container(
                      height: 42.0,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 16.0),
                      alignment: Alignment.centerLeft,
                      color: Colors.white,
                      child: Text('2022-01-04 15:36:46',style: GSYConstant.textStyle(color: '#666666'),),
                    ),
                    Container(
                      height: 8.0,
                      width: double.infinity,
                    ),
                  ],);
              }),),
        ],
      ),
    );
  }
}
