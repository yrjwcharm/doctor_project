import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/video_topic.dart';
import 'package:doctor_project/pages/home/webviewVC.dart';
import 'package:doctor_project/pages/photoview_page.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/desensitization_utils.dart';
import 'package:doctor_project/utils/event_bus_util.dart';
import 'package:doctor_project/utils/image_network_catch.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:doctor_project/widget/custom_webview.dart';
import '../../utils/desensitization_utils.dart';
import 'package:doctor_project/pages/my/write_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:doctor_project/pages/my/rp_detail.dart';
import 'package:flutter/material.dart';
import '../../http/http_request.dart';
import '../../config/zego_config.dart';
import '../../http/api.dart';
import 'chat_room.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class PrescriptionList extends StatefulWidget {
  PrescriptionList({Key? key, required this.dataMap,required this.prescriptionItem}) : super(key: key);
  Map dataMap;
  Map prescriptionItem;

  @override
  _PrescriptionListState createState() => _PrescriptionListState(this.dataMap,this.prescriptionItem);
}

class _PrescriptionListState extends State<PrescriptionList> {
  Map _dataMap ;
  Map prescriptionItem ;
  int num=0;
  List recipeIdList=[];

  _PrescriptionListState(this._dataMap,this.prescriptionItem);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recipeIdList = _dataMap['recipeList'];
    num = recipeIdList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '处方查看',
        isBack: true,
      ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 22,
            margin: const EdgeInsets.only(top: 10.0,left: 21.0),
            child:
            RichText(
              text:TextSpan(
                children: [
                  const TextSpan(
                    text: "处方记录  ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(51, 51, 51, 1),),
                  ),
                  const TextSpan(
                    text: "共",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: num.toString(),
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(245, 64, 51, 1),),
                  ),
                  const TextSpan(
                    text: "条",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: recipeIdList.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = recipeIdList[index];
                  List<String>  diagnosisList = [];
                  String diagnosis = '';
                  (prescriptionItem['diagnoses']??[]).forEach((element) {
                    diagnosisList.add(element['diagnosisName']);
                  });
                  diagnosisList.forEach((f){
                    if(diagnosis == ''){
                      diagnosis = "$f";
                    }else {
                      diagnosis = "$diagnosis"",""$f";
                    }
                  });
                  return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> RecipeDetail(rpDetailItem: prescriptionItem, diagnosis: diagnosis,prescriptionId:item['recipeId'].toString(),registeredId:prescriptionItem['id'].toString())));
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 50.0,
                            width: double.infinity,
                            padding:
                            const EdgeInsets.only(left: 16.0, top: 16.0,right: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['createTime']+"  "+item['recipeType'],style: GSYConstant.textStyle(color: '#333333'),),
                                SvgUtil.svg('arrow_right.svg'),
                              ],
                            ),
                          ),

                        ],
                      ));
                }),
          ),



        ],
      ),
    );
  }
}
