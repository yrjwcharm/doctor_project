import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicPriceSet extends StatefulWidget {
  const TopicPriceSet({Key? key}) : super(key: key);

  @override
  _TopicPriceSetState createState() => _TopicPriceSetState();
}

class _TopicPriceSetState extends State<TopicPriceSet> {
  List list = [];
  @override
  void initState() {
    super.initState();
    list.add({'text':'免费'});
    list.add({'text':'10.00'});
    list.add({'text':'20.00'});
    list.add({'text':'30.00'});
    list.add({'text':'40.00'});
    list.add({'text':'自定义'});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.hexStringColor('#f9f9f9'),
      body: Column(
        children: [
          CustomAppBar(
            '问诊价格设置',
            isBack: true,
            onBackPressed: () {
              Navigator.pop(context);
            },
          ),
          Container(
            height: 148,
            padding: const EdgeInsets.only(
                top: 11.0, right: 16.0, bottom: 15.0, left: 16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 19.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '选择咨询价格 (元)',
                    style: GSYConstant.textStyle(color: '#333333'),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0, //主轴上子控件的间距
                  runSpacing: 16.0, //交叉轴上子控件之间的间距
                  children:list.asMap().keys.map((index) => SizedBox(
                    width: 80,
                    height: 33,
                    child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          side: BorderSide(width: 1, color: ColorsUtil.hexStringColor('#cccccc')),
                        ),
                        child: Text(
                          list[index]['text'],
                          style: GSYConstant.textStyle(color: '#333333'),
                        )),
                  )).toList(),
                )
              ],
            ),
          ),
          Expanded(child:Container(
            alignment: Alignment.bottomLeft,
            child:SafeAreaButton(onPressed: () {  }, text: '确定',),
          )
          )
        ],
      ),
    );
  }
}
