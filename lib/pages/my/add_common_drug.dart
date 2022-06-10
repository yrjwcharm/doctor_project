import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/screen_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCommonDrug extends StatefulWidget {
  const AddCommonDrug({Key? key}) : super(key: key);

  @override
  _AddCommonDrugState createState() => _AddCommonDrugState();
}

class _AddCommonDrugState extends State<AddCommonDrug> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('添加常用药'),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
                        children: [
                          SvgUtil.svg('self_mention.svg',
                              width: ScreenUtil().setWidth(206.0)),
                          Positioned(
                              top: 10.0,
                              child: Text(
                                '西药/中成药处方',
                                style: GSYConstant.textStyle(
                                    fontSize: 17.0, color: '#06b48d'),
                              ))
                        ],
                      ),
                    ),
                    Positioned(
                        right: 0,
                        top: 3.0,
                        // right: 32.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgUtil.svg('express_delivery.svg',
                                width: ScreenUtil().setWidth(186.0)),
                            Positioned(
                                top: 8.0,
                                child: Text(
                                  '中药处方',
                                  style: GSYConstant.textStyle(
                                      fontSize: 16.0, color: '#333333'),
                                ))
                          ],
                        ))
                  ],
                ),
                Container(
                  height: 44.0,
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '科室选择',
                        style: GSYConstant.textStyle(
                            fontSize: 14.0, color: '#333333'),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '请选择科室',
                            style: GSYConstant.textStyle(
                                fontSize: 14.0, color: '#999999'),
                          ),
                          const SizedBox(
                            width: 7.0,
                          ),
                          SvgUtil.svg('forward_more.svg'),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
