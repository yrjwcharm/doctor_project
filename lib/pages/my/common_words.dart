import 'package:doctor_project/pages/my/add-common-words.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/style/gsy_style.dart';
import '../../widget/custom_safeArea_button.dart';

class CommonWords extends StatefulWidget {
  const CommonWords({Key? key}) : super(key: key);

  @override
  _CommonWordsState createState() => _CommonWordsState();
}

class _CommonWordsState extends State<CommonWords> {
  Widget _renderRow(BuildContext context, int index) {
    return Container(
       height: 44.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
         color: Colors.white,
         border: Border(bottom: BorderSide(color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),width: 1.0))
       ),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[
           Text('您哪里不舒服?',style: GSYConstant.textStyle(fontSize: 14.0,color: '#333333'),),
           SvgUtil.svg('forward_arrow.svg')
         ],
       ),
    );
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        '医生常用语',
      
      ),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 43.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '共',
                        style:
                        GSYConstant.textStyle(fontSize: 15.0, color: '#666666'),
                      ),
                      const SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        '3',
                        style:
                        GSYConstant.textStyle(fontSize: 15.0, color: '#f34c35'),
                      ),
                      const SizedBox(
                        width: 3.0,
                      ),
                      Text('条常用语',
                          style: GSYConstant.textStyle(
                              fontSize: 15.0, color: '#666666')),
                    ],
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: _renderRow)
              ],
            ),
          )),
          CustomSafeAreaButton(
              margin: const EdgeInsets.only(bottom: 16.0),
              customChild:true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SvgUtil.svg('increment.svg'),
                  const SizedBox(width: 9.0,),
                  Text('添加常用语',style: GSYConstant.textStyle(fontSize: 16.0),)
                ],
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddCommonWords()));
              })
        ],
      ),
    );
  }
}
