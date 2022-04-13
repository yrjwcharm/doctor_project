import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'dart:convert';
import 'dart:math' as math;

import '../../widget/custom_input_widget.dart';

class PrescriptDetail extends StatefulWidget {
  String registeredId ; //挂号Id
  String category ; //处方类别（1-西药/中成药，2-中药）
  String imageStr ;
  PrescriptDetail({Key? key, required this.registeredId,required this.category, required this.imageStr}) : super(key: key);

  @override
  _PrescriptDetailState createState() => _PrescriptDetailState(registeredId: this.registeredId, category: this.category, imageStr: imageStr);
}

class _PrescriptDetailState extends State<PrescriptDetail> {

  String registeredId ; //挂号Id
  String category ; //处方类别（1-西药/中成药，2-中药）
  String imageStr ;
  _PrescriptDetailState({required this.registeredId, required this.category, required this.imageStr});

  // List list = [
  //   {'label': '甘草', 'detail': '2000g'},
  //   {'label': '陈皮', 'detail': '2000g'},
  //   {'label': '红枣', 'detail': '2000g'},
  //   {'label': '红蚂蚁', 'detail': '500g'},
  // ];

  List list1 = [{'label': '服用贴数', 'detail': ''},
    {'label': '用法', 'detail': ''},
    {'label': '频次', 'detail': ''},
    {'label': '备注：', 'detail': ''}];

  Map patientInfoMap = new Map(); //患者信息map
  Map dataMap = new Map(); //处方详情map
  String diagnosisName = "";
  List medicineList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNet_PatientInfo();
    getNet_PrescriptionDetail();
  }

  //获取患者信息接口
  void getNet_PatientInfo()async{
    // registeredId = "433777030165823488";

    HttpRequest? request = HttpRequest.getInstance();
    //registerId 挂号id
    var res = await request?.get(Api.patientInfoUrl +"?registerId=" +registeredId ,{});

    print("getNet_PatientInfo------" +res.toString());
    if (res['code'] == 200) {
      setState(() {
        patientInfoMap = res['data'];
      });

    }else{
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER);
    }
  }

  //获取处方详情接口
  void getNet_PrescriptionDetail()async {

    HttpRequest? request = HttpRequest.getInstance();
    //registerId 挂号id  category  处方类别（1-西药/中成药，2-中药）
    var res = await request?.get(Api.prescriptionDetailUrl +"?registerId=" +registeredId +"&category=" +category,{});
    print("getNet_PrescriptionDetail------" +res.toString());
    if (res['code'] == 200) {
      dataMap = res['data'];
      String str ="";
      for(int i=0; i<dataMap["diagnosisVOS"].length; i++){
        String str1 = str.isEmpty ? dataMap["diagnosisVOS"][i]["diagnosisName"] : "," +dataMap["diagnosisVOS"][i]["diagnosisName"];
        str += str1;
      }

      setState(() {
        diagnosisName = str ;
        medicineList = category =="1" ? dataMap["medicineVOS"] :dataMap["herbalMedicineVOS"];
        if(category =="2"){ //中药
          list1[0]["detail"] = dataMap["countNum"].toString(); //服用帖数
          list1[1]["detail"] = dataMap["useType"]; //用法
          list1[2]["detail"] = dataMap["freq"].toString(); //频次
          if(dataMap["remarks"].toString().isNotEmpty){
            list1[3]["detail"] = dataMap["remarks"].toString(); //备注
          }else{
            list1.removeAt(3);
          }
        }
      });

    }else{
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          '处方详情',
          onBackPressed: () {
            Navigator.of(context).pop(this);
          },
        ),
        backgroundColor: ColorsUtil.bgColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    // Container(
                    //   height: 40.0,
                    //   alignment: Alignment.center,
                    //   decoration: BoxDecoration(
                    //       color: ColorsUtil.hexStringColor('#06B48D')),
                    //   child: Text(
                    //     '未通过',
                    //     style: GSYConstant.textStyle(
                    //         fontSize: 16.0, color: '#ffffff'),
                    //   ),
                    // ),
                    // ListTile(
                    //   subtitle:Text('列表中的克拉霉素胶囊对患者病情有刺激性。',style: GSYConstant.textStyle(color: '#F39E2B'),) ,
                    //   title: Text('审核不通过的处方原因如下：',style: GSYConstant.textStyle(fontSize: 15.0,fontFamily: 'Medium',fontWeight: FontWeight.w500,color: '#333333'),),
                    // ),
                    // Divider(height: 0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //   height: 40,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //             Text('审核药师：',style: GSYConstant.textStyle(fontSize: 13.0,color: '#333333'),),
                    //             Text('张兰',style: GSYConstant.textStyle(fontSize: 13.0,color: '#06B48D'),)
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Text('审核时间：2022-02-22 13:00:56',style: GSYConstant.textStyle(fontSize: 13.0,color: '#333333'),)
                    //
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   height: 7.0,
                    //   decoration: BoxDecoration(
                    //     color: ColorsUtil.bgColor
                    //   ),
                    // ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child:Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '通海县人民医院电子处方',
                                  style: GSYConstant.textStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: '#333333'),
                                ),
                                Text(
                                  '医疗机构编码：346987654321123H',

                                  style: GSYConstant.textStyle(
                                      fontSize: 12.0, color: '#888888'),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin:
                            const EdgeInsets.only(left: 23.0, right: 19.0),
                            child: Image.asset('assets/images/audit_pass.png'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              '姓名：',
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                            Text(
                              patientInfoMap.isEmpty ?"" :patientInfoMap["name"],
                              style: GSYConstant.textStyle(color: '#666666'),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('性别：',
                                style: GSYConstant.textStyle(color: '#333333')),
                            Text(patientInfoMap.isEmpty ?"" :patientInfoMap["sex_dictText"],
                                style: GSYConstant.textStyle(color: '#666666'))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('年龄：',
                                style: GSYConstant.textStyle(color: '#333333')),
                            Text(patientInfoMap.isEmpty ?"" :patientInfoMap["age"].toString() +'岁',
                                style: GSYConstant.textStyle(color: '#666666')),
                            SizedBox(
                              width: 16.0,
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              '费用：',
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                            Text(
                              patientInfoMap.isEmpty ?"" :patientInfoMap["payType_dictText"].toString(),
                              style: GSYConstant.textStyle(color: '#666666'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                transform:
                                    Matrix4.translationValues(-10.0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '科别：',
                                      style: GSYConstant.textStyle(
                                          color: '#333333'),
                                    ),
                                    Text(
                                      patientInfoMap.isEmpty ?"" :patientInfoMap["deptName"],
                                      style: GSYConstant.textStyle(
                                          color: '#666666'),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Divider(
                      height: 0,
                      color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.2),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      height: 39.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'NO：',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          Text(
                            dataMap["id"].toString(),
                            style: GSYConstant.textStyle(color: '#666666'),
                          ),
                          SizedBox(
                            width: 25.0,
                          ),
                          Text(
                            '开方：',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          Text(
                            dataMap["repictDate"] ==null ?"" : dataMap["repictDate"].toString(),
                            style: GSYConstant.textStyle(color: '#666666'),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.2),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      height: 39.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            '诊断：',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          Text(
                            diagnosisName,
                            style: GSYConstant.textStyle(color: '#666666'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 8.0,),
                  Container(
                    padding: const EdgeInsets.only(left: 16.0),
                    alignment: Alignment.centerLeft,
                    height: 40.0,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white
                    ),
                    child: Text('Rp',style: GSYConstant.textStyle(color: '#333333'),),
                  ),
                  Divider(height: 1,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),)
                ],
              ),
              category =="1" ?
              Column(
                  children: ListTile.divideTiles(
                      color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.5),
                      tiles: medicineList.asMap().keys.map((index) =>
                          Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: const BoxDecoration(color: Colors.white),
                              child:ListTile(
                                contentPadding: EdgeInsets.only(top: 8.0, bottom: 6.0),
                                title: Text(
                                  medicineList[index]['medicineName'],
                                  style: GSYConstant.textStyle(color: '#333333'),
                                ),
                                tileColor: Colors.white,
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 6.0,
                                    ),
                                    Text(
                                      medicineList[index]["specification"] ==null ?"" :
                                      medicineList[index]["specification"] +"/" +medicineList[index]["packageUnitid_dictValue"],
                                      style: GSYConstant.textStyle(
                                          fontSize: 13.0,
                                          color: '#666666'),
                                    ),
                                    const SizedBox(
                                      height: 3.0,
                                    ),
                                    Text(
                                      // "口服：一次3粒，一天三次",
                                      medicineList[index]['useType'] +"：" +medicineList[index]['freq'] +"," +medicineList[index]['dayNum'].toString() +"天",
                                      style: GSYConstant.textStyle(
                                          fontSize: 13.0,
                                          color: '#666666'),
                                    ),
                                    (medicineList[index]['remarks']
                                        ?.toString() ??
                                        '')
                                        .isNotEmpty
                                        ? Container(
                                      margin:
                                      const EdgeInsets.only(
                                          top: 3.0),
                                      child: Text(
                                          '备注：${medicineList[index]['remarks']}',
                                          // '备注：感冒感冒感冒感冒感冒感冒感冒感冒感冒感冒感冒感冒感冒感冒感冒',
                                          style: GSYConstant
                                              .textStyle(
                                              fontSize: 13.0,
                                              color:
                                              '#666666')),
                                    )
                                        : Container()
                                  ],
                                ),
                                trailing: Text(
                                  "x" +medicineList[index]['medicineNum'].toString(),
                                  style: GSYConstant.textStyle(color: '#666666'),
                                ),
                              ) ,
                            ),
                            // index==(list.length-1)?SizedBox(height: 8.0,):Container()
                          ]
                        ),
                      )).toList(),
                )
              :Column(
                children: ListTile.divideTiles(
                    color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.5),
                    tiles: medicineList.asMap().keys.map((index) =>
                        Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                decoration: const BoxDecoration(color: Colors.white),
                                child:ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    medicineList[index]['medicineName'],
                                    style: GSYConstant.textStyle(color: '#333333'),
                                  ),
                                  tileColor: Colors.white,
                                  trailing: Text(
                                   "x" +medicineList[index]['medicineNum'].toString(),
                                    style: GSYConstant.textStyle(color: '#666666'),
                                  ),
                                ) ,
                              ),
                            ]
                        ),
                    )).toList(),
              ),
              Visibility(
                visible: category =="2",
                child: const SizedBox(height: 8.0),),
              Visibility(
                visible: category =="2",
                child: Column(
                    children: ListTile.divideTiles(
                        color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.5),
                        tiles: list1.asMap().keys.map((index) =>
                            Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    decoration: const BoxDecoration(color: Colors.white),
                                    child:ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        list1[index]['label'],
                                        style: GSYConstant.textStyle(color: '#333333'),
                                      ),
                                      tileColor: Colors.white,
                                      trailing: Text(
                                        list1[index]['detail'],
                                        style: GSYConstant.textStyle(color: '#666666'),
                                      ),
                                    ) ,
                                  ),
                                ]
                            ),
                        )).toList(),
                  ),),
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                decoration: const BoxDecoration(
                  color: Colors.white
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('处方医师',style: GSYConstant.textStyle(color: '#333333'),),
                            // SizedBox(width: 15.0,),
                            Container(
                              color: Colors.white,
                              width: 80,
                              height: 55,
                              child: Transform.rotate(
                                angle: math.pi /-2,
                                child: Image.memory(
                                  Base64Decoder().convert(imageStr),
                                ),),
                            ),
                          ],
                        ),
                        // SizedBox(height: 25.0,),
                        // Row(
                        //   children: <Widget>[
                        //     Text('审方医师',style: GSYConstant.textStyle(color: '#333333'),),
                        //     SizedBox(width: 15.0,),
                        //     Text('苏山寒',style: GSYConstant.textStyle(fontSize:18.0,color: '#666666',fontFamily: 'ShouShuti'),)
                        //   ],
                        // )
                      ],
                    ),
                    // Image.asset('assets/images/chapter.png')
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 13.0,bottom: 27.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('备注：',style: GSYConstant.textStyle(fontSize: 13.0,color: '#666666'),),
                    SizedBox(height: 7.0,),
                    Text('该处方有效期为7天。',style: GSYConstant.textStyle(fontSize: 13.0,color: '#666666')),

                    // Text('1、该处方有效期为7天。',style: GSYConstant.textStyle(fontSize: 13.0,color: '#666666')),
                    // Text('2、该处方不支持线下药房购药。',style: GSYConstant.textStyle(fontSize: 13.0,color: '#666666')),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30.0,bottom: 34.0),
                alignment: Alignment.bottomCenter,
                child: SafeAreaButton(text: '发送处方', onPressed: () {


                }),
              ),
              // SafeArea(
              //   child:Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0),child: Row(
              //     children: <Widget>[
              //       Expanded(
              //         child: CustomOutlineButton(
              //             height: 40.0,
              //             title: '再次提交', onPressed: (){
              //
              //           showDialog<void>(
              //             context: context,
              //             builder: (BuildContext context) {
              //               return  SimpleDialog(
              //                 contentPadding: const EdgeInsets.all(16.0),
              //                 titlePadding: const EdgeInsets.only(top:29.0,left: 15.0,right: 13.0),
              //                 title:  Text('您可对原有处方进行再次确认提交，或进行补充说明后再次提交。',style: GSYConstant.textStyle(fontSize: 16.0,color: '#333333'),),
              //                 children: <Widget>[
              //                   SimpleDialogOption(
              //                     padding:EdgeInsets.zero,
              //                     child:Container(
              //                       constraints: const BoxConstraints(maxHeight: 104.0,minHeight: 104.0),
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(5.0),
              //                         border:Border.all(width: 1.0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3))
              //                       ),
              //                       child:TextField(
              //                         cursorColor: ColorsUtil.hexStringColor('#666666'),
              //                         style: GSYConstant.textStyle(fontSize: 14.0,color: '#666666'),
              //                         decoration: InputDecoration(
              //                           hintText: '',
              //                           contentPadding: const EdgeInsets.only(left: 16.0,top: 16.0),
              //                           border: InputBorder.none,
              //                           isCollapsed: true,//重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
              //                           fillColor: Colors.transparent,
              //                           filled: true,
              //                           hintStyle: GSYConstant.textStyle(fontSize: 14.0,color: '#999999'),
              //                           // enabledBorder:OutlineInputBorder(
              //                           //     borderRadius: BorderRadius.circular(5.0),
              //                           //     borderSide:  BorderSide(color: ColorsUtil.hexStringColor('#cccccc'), width: 0.5, style: BorderStyle.solid)),
              //                           // focusedBorder:OutlineInputBorder(
              //                           //     borderRadius: BorderRadius.circular(5.0),
              //                           //     borderSide:  BorderSide(color:ColorsUtil.hexStringColor('#cccccc'), width: 0.5, style: BorderStyle.solid)),
              //                         ),
              //                       ),
              //                     )
              //                   ),
              //                   SimpleDialogOption(
              //                     padding:const EdgeInsets.only(top: 24.0),
              //                     child:  Row(
              //                       children: [
              //                         Expanded(child: CustomOutlineButton(title: '取消', onPressed: () {
              //                           Navigator.pop(context);
              //                         },height: 40.0,textStyle: GSYConstant.textStyle(color: '#06B48D',),borderRadius: BorderRadius.circular(5.0), borderColor: ColorsUtil.primaryColor,)),
              //                         const SizedBox(width: 8.0,),
              //                         Expanded(
              //                             child: CustomElevatedButton(title: '确定', onPressed: () {
              //                           Navigator.pop(context);
              //
              //                         },height: 40.0, primary:'#06B48D',borderRadius:BorderRadius.circular(5.0),))
              //                       ],
              //                     ),
              //                     // onPressed: () {
              //                     //   Navigator.of(context).pop();
              //                     // },
              //                   ),
              //                 ],
              //               );
              //             },
              //           ).then((val) {
              //
              //           });
              //
              //
              //         }, borderRadius: BorderRadius.circular(5.0), borderColor:ColorsUtil.primaryColor) ,
              //       ),
              //       const SizedBox(width: 8.0,),
              //       Expanded(
              //         child: CustomElevatedButton(
              //           height: 40.0,
              //           title: '重新开方', onPressed: (){}, borderRadius: BorderRadius.circular(5.0),primary: '#06B48D',) ,
              //       )
              //
              //     ],
              //   ),) ,
              // )
            ],
          ),
        ));
  }
}
