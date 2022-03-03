import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/toast_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChoiceClinicReceptTimePerson extends StatefulWidget {
  const ChoiceClinicReceptTimePerson({Key? key}) : super(key: key);

  @override
  _ChoiceClinicReceptTimePersonState createState() =>
      _ChoiceClinicReceptTimePersonState();
}

class _ChoiceClinicReceptTimePersonState
    extends State<ChoiceClinicReceptTimePerson> {
  _selStartTime() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
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
                  onTap: (){
                    ToastUtil.showToast(msg: '点击了');
                  },
                  child:Image.asset(
                    'assets/images/home/add.png',
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 66,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: ColorsUtil.hexStringColor('#F9F9F9'),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5.0)))),
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '周一',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          Text(
                            '12:30',
                            style: GSYConstant.textStyle(
                                color: '#333333', fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 176,
                    height: 37,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3))
                    ),
                    child: Row(
                      children: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0.0)
                          ),
                          onPressed: _selStartTime,
                          child: Text(
                            '开始时间',
                            style: GSYConstant.textStyle(color: '#333333'),
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
                                  '结束时间',
                                  style: GSYConstant.textStyle(color: '#333333'),
                                )),
                            Image.asset('assets/images/home/time.png')
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 37,
                    width: 71,
                    child: CustomInputWidget(hintText: '接诊人数', hintStyle: GSYConstant.textStyle(
                      fontSize: 13.0
                    ), textStyle: GSYConstant.textStyle(fontSize: 13.0,color: '#333333'), onChanged: (String value) {

                    },),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
