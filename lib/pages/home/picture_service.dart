import 'dart:collection';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/text_util.dart';
import 'package:doctor_project/pages/home/submit_success.dart';
import 'package:doctor_project/pages/home/submit_fail.dart';
import 'package:doctor_project/pages/home/clinical_reception_person_set.dart';
import 'package:doctor_project/pages/home/topic_price_set.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_safeArea_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/toast_util.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';

class PictureService extends StatefulWidget {
  const PictureService({Key? key,required this.treatId,required this.fee,required this.patientCount,required this.state}) : super(key: key);
  final String treatId;
  final String fee;
  final String patientCount;
  final int state;

  @override
  _HealthConsultServiceState createState() => _HealthConsultServiceState(treatId,fee,patientCount,state);
}

class _HealthConsultServiceState extends State<PictureService> {
  List list = [];
  bool isChecked = true;
  String treatId;
  String fee;
  String patientCount;
  int state;
  _HealthConsultServiceState(this.treatId,this.fee,this.patientCount,this.state);

  @override
  void initState() {
    super.initState();
    if(state == 0){
      isChecked = false;
    }

     list.add({'title':'复诊开药-图文问诊','subTitle':'','detail':'','isFlag':true});
     list.add({'title':'价格','subTitle':'','detail':fee,'isFlag':false});
     list.add({'title':'接诊人数','subTitle':'','detail':patientCount,'isFlag':false});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsUtil.hexStringColor('#f9f9f9'),
        body: Column(
          children: <Widget>[
            CustomAppBar('图文问诊',onBackPressed: (){
              Navigator.pop(context);
            },isBack: true,),
           Column(
             children:ListTile.divideTiles(tiles: list.asMap().keys.map((index) => ListTile(
               onTap: (){
                 switch(index){
                   case 1:
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>const TopicPriceSet())).then((value) {
                       if(null != value){
                         list[index]['detail'] = value;
                         fee = value;
                         setState(() {});
                       }
                     });
                     break;
                   case 2:
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>const ClinicReceptionPersonSet())).then((value) {
                       if(null != value){
                         list[index]['detail'] = value;
                         patientCount = value;
                         setState(() {});
                       }
                     });
                     break;
                 }

               },
               leading:TextUtil.isEmpty(list[index]['subTitle'].toString())?Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Text(list[index]['title'],style: GSYConstant.textStyle(color: '#333333'),)
                   ]):Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(list[index]['title'],style: GSYConstant.textStyle(color: '#333333'),),
                   Text(list[index]['subTitle'],style: GSYConstant.textStyle(fontSize:12.0,color:'#999999'),)
                 ],
               ),
               trailing:list[index]['isFlag']?Switch( value: isChecked, activeColor:ColorsUtil.hexStringColor('#06B48D') , onChanged: openHealthConsult): Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Text(list[index]['detail'].toString(),style: GSYConstant.textStyle(color: '#333333'),),
                   const SizedBox(width:9.0),
                   Image.asset('assets/images/my/more.png',width: 8.0,height: 14.0,)
                 ],
               ),
               tileColor: Colors.white,
             )),color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)).toList(),
           ),
            Expanded(
                child:Container(
                  alignment: Alignment.bottomCenter,
                  child:  CustomSafeAreaButton(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    title: '提交', 
                    onPressed: () async  {
                      if(treatId == ''){
                        var res = await HttpRequest.getInstance().post(Api.insertDoctorTimeService, {
                          "treatType": 0,
                          "fee": fee,
                          "patientCount":patientCount,
                          "regType":2
                        });
                        if(res['code']==200){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SubmitSuccess()));
                        }else {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SubmitFail()));
                        }
                      }else {
                        isChecked?state=1:0;
                        print('state+++++-------------------'+state.toString());

                        var res = await HttpRequest.getInstance().post(Api.updateDoctorTimeService, {
                          "treatId":treatId,
                          "treatType": 0,
                          "fee": fee,
                          "state":state,
                          "patientCount":patientCount

                        });
                        if(res['code']==200){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SubmitSuccess()));
                        }else {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SubmitFail()));
                        }
                      }

                    },
                  ),
                )

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
