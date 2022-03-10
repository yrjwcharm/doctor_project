import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/log_utils.dart';
import 'package:doctor_project/utils/text_utils.dart';
import 'package:doctor_project/utils/toast_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChoiceClinicReceptTimePerson extends StatefulWidget {
  const ChoiceClinicReceptTimePerson({Key key}) : super(key: key);

  @override
  _ChoiceClinicReceptTimePersonState createState() =>
      _ChoiceClinicReceptTimePersonState();
}

class _ChoiceClinicReceptTimePersonState
    extends State<ChoiceClinicReceptTimePerson> {
  String startTime = '';
  String endTime = '';
  List list = [];

  _selStartTime() {}

  @override
  void initState() {
    super.initState();
    list = [
      {'day': '周一', 'time': '12:30', 'checked': false},
      {'day': '周二', 'time': '12:31', 'checked': true},
      {'day': '周三', 'time': '01:01', 'checked': false},
      {'day': '周四', 'time': '01:02', 'checked': false},
      {'day': '周五', 'time': '01:03', 'checked': false},
      {'day': '周六', 'time': '01:04', 'checked': false},
      {'day': '周日', 'time': '01:05', 'checked': false}
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBar(
            '接诊时间/人数',
            onBackPressed: () {
              Navigator.pop(context);
            },
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
                                      Text(
                                        list[index]['time'],
                                        style: GSYConstant.textStyle(
                                            color: list[index]['checked']
                                                ? '#06B48D'
                                                : '#333333',
                                            fontSize: 12.0),
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
                              TextUtils.isEmpty(startTime) ? '开始时间' : startTime,
                              style: GSYConstant.textStyle(
                                  color: TextUtils.isEmpty(startTime)
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
                                    TextUtils.isEmpty(endTime)
                                        ? '结束时间'
                                        : endTime,
                                    style: GSYConstant.textStyle(
                                        color: TextUtils.isEmpty(endTime)
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
