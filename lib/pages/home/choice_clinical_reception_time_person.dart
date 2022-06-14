import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/text_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  String patientCount = '';
  int weekDay = 0;
  bool isOpen = false;
  List<Widget> listComponent = [];

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
        'checked': isOpen
      },
      {
        'day': '周二',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'checked': isOpen
      },
      {
        'day': '周三',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'checked': isOpen
      },
      {
        'day': '周四',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'checked': isOpen
      },
      {
        'day': '周五',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'checked': isOpen
      },
      {
        'day': '周六',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'checked': isOpen
      },
      {
        'day': '周日',
        'startTime': '',
        'endTime': '',
        'patientCount': '',
        'checked': isOpen
      }
    ];
  }

  Future getData() async {
    var request = HttpRequest.getInstance();
    var res =
        await request.get(Api.checkDetailByTreatId + '?treatId=$treatId', {});
    if (res['code'] == 200) {
      setState(() {
        dataList = res['data'];
        print('timeList ====' + dataList.toString());

        for (int i = 0; i < dataList.length; i++) {
          weekDay = dataList[i]['weekDay'];
          if (weekDay != 0) {
            timeList[weekDay - 1]['startTime'] = dataList[i]['startTime'];
            timeList[weekDay - 1]['endTime'] = dataList[i]['endTime'];
            timeList[weekDay - 1]['patientCount'] = dataList[i]['patientCount'];
            timeList[weekDay - 1]['checked'] = true;
          }
        }
        print('timeList----List ====' + timeList.toString());
      });
    } else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar('接诊时间/人数'),
      body: Column(
        children: [
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
                  onTap: () {
                    setState(() {
                      listComponent.add(const SizedBox.shrink());
                    });
                  },
                  child: SvgUtil.svg('add_time.svg'),
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
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      (index == 0 ? 5.0 : 0)))))
                                      : ElevatedButton.styleFrom(
                                          primary: ColorsUtil.hexStringColor(
                                              '#F9F9F9'),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      index == 0 ? 5.0 : 0)))),
                                  onPressed: () {
                                    list.forEach((item) => {
                                          item['checked'] = false,
                                          if (mapEquals(item, list[index]))
                                            item['checked'] = true,
                                        });
                                    setState(() {});
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              color: ColorsUtil.primaryColor),
                                        ))
                                    : Container()
                              ],
                            ),
                          ))
                      .toList()),
              Column(
                children: listComponent.asMap().keys
                    .map<Widget>((index) => Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 10.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 10.0,
                                    top: 8.0,
                                    bottom: 9.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        width: 1.0,
                                        color: ColorsUtil.hexStringColor(
                                            '#cccccc',
                                            alpha: 0.3))),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: ScreenUtil().setWidth(53.0),
                                      child: Text(
                                        '开始时间',
                                        style: GSYConstant.textStyle(
                                            fontSize: ScreenUtil().setSp(13),
                                            color: '#999999'),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      '至',
                                      style: GSYConstant.textStyle(
                                          color: '#888880',
                                          fontSize: ScreenUtil().setSp(14.0)),
                                    ),
                                    const SizedBox(
                                      width: 7.0,
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(53.0),
                                      child: Text(
                                        '结束时间',
                                        style: GSYConstant.textStyle(
                                            fontSize: ScreenUtil().setSp(13),
                                            color: '#999999'),
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
                                width: ScreenUtil().setWidth(71.0),
                                height: 37.0,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(left: 8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        width: 1.0,
                                        color: ColorsUtil.hexStringColor(
                                            '#cccccc',
                                            alpha: 0.3))),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  style: GSYConstant.textStyle(
                                      fontSize: ScreenUtil().setSp(13),
                                      color: '#666666'),
                                  cursorColor:
                                      ColorsUtil.hexStringColor('#666666'),
                                  inputFormatters: [],
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      isCollapsed: true,
                                      hintText: '10人',
                                      border: InputBorder.none,
                                      hintStyle: GSYConstant.textStyle(
                                          fontSize: ScreenUtil().setSp(13),
                                          color: '#333333')),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  listComponent.remove(listComponent[index]);
                                },
                                child: SvgUtil.svg('minus.svg'),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
