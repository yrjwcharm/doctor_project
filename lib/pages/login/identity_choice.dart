import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/svg_utils.dart';

class IdentityChoice extends StatefulWidget {
  const IdentityChoice({Key? key}) : super(key: key);

  @override
  _IdentityChoiceState createState() => _IdentityChoiceState();
}

class _IdentityChoiceState extends State<IdentityChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('身份选择',onBackPressed: (){
        Navigator.pop(context);
      },),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 33.0,),
           Text('请选择您的职业',style: GSYConstant.textStyle(fontSize: 18.0,color: '#333333'),),
          const SizedBox(height: 13.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('确认之后',style: GSYConstant.textStyle(fontSize: 13.0,color: '#999999'),),
              Text('不允许修改',style: GSYConstant.textStyle(fontSize: 13.0,color: '#06B48D'),),
              Text('，请谨慎操作',style: GSYConstant.textStyle(fontSize: 13.0,color: '#06B48D'))
            ],
          ),
          const SizedBox(height: 54.0,),
          GridView(
              shrinkWrap: true,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18, //横轴三个子widget
                  childAspectRatio: 1.5 //宽高比为1时，子widget
              ),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SvgUtil.svg('internet_doc.svg'),
                    const SizedBox(
                      height: 13.0,
                    ),
                    Text(
                      '互联网医生',
                      style: GSYConstant.textStyle(
                          fontSize: 14.0, color: '#666666'),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    SvgUtil.svg('evaluate_doc.svg'),
                    const SizedBox(
                      height: 13.0,
                    ),
                    Text(
                      '评估医生',
                      style: GSYConstant.textStyle(
                          fontSize: 14.0, color: '#666666'),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    SvgUtil.svg('drug_doc.svg'),
                    const SizedBox(
                      height: 13.0,
                    ),
                    Text(
                      '药师',
                      style: GSYConstant.textStyle(
                          fontSize: 14.0, color: '#666666'),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    SvgUtil.svg('nurse.svg'),
                    const SizedBox(
                      height: 13.0,
                    ),
                    Text(
                      '护士',
                      style: GSYConstant.textStyle(
                          fontSize: 14.0, color: '#666666'),
                    )
                  ],
                ),
              ])
        ],
      ),
    );
  }
}
