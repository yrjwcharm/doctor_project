import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/my/income_statistics.dart';
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
   bool isExpanded=true;
   String selectedValue = '全部账单';
   List dropList = [{'id': 1, 'name': '全部账单',},{'id': 2, 'name': '年账单',}, {'id': 3, 'name': '月账单'},{'id': 3, 'name': '日账单'}];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '我的收入',

      ),
      body: Column(
        children: [
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
          Container(
            margin: const EdgeInsets.only(top:16.0,left:15.0,right:15.0,bottom:16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 30.0,
                  // width: 95.0,
                  padding: const EdgeInsets.only(left: 9.0),
                  decoration: BoxDecoration(
                      color: ColorsUtil.hexStringColor('#ECECEC'),
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      alignment: Alignment.center,
                      value: selectedValue,
                      elevation: 0,
                      items:dropList.map((item) => DropdownMenuItem(
                        // alignment: Alignment.center,
                        value:item['name'],child: Text(item['name'], style: GSYConstant.textStyle(fontSize: 16.0,color:'#333333'),),
                      )).toList(), onChanged: (item) {
                        setState(() {
                          selectedValue = item.toString();
                        });
                    } ,),),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const IncomeStatistic()));
                  },
                  child:Row(
                    children: <Widget>[
                      Text('统计',style: GSYConstant.textStyle(fontSize: 13.0,color:'#999999'),),
                      const SizedBox(width: 8.0,),
                      // Icon(Icons.keyboard_arrow_right,color: ColorsUtil.hexStringColor('#999999'),)
                      Image.asset('assets/images/my/more.png',fit: BoxFit.cover,)
                    ],
                  ) ,
                )

              ],
            )
          ),
          ExpansionPanelList(
            expansionCallback: (int int,bool bool){
              setState(() {
                isExpanded = !bool;
              });
            },
            expandedHeaderPadding: const EdgeInsets.only(left: 0,right: 0,top:0,bottom: 0),
            children: [
              ExpansionPanel(
                isExpanded: isExpanded,
                backgroundColor: ColorsUtil.bgColor,
                headerBuilder: (context, isExpanded) {
                  return Container(
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
                  padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 13.0),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 16.0),
                        child:Image.asset('assets/images/my/info.png'),
                      ),
                      Expanded(
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('张可可', style: GSYConstant.textStyle(
                                          fontSize: 15.0, color: '#333333'),),
                                      const SizedBox(width:18.0 ,),
                                      Text('男', style: GSYConstant.textStyle(
                                          color: '#666666'),),
                                      Text('｜', style: GSYConstant.textStyle(
                                          color: '#666666')),
                                      Text('41岁', style: GSYConstant.textStyle(
                                          color: '#666666'))
                                    ],
                                  ),
                                  Text('+59.00',
                                    style: GSYConstant.textStyle(fontSize: 18.0,
                                        color: '#09BB8F',
                                        fontFamily: 'Medium'),)
                                ],
                              ),
                              const SizedBox(height: 4.0,),
                              Text('健康咨询', style: GSYConstant.textStyle(
                                  fontSize: 13.0, color: '#888888'),),
                              const SizedBox(height: 4.0,),
                              Text('今天 13:46', style: GSYConstant.textStyle(fontSize: 13.0,color: '#888888'),),
                              const SizedBox(height: 14.0,),
                              Divider(height: 2, color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),)
                            ],
                          ))
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
