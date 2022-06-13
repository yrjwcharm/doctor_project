import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/text_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';
import '../../utils/toast_util.dart';

class ChoiceClinicReceptTimePerson extends StatefulWidget {
  const ChoiceClinicReceptTimePerson({Key? key,required this.treatId}) : super(key: key);
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

  _ChoiceClinicReceptTimePersonState(this.treatId);

  _selStartTime() {}

  @override
  void initState() {
    super.initState();
    getData();
    list = [
      {'day': '周一','startTime':'','endTime':'','patientCount':'','checked': isOpen},
      {'day': '周二','startTime':'','endTime':'','patientCount':'','checked': isOpen},
      {'day': '周三','startTime':'','endTime':'','patientCount':'','checked': isOpen},
      {'day': '周四','startTime':'','endTime':'','patientCount':'','checked': isOpen},
      {'day': '周五','startTime':'','endTime':'','patientCount':'','checked': isOpen},
      {'day': '周六','startTime':'','endTime':'','patientCount':'','checked': isOpen},
      {'day': '周日','startTime':'','endTime':'','patientCount':'','checked': isOpen}
    ];

  }

  Future getData() async {
    var request = HttpRequest.getInstance();
    var res = await request.get(
        Api.checkDetailByTreatId+'?treatId=$treatId', {});
    if (res['code'] == 200) {
        setState(() {
        dataList = res['data'];
        print('timeList ===='+dataList.toString());

        for (int i = 0;i<dataList.length;i++){
          weekDay = dataList[i]['weekDay'];
          if(weekDay != 0){
            timeList[weekDay-1]['startTime'] = dataList[i]['startTime'];
            timeList[weekDay-1]['endTime'] = dataList[i]['endTime'];
            timeList[weekDay-1]['patientCount'] = dataList[i]['patientCount'];
            timeList[weekDay-1]['checked'] = true;
          }
        }
        print('timeList----List ===='+timeList.toString());

      });
    } else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBar(
            '接诊时间/人数',
          ),
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
                    ToastUtil.showToast(msg: '点击了');
                  },
                  child: Image.asset(
                    'assets/images/home/add.png',
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
                      .map((index) => Container(
                            margin: const EdgeInsets.only(right: 32.0),
                            width: 66,
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
                                      item['checked']=false,
                                      if (mapEquals(item, list[index]))
                                        item['checked'] = true,
                                    });
                                    setState(() {

                                    });
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
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 176,
                      height: 37,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(
                              color: ColorsUtil.hexStringColor('#cccccc',
                                  alpha: 0.3))),
                      child: Row(
                        children: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0.0)),
                            onPressed: _selStartTime,
                            child: Text(
                              TextUtil.isEmpty(startTime) ? '开始时间' : startTime,
                              style: GSYConstant.textStyle(
                                  color: TextUtil.isEmpty(startTime)
                                      ? '#999999'
                                      : '#333333'),
                            ),
                          ),
                          Text(
                            '至',
                            style: GSYConstant.textStyle(color: '#888880'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: _selStartTime,
                                  child: Text(
                                    TextUtil.isEmpty(endTime)
                                        ? '结束时间'
                                        : endTime,
                                    style: GSYConstant.textStyle(
                                        color: TextUtil.isEmpty(endTime)
                                            ? '#999999'
                                            : '#333333'),
                                  )),
                              Image.asset('assets/images/home/time.png')
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 32.0,
                    ),
                    SizedBox(
                      height: 37,
                      width: 71,
                      child: CustomInputWidget(
                        hintText: '接诊人数',
                        hintStyle: GSYConstant.textStyle(
                            fontSize: 13.0, color: '#999999'),
                        left: 0,
                        textStyle: GSYConstant.textStyle(
                            fontSize: 13.0, color: '#333333'),
                        onChanged: (String value) {},
                      ),
                    ),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 16.0),
                      child: const Image(
                        image: AssetImage('assets/images/home/minus.png'),
                        fit: BoxFit.cover,
                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
