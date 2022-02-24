import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyIncome extends StatefulWidget {
  const MyIncome({Key? key}) : super(key: key);

  @override
  _MyIncomeState createState() => _MyIncomeState();
}

class _MyIncomeState extends State<MyIncome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: [
          CustomAppBar(
            '我的收入',
            onBackPressed: () {
              Navigator.pop(context);
            },
          ),
          Container(
            height: 72,
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('总订单数',
                          style: GSYConstant.textStyle(color: '#333333')),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('182',
                          style: GSYConstant.textStyle(
                              fontWeight: FontWeight.w500,
                              color: '#333333',
                              fontFamily: 'Medium',
                              fontSize: 16.0)),
                    ],
                  ),
                ),
                Container(
                    width: 1,
                    decoration: BoxDecoration(
                        color:
                            ColorsUtil.hexStringColor('#cccccc', alpha: 0.6)),
                    height: 32),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('总收入',
                          style: GSYConstant.textStyle(color: '#333333')),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('12,300元',
                          style: GSYConstant.textStyle(
                              fontWeight: FontWeight.w500,
                              color: '#333333',
                              fontFamily: 'Medium',
                              fontSize: 16.0)),
                    ],
                  ),
                )
              ],
            ),
          ),
          ExpansionPanelList(
            children: [
              ExpansionPanel(
                backgroundColor: ColorsUtil.bgColor,
                headerBuilder: (context, isExpanded) {
                  return Container(
                    height: 44,
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '2020.02',
                              style: GSYConstant.textStyle(
                                  color: '#333333',
                                  fontFamily: 'Medium',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                          ],
                        ),
                        Text(
                          '支出¥100.34 收入¥2000.00',
                          style: GSYConstant.textStyle(color: '#999999'),
                        )
                      ],
                    ),
                  );
                },
                body: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  height: 91,
                  child: Row(
                    children: [
                      Image.asset('assets/images/home/')
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
