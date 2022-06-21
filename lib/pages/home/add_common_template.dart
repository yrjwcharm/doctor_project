import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/screen_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCommonTemplate extends StatefulWidget {
  const AddCommonTemplate({Key? key}) : super(key: key);

  @override
  _AddCommonTemplateState createState() => _AddCommonTemplateState();
}

class _AddCommonTemplateState extends State<AddCommonTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar('西药/中成药处方模板'),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 43.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('模板名称',style: GSYConstant.textStyle(color: '#333333'),),
                 SizedBox(
                   width: ScreenUtil().setWidth(120.0),
                   child:TextField(
                  textAlign: TextAlign.right,
                  style: GSYConstant.textStyle(color: '#666666'),
                  cursorColor:ColorsUtil.hexStringColor('#666666') ,
                  inputFormatters: [],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    fillColor: Colors.transparent,
                    filled: true,
                    hintText: '请输入',
                    border: InputBorder.none,
                    hintStyle: GSYConstant.textStyle(color: '#666666')
                  ),
                ),)
              ]
            ),
          )
        ],
      ),
    );
  }
}
