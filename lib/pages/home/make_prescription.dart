import 'package:doctor_project/pages/home/add-drug.dart';
import 'package:doctor_project/pages/home/add_drug_list.dart';
import 'package:doctor_project/pages/home/diagnosis.dart';
import 'package:doctor_project/utils/picker_utils.dart';
import 'package:doctor_project/utils/svg_utils.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'package:flutter/material.dart';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
class MakePrescription extends StatefulWidget {
  const MakePrescription({Key? key}) : super(key: key);

  @override
  _MakePrescriptionState createState() => _MakePrescriptionState();
}

class _MakePrescriptionState extends State<MakePrescription> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List list = [];
  List list1 = [];
  List drugList = [
    {'name':'[阿莫灵]阿莫西林胶囊0.25*24粒/盒','usage':'一次3粒，4次/天','price':'38.30','count':'2'},
    {'name':'先锋霉素VI胶囊 头孢拉定胶囊0.25*24粒/盒','remark':'饭后半小时吃','usage':'一次3粒，4次/天','price':'38.30','count':'2'}
  ];
  final List<String> pickerData = <String>['通海县人民医院', '京东大药房', '阿里健康大药房'];
  bool tab1Active=true;
  bool tab2Active = false;
  @override
  void initState() {
    super.initState();
    list = [
      {
        'title': '处方类型',
        'detail': '普通处方',
        'isArrow': true,
      },
      {
        'title': '诊断',
        'detail': '请选择诊断',
        'isArrow': true,
      },
      {
        'title': '药房',
        'detail': '请选择药房',
        'isArrow': true,
      },
    ];
    list1 = [
      {
        'title': '处方贴数',
        'subTitle': '(付/剂)',
        'detail': '请输入数量',
        'isArrow': false,
      },
      {
        'title': '用法',
        'detail': '请选择用法',
        'isArrow': true,
      },
      {
        'title': '频次',
        'detail': '请选择频次',
        'isArrow': true,
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        '开处方',
        isBack: true,
        onBackPressed: () {
          Navigator.of(context).pop(this);
        },
      ),
      backgroundColor: ColorsUtil.bgColor,
      body:SingleChildScrollView(child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 14.0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tab1Active = true;
                      tab2Active = false;
                    });
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        tab1Active
                            ? 'assets/images/self_mention.png'
                            : 'assets/images/self_mention1.png',
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                          width: tab1Active?206:169,
                          height: 44,
                          child: Center(
                              child: Text(
                                '西药/中成药处方',
                                style: GSYConstant.textStyle(
                                    fontSize: 17.0, color:tab1Active? '#06B48D':'#333333'),
                              ))),
                    ],
                  ),
                ),
                Flexible(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          tab2Active =true;
                          tab1Active = false;
                        });
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            tab2Active
                                ? 'assets/images/express_delivery1.png'
                                : 'assets/images/express_delivery.png',
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                              width:tab2Active?206:169,
                              height: 44,
                              child: Center(
                                child: Text(
                                  '中药处方',
                                  style: GSYConstant.textStyle(
                                      fontSize: 16.0, color:tab2Active? '#06B48D':'#333333'),
                                ),
                              )),
                        ],
                      ),
                    ))
              ],
            ),
          ),
          Column(
              children: ListTile.divideTiles(
                  color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                  tiles: list.asMap().keys.map((index) => ListTile(
                        onTap: () {
                          switch (index) {
                            case 0:
                              PickerUtil.showPicker(context, _scaffoldKey, pickerData: pickerData, confirmCallback: (Picker picker, List<int> selected) {

                              });
                              break;
                            case 1:
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>const  WesternDiagnosis()));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Diagnosis()));
                              break;
                            case 2:
                              PickerUtil.showPicker(context, _scaffoldKey, pickerData: pickerData, confirmCallback: (Picker picker, List<int> selected) {

                              });
                              break;
                          }
                        },
                        tileColor: Colors.white,
                        title: Row(
                          children: <Widget>[
                            Text(
                              list[index]['title'],
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                            Text(
                              list[index]['subTitle'] ?? '',
                              style: GSYConstant.textStyle(color: '#333333'),
                            )
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              list[index]['detail'],
                              style: GSYConstant.textStyle(color: '#666666'),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            list[index]['isArrow']
                                ? Image.asset(
                                    'assets/images/home/arrow_right.png')
                                : Container()
                          ],
                        ),
                      ))).toList()),
          const SizedBox(
            height: 8.0,
          ),
          // Column(
          //   children: list1.map(
          //         (item) => Column(
          //           children: <Widget>[
          //             Container(
          //               height: 44.0,
          //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //               decoration: const BoxDecoration(color: Colors.white),
          //               // margin: const EdgeInsets.only(top: 8.0),
          //               child: Row(
          //                 children: <Widget>[
          //                   Row(
          //                     children: <Widget>[
          //                       Text(
          //                         item['title'],
          //                         style:
          //                             GSYConstant.textStyle(color: '#333333'),
          //                       ),
          //                       // Text('(付/剂)',style: GSYConstant.textStyle(color: '#999999'),)
          //                     ],
          //                   ),
          //                   Expanded(
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.end,
          //                       children: <Widget>[
          //                         SizedBox(
          //                           width:250.0,
          //                           child: TextField(
          //                             textAlign: TextAlign.right,
          //                             textAlignVertical:
          //                                 TextAlignVertical.center,
          //                             style: GSYConstant.textStyle(
          //                                 color: '#999999'),
          //                             decoration: InputDecoration(
          //                                 hintText: item['detail'],
          //                                 isCollapsed: true,
          //                                 contentPadding: EdgeInsets.zero,
          //                                 // suffixIcon: Image.asset('assets/images/home/arrow_right.png'),
          //                                 border: InputBorder.none,
          //                                 // isCollapsed: true,
          //                                 hintStyle: GSYConstant.textStyle(
          //                                     color: '#999999')),
          //                           ),
          //                         ),
          //                         const SizedBox(width: 8.0,),
          //                         item['isArrow']?Image.asset('assets/images/home/arrow_right.png'):Container()
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //             Divider(
          //               height: 0,
          //               color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
          //             )
          //           ],
          //         ),
          //       )
          //       .toList(),
          // ),
          ListTile(
            tileColor: Colors.white,
            title: const Text('RP'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SvgUtil.svg(
                  'increment.svg',
                ),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddDrugList()));
                }, child: Text('添加药品',style: GSYConstant.textStyle(color: '#06B48D'),))
              ],
            ),
          ),
          drugList.isNotEmpty?ListView(
            shrinkWrap: true,
            children:drugList.asMap().keys.map((index) => Container(
                decoration: const BoxDecoration(
                    color: Colors.white
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.only(top:11.0,bottom:14.0),child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(drugList[index]['name'],style: GSYConstant.textStyle(color: '#333333'),),
                            const SizedBox(height: 4.0,),
                            Text('口服：${drugList[index]['usage']}',style: GSYConstant.textStyle(fontSize: 13.0,color: '#666666'),),
                            (drugList[index]['remark']?.toString()??'').isNotEmpty?Container(
                              margin: const EdgeInsets.only(top: 4.0),
                              child: Text('备注：${drugList[index]['remark']}',style: GSYConstant.textStyle(fontSize: 13.0,color: '#666666')),
                            ):Container()
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('¥${drugList[index]['price']}',style: GSYConstant.textStyle(fontSize: 10.0,color: '#333333'),),
                            const SizedBox(height: 5.0,),
                            Text('x ${drugList[index]['count']}',style: GSYConstant.textStyle(fontSize: 12.0,color: '#888888'),)
                          ],
                        ),
                      ],
                    ),),
                    index!=drugList.length-1?Divider(height: 0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),):Container()
                  ],
                )
            )).toList()
          ):Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 25.0,bottom: 31.0),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Text('暂时还没有药品添加',style: GSYConstant.textStyle(fontSize: 13.0,color: '#666666'),),
          ),
          drugList.isNotEmpty?Divider(height: 0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),):Container(),
          drugList.isNotEmpty?Container(
            height: 40.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const BoxDecoration(
              color: Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('共${drugList.length}件',style: GSYConstant.textStyle(fontSize: 13.0,color: '#999999'),),
                Row(
                  children: <Widget>[
                    Text('合计:',style: GSYConstant.textStyle(fontSize: 13.0,color: '#333333'),),
                    Text('¥ ${50.30}',style: GSYConstant.textStyle(fontFamily:'Medium',fontSize: 16.0,color: '#06B48D'),)
                  ],
                ),
              ],
            ),
          ):Container(),
          Container(
            margin: const EdgeInsets.only(top:30.0),
            alignment: Alignment.bottomCenter,
            child: SafeAreaButton(text: '电子签名', onPressed:(){})
            ,
          )
        ],
      ),)
    );
  }
}
