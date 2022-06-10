import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class IncomeStatistic extends StatefulWidget {
  const IncomeStatistic({Key? key}) : super(key: key);

  @override
  _IncomeStatisticState createState() => _IncomeStatisticState();
}

class _IncomeStatisticState extends State<IncomeStatistic> {
  bool tab1Active = true;
  bool tab2Active = false;
  String  selectedValue='2021-02';
  List dropList =[{'date':'2021-02'},{'date':'2021-03'},{'date':'2021-04'}];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          '统计',
          
          leftIcon: 'assets/images/icon_back.png',
          titleColor: '#ffffff',
          startColor: ColorsUtil.hexStringColor('#06B48D'),
          endColor: ColorsUtil.hexStringColor('#21D1AA'),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                ColorsUtil.hexStringColor('#06B48D'),
                ColorsUtil.hexStringColor('#21D1AA')
              ])),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          tab1Active = true;
                          tab2Active = false;
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          Text(
                            '月统计',
                            style: GSYConstant.textStyle(fontSize: 16.0),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Container(
                              height: 1,
                              width: 45,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2.0,
                                      color: tab1Active
                                          ? Colors.white
                                          : Colors.transparent)))
                        ],
                      )),
                  SizedBox(
                    width: 44.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tab1Active = false;
                        tab2Active = true;
                      });
                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          '月统计',
                          style: GSYConstant.textStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Container(
                          height: 1,
                          width: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2.0,
                                  color: tab2Active
                                      ? Colors.white
                                      : Colors.transparent)),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: Image.asset('assets/images/drop-down.png'),
                        dropdownColor: ColorsUtil.hexStringColor('#cccccc'),
                        alignment: Alignment.center,
                        value: selectedValue,
                        elevation: 0,
                        items:dropList.map((item) => DropdownMenuItem(
                          alignment: Alignment.centerLeft,
                          value:item['date'],child:Container(
                          margin:const EdgeInsets.only(right: 11.0),
                          child: Text(item['date'], style: GSYConstant.textStyle(fontWeight: FontWeight.w500,fontFamily: 'Medium', fontSize: 16.0),),
                        ),
                        )).toList(), onChanged: (item) {
                        setState(() {
                          selectedValue = item.toString();
                        });
                      } ,),),
                    Row(
                      children: <Widget>[
                        CustomOutlineButton(
                          width: 52.0,
                          height: 20,
                          textStyle: GSYConstant.textStyle(color: '#ffffff'),
                          onPressed: () {},
                          title: '收入',
                          borderRadius: BorderRadius.circular(11.0),
                          borderColor: ColorsUtil.hexStringColor('#ffffff'),
                        ),
                        SizedBox(width: 28.0,),
                        CustomOutlineButton(
                          width: 52.0,
                          height: 20,
                          textStyle: GSYConstant.textStyle(color: '#ffffff'),
                          onPressed: () {},
                          title: '支出',
                          borderRadius: BorderRadius.circular(11.0),
                          borderColor: Colors.transparent,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                padding: const EdgeInsets.symmetric(horizontal: 21.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('共收入14笔，合计',style: GSYConstant.textStyle(),),
                    Row(
                      children: <Widget>[
                        Text('¥',style: GSYConstant.textStyle(fontSize: 14.0),),
                        Text('1962.90',style: GSYConstant.textStyle(fontSize: 20.0,fontFamily: 'Medium'),)
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 39.0,),
              Expanded(child: Container(
                padding: const EdgeInsets.only(left: 21.0,top: 15.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),topLeft: Radius.circular(10.0))
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 2,
                          height: 14,
                          decoration: BoxDecoration(
                            color: ColorsUtil.primaryColor,
                            borderRadius: BorderRadius.circular(1)
                          ),
                        ),
                        SizedBox(width: 7.0,),
                        Text('收入分类',style: GSYConstant.textStyle(color: '#333333'),)
                      ],
                    ),
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
