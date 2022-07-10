import 'dart:ffi';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/text_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:doctor_project/widget/custom_safeArea_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';
import '../../utils/toast_util.dart';

class ChoiceClinicReceptTimePerson extends StatefulWidget {
  const ChoiceClinicReceptTimePerson({Key? key, required this.treatId})
      : super(key: key);
  final String treatId;

  @override
  _ChoiceClinicReceptTimePersonState createState() =>
      _ChoiceClinicReceptTimePersonState(treatId);
}

class _ChoiceClinicReceptTimePersonState
    extends State<ChoiceClinicReceptTimePerson> {
  String startTime = '';
  String endTime = '';
  String treatId;
  List list = [];
  List timeList = [];
  List dataList = [];
  List startTimeList = [];
  String patientCount = '';
  int weekDay = 0;
  bool isOpen = false;
  List listComponent = [];
  int index = 0;
  int chooseDay = 0;
  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';
  Duration timer = const Duration();
  DateTime time = DateTime.now();

  _ChoiceClinicReceptTimePersonState(this.treatId);

  _selStartTime() {}

  @override
  void initState() {
    super.initState();
    getData();

    list = [
      {
        'day': '周一',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'timeList': timeList,
        'checked': isOpen
      },
      {
        'day': '周二',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'timeList': [],
        'checked': isOpen
      },
      {
        'day': '周三',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'timeList': [],
        'checked': isOpen
      },
      {
        'day': '周四',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'timeList': [],
        'checked': isOpen
      },
      {
        'day': '周五',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'timeList': [],
        'checked': isOpen
      },
      {
        'day': '周六',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'timeList': [],
        'checked': isOpen
      },
      {
        'day': '周日',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'timeList': [],
        'checked': isOpen
      }
    ];
    list[0]['checked'] = true;
  }

  Future getData() async {
    var request = HttpRequest.getInstance();
    var res =
        await request.get(Api.checkDetailByTreatId + '?treatId=$treatId', {});

    if (res['code'] == 200) {
      setState(() {
        dataList = res['data'];
        for (int i = 0; i < dataList.length; i++) {
          int weekDay = dataList[i]['weekDay'];
          list[weekDay-1]['timeList'].add(dataList[i]);
        }
      });
    } else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  Future reloadData() async {
    var request = HttpRequest.getInstance();
    var res =
    await request.get(Api.checkDetailByTreatId + '?treatId=$treatId', {});
    if (res['code']==200){
      setState(() {
        dataList = res['data'];
        for (int i = 0; i < dataList.length; i++) {
          int weekDay = dataList[i]['weekDay'];
          if(list[weekDay-1]['timeList'].length>0){
            list[weekDay-1]['timeList'].clear();
          }
        }
        for (int i = 0; i < dataList.length; i++) {
          int weekDay = dataList[i]['weekDay'];
          list[weekDay-1]['timeList'].add(dataList[i]);
        }
      });
    } else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  Future updateTime(String id,String patientCount,String startTime,String endTime) async {
    var request = HttpRequest.getInstance();
    var res =
    await request.post(Api.checkUpdateDetail, {
      'id':int.parse(id),
      'patientCount':patientCount,
      'startTime':startTime,
      'endTime':endTime
    });
    if (res['code'] == 200) {
      setState(() {});
    }else{
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  Future deleteTime(int id,index) async {
    var request = HttpRequest.getInstance();
    var res =
    await request.post(Api.checkUpdateDetail, {
      'id':id,
      'useflag':'0'
    });
    if (res['code'] == 200) {
      reloadData();
      setState(() {});
    }else{
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  Future insertTime(String startTime,int weekDay,String endTime,String patientCount) async {
    var request = HttpRequest.getInstance();
    print('insertTime ====weekDay' + weekDay.toString() +'startTime  '+startTime +'endTime  '+endTime+' patientCount '+patientCount);

    var res =
    await request.post(Api.checkInsertDetail, {
      'treatId':treatId,
      'weekDay':weekDay,
      'startTime':startTime,
      'endTime':endTime,
      'patientCount':patientCount
    });

    if (res['code'] == 200) {
//      list[weekDay-1]['timeList'].add({
//        'startTime': startTime,
//        'endTime': endTime,
//        'patientCount': patientCount,
//        'weekDay':weekDay
//      });
      reloadData();
      setState(() {});
    }else{
      ToastUtil.showToast(msg: res['msg']);
    }
  }


  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoDatePicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }

  bool _checkTime(String startTime,String endTime) {
    String startInput=startTime.replaceAll(':', '');
    String endInput=endTime.replaceAll(':', '');

    if(int.parse(endInput)-int.parse(startInput)<0){
      ToastUtil.showToast(msg: '结束时间不能早于开始时间！');
      return false;
    }
//    for(int i = 0;i < list[chooseDay]['timeList'].length;i++){
//      String startT = list[chooseDay]['timeList'][i]['startTime'].replaceAll(':', '');
//      print('startT ====='+startT);
//
//      String endT = list[chooseDay]['timeList'][i]['endTime'].replaceAll(':', '');
//      print('endT ====='+endT);
//
//      if(int.parse(startInput)>int.parse(startT) && int.parse(startInput)<int.parse(endT)){
//        ToastUtil.showToast(msg: '当前时间段已存在，请勿重复添加');
//        return false;
//      }
//      else if(int.parse(startInput)<int.parse(startT) && int.parse(endInput)<int.parse(endT)){
//        ToastUtil.showToast(msg: '当前时间段已存在，请勿重复添加');
//        return false;
//      }
//    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar('接诊时间/人数'),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 44,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '选择时间',
                        style: GSYConstant.textStyle(
                            fontFamily: 'Medium',
                            fontWeight: FontWeight.w500,
                            color: '#333333'),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
//                          setState(() {});
                          startTimeList.clear();
                        for(int i = 0;i < list[chooseDay]['timeList'].length;i++){
                          String startTime = list[chooseDay]['timeList'][i]["startTime"];
                          startTime=startTime.substring(0,2);
                          startTimeList.add(int.parse(startTime));
                        }
                        //把时间列表里的时间前面两位数字排序 放在数组里
                        startTimeList.sort((left,right)=>left.compareTo(right));
                          String newStartTime='';
                          String newEndTime='';
                        if(list[chooseDay]['timeList'].length >0){
                          final min_num = startTimeList.cast<num>().reduce(min);
                          final max_num = startTimeList.cast<num>().reduce(max);
                          final m = max_num-min_num;
                          if(m==1){//说明只有两条 只增加后边的时间
                            final time = max_num+1;
                            final end_time = max_num+2;
                            if(time.toString().length==1){
                              newStartTime = "0"+time.toString()+':00';
                            }else{
                              newStartTime = time.toString()+':00';
                            }
                            if(end_time.toString().length==1){
                              newEndTime = "0"+end_time.toString()+':00';
                            }else{
                              newEndTime = end_time.toString()+':00';
                            }
                            print("newStartTime=="+newStartTime+"\newEndTime==="+newEndTime+"\n");
                            insertTime(newStartTime, chooseDay+1, newEndTime, '20');
                          }else if(m>1){//大于两条
                            if(list[chooseDay]['timeList'].length==m+1){//每个时间段都是相邻的
                              final time = max_num+1;
                              final end_time = max_num+2;
                              if(time.toString().length==1){
                                newStartTime = "0"+time.toString()+':00';
                              }else{
                                newStartTime = time.toString()+':00';
                              }
                              if(end_time.toString().length==1){
                                newEndTime = "0"+end_time.toString()+':00';
                              }else{
                                newEndTime = end_time.toString()+':00';
                              }
                              insertTime(newStartTime, chooseDay+1, newEndTime, '20');
                            }
                            else {//不相邻
                              for(int i = 0;i<startTimeList.length;i++){
                                int min = startTimeList[i];
                                int max = startTimeList[i+1];
                                if(max-min>1){
                                  print("**********************");
                                  print("min=="+min.toString()+"\n"+"max===="+max.toString());
                                  final time = min+1;
                                  final end_time = min+2;
                                  if(time.toString().length==1){
                                    newStartTime = "0"+time.toString()+':00';
                                  }else{
                                    newStartTime = time.toString()+':00';
                                  }
                                  if(end_time.toString().length==1){
                                    newEndTime = "0"+end_time.toString()+':00';
                                  }else{
                                    newEndTime = end_time.toString()+':00';
                                  }
                                  insertTime(newStartTime, chooseDay+1, newEndTime, '20');
                                  return;
                                }
                              }
                            }
                          }else if(m==0){//只有一条
                            final time = max_num+1;
                            final end_time = max_num+2;
                            if(time.toString().length==1){
                              newStartTime = "0"+time.toString()+':00';
                            }else{
                              newStartTime = time.toString()+':00';
                            }
                            if(end_time.toString().length==1){
                              String newEndTime = "0"+end_time.toString()+':00';
                            }else{
                              newEndTime = end_time.toString()+':00';
                            }
                            print("newStartTime=="+newStartTime+"\newEndTime==="+newEndTime+"\n");
                            insertTime(newStartTime, chooseDay+1, newEndTime, '20');
                          }
                        }else {
                          insertTime('09:00', chooseDay+1, '10:00', '20');
                        }
                        },
                        child:
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:0.0,
                                vertical: 10.0
                            ),
                            child:SvgUtil.svg('add_time.svg')
                        ),

                      )
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        children: list
                            .asMap()
                            .keys
                            .map((index) => SizedBox(
                                  width: ScreenUtil().setWidth(66.0),
                                  height: 56,
                                  child: Stack(
                                    children: [
                                      ElevatedButton(
                                        style: list[index]['checked']
                                            ? ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    (index == 0
                                                                        ? 5.0
                                                                        : 0)))))
                                            : ElevatedButton.styleFrom(
                                                primary: ColorsUtil.hexStringColor(
                                                    '#F9F9F9'),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(index == 0 ? 5.0 : 0)))),
                                        onPressed: () {
                                          list.forEach((item) => {
                                                item['checked'] = false,
                                                chooseDay = index,
                                                if (mapEquals(
                                                    item, list[index]))
                                                  item['checked'] = true,

                                              });
                                          setState(() {});
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              list[index]['day'],
                                              style: GSYConstant.textStyle(
                                                  color: list[index]['checked']
                                                      ? '#06B48D'
                                                      : '#333333'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      list[index]['checked']
                                          ? Positioned(
                                              top: 13,
                                              child: Container(
                                                width: 3,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: ColorsUtil
                                                        .primaryColor),
                                              ))
                                          : Container()
                                    ],
                                  ),
                                ))
                            .toList()),
                    Column(
                      children: list[chooseDay]['timeList']
                          .asMap()
                          .keys
                          .map<Widget>((index) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 10.0,right: 0.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 10.0,
                                          top: 8.0,
                                          bottom: 9.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                              width: 0.5,
                                              color: ColorsUtil.hexStringColor(
                                                  '#cccccc',
                                                  alpha: 0.3))),
                                      child: Row(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () async {
                                              _showDialog(
                                                CupertinoDatePicker(
                                                  initialDateTime: time,
                                                  mode: CupertinoDatePickerMode.time,
                                                  use24hFormat: true,
                                                  // This is called when the user changes the time.
                                                  onDateTimeChanged: (DateTime newTime) {
                                                    String timeStr = newTime.toString();
                                                    timeStr = timeStr.substring(10);
                                                    timeStr = timeStr.substring(0, 6);

                                                    if(_checkTime(timeStr, list[chooseDay]['timeList'][index]['endTime'])){
                                                      setState(() => list[chooseDay]['timeList'][index]['startTime'] = timeStr);
                                                      updateTime(list[chooseDay]['timeList'][index]['id'].toString(), list[chooseDay]['timeList'][index]['patientCount'].toString(),list[chooseDay]['timeList'][index]['startTime'],list[chooseDay]['timeList'][index]['endTime']);
                                                    }
                                                  },
                                                ),
                                              );
                                            },
                                            child: SizedBox(
                                              width:
                                                  ScreenUtil().setWidth(53.0),
                                              child: Text(
                                                list[chooseDay]['timeList'][index]['startTime'],
                                                style: GSYConstant.textStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(13),
                                                    color: '#999999'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            '至',
                                            style: GSYConstant.textStyle(
                                                color: '#888880',
                                                fontSize:
                                                    ScreenUtil().setSp(14.0)),
                                          ),
                                          const SizedBox(
                                            width: 7.0,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              _showDialog(
                                                CupertinoDatePicker(
                                                  initialDateTime: time,
                                                  mode: CupertinoDatePickerMode.time,
                                                  use24hFormat: true,
                                                  // This is called when the user changes the time.
                                                  onDateTimeChanged: (DateTime newTime) {
                                                    String timeStr = newTime.toString();
                                                    timeStr = timeStr.substring(10);
                                                    timeStr = timeStr.substring(0, 6);
                                                    if(_checkTime(list[chooseDay]['timeList'][index]['startTime'], timeStr))
                                                    setState(() => list[chooseDay]['timeList'][index]['endTime'] = timeStr);
                                                    updateTime(list[chooseDay]['timeList'][index]['id'], list[chooseDay]['timeList'][index]['patientCount'].toString(),list[chooseDay]['timeList'][index]['startTime'],list[chooseDay]['timeList'][index]['endTime']);
                                                  },
                                                ),
                                              );
                                            },
                                            child: SizedBox(
                                              width:
                                                  ScreenUtil().setWidth(53.0),
                                              child: Text(
                                                list[chooseDay]['timeList'][index]['endTime'],
                                                style: GSYConstant.textStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(13),
                                                    color: '#999999'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          SvgUtil.svg('calendar.svg')
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: ScreenUtil().setWidth(53.0),
                                      height: 37.0,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(left: 8.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                              width: 0.5,
                                              color: ColorsUtil.hexStringColor(
                                                  '#cccccc',
                                                  alpha: 0.3))),
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        style: GSYConstant.textStyle(
                                            fontSize: ScreenUtil().setSp(13),
                                            color: '#666666'),
                                        cursorColor: ColorsUtil.hexStringColor(
                                            '#666666'),
                                        inputFormatters: [],
                                        keyboardType:
                                        TextInputType
                                            .number,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            fillColor: Colors.transparent,
                                            filled: true,
                                            isCollapsed: true,
                                            hintText: list[chooseDay]['timeList'][index]['patientCount'].toString(),
                                            border: InputBorder.none,
                                            hintStyle: GSYConstant.textStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(13),
                                                color: '#333333')),
                                        onChanged: (Value) {
                                          print("patientCount =="+Value.toString());
                                          String patient = Value.toString();
                                          updateTime(list[chooseDay]['timeList'][index]['id'], patient,list[chooseDay]['timeList'][index]['startTime'],list[chooseDay]['timeList'][index]['endTime']);
                                        },
                                      ),
                                    ),
//                                    const SizedBox(
//                                      width: 25.0,
//                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        setState(() {
                                          int id = list[chooseDay]['timeList'][index]['id'];
                                          list[chooseDay]['timeList'].removeAt(index);
                                          deleteTime(id,index);
                                          setState(() {});
                                        });
                                      },
                                      child:
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal:25.0,
                                              vertical: 10.0
                                            ),
                                            child:SvgUtil.svg('minus.svg')
                                        ),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
                Container(
                    height:35 ,
                    margin: const EdgeInsets.only(left:10.0,top: 30.0,right: 10.0),
                    child:
                    Column(
                        children: <Widget>[
                          Text('温馨提示：\n 1、视频问诊时间段设置是按周设置，新增、修改、删除操作是指对未生成的号源做调整，操作执行后实时提交；\n 2、若需要修改已添加的号源，需到管理后台将号源停诊后，再重新设置。',style: GSYConstant.textStyle(color: '#333333',fontSize: 14.0)),
                        ]
                    )
                ),
              ],
            ),
          )),

          CustomSafeAreaButton(
            margin: const EdgeInsets.only(bottom: 16.0),
            onPressed: () {
              Navigator.pop(context,20);
            },
            title: '提交',
          )
        ],
      ),
    );
  }
}
