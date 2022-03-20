import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/svg_utils.dart';

class UseDrugInfo extends StatefulWidget {
  const UseDrugInfo({Key? key}) : super(key: key);

  @override
  _UseDrugInfoState createState() => _UseDrugInfoState();
}

class _UseDrugInfoState extends State<UseDrugInfo> {
  final List list = [
    {'label': '每次用量', 'placeholder': '请选择频率'},
    {'label': '次数：', 'placeholder': '请输入数量 粒/次'},
    {'label': '用法：', 'placeholder': '请选择用法'},
    {'label': '持续用药天数：', 'placeholder': '请输入用药天数'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        '用药信息',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 40.0,
                  padding: const EdgeInsets.only(left: 16.0),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Text(
                    '请依据上传的病历/疾病资料，选择准确的药',
                    style:
                        GSYConstant.textStyle(fontSize: 12.0, color: '#EC605D'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 14.0, left: 16.0, right: 16.0),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            '胶体果胶铋胶囊',
                            style: GSYConstant.textStyle(
                                fontSize: 15.0, color: '#333333'),
                          ),
                          const SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            '规格：50mgx12粒x2板',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#888888'),
                          ),
                          Text(
                            '北京市生物制药有限公司',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#888888'),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            transform: Matrix4.translationValues(0, -3.0, 0),
                            width: 80,
                            height: 20,
                            margin: const EdgeInsets.only(bottom: 7.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                border: Border.all(
                                    width: 1.0,
                                    color:
                                        ColorsUtil.hexStringColor('#cccccc'))),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  width: 26,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1.0,
                                              color: ColorsUtil.hexStringColor(
                                                  '#cccccc')))),
                                  child: SvgUtil.svg('minus.svg'),
                                ),
                                Container(
                                  width: 26.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1.0,
                                              color: ColorsUtil.hexStringColor(
                                                  '#cccccc')))),
                                  child: TextField(
                                    style: GSYConstant.textStyle(
                                        fontSize: 12.0, color: '#333333'),
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9]")), //数字包括小数
                                    ],
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        fillColor: Colors.transparent,
                                        filled: true,
                                        hintText: '2',
                                        hintStyle: TextStyle(
                                            fontFamily: 'Medium',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            color: ColorsUtil.hexStringColor(
                                                '#333333')),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 26,
                                  child: SvgUtil.svg('increment_add.svg'),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '库存: 5000',
                            style: GSYConstant.textStyle(
                                color: '#888888', fontSize: 13.0),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 44.0,
                  padding: const EdgeInsets.only(left: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '用法用量',
                    style: GSYConstant.textStyle(
                        fontFamily: 'Medium',
                        fontWeight: FontWeight.w500,
                        color: '#333333'),
                  ),
                ),
                Column(
                  children: list
                      .map((item) => Container(
                          height: 40.0,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        color: ColorsUtil.hexStringColor(
                                            '#cccccc',
                                            alpha: 0.3)))),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 98.0,
                                  child: Text(
                                    item['label'],
                                    style:
                                        GSYConstant.textStyle(color: '#333333'),
                                  ),
                                ),
                                Expanded(
                                    child: TextField(
                                  cursorColor:
                                      ColorsUtil.hexStringColor('#666666'),
                                  style:
                                      GSYConstant.textStyle(color: '#666666'),
                                  inputFormatters: [],
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: item['placeholder'],
                                      hintStyle: GSYConstant.textStyle(
                                          color: '#999999')),
                                )),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                SvgUtil.svg('arrow.svg')
                              ],
                            ),
                          )))
                      .toList(),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16.0, top: 9.0),
                  constraints: const BoxConstraints(minHeight: 80.0),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '备注',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                      const SizedBox(
                        width: 6.0,
                      ),
                      Expanded(
                          child: TextField(
                        inputFormatters: [],
                        cursorColor: ColorsUtil.hexStringColor('#666666'),
                        style: GSYConstant.textStyle(color: '#666666'),
                        decoration: InputDecoration(
                            hintText: '请输入...',
                            isCollapsed: true,
                            hintStyle: GSYConstant.textStyle(color: '#999999'),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          )),
          Container(
            alignment: Alignment.center,
            child: SafeAreaButton(
              text: '确认',
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
