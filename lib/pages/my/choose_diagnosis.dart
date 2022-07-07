import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/style/gsy_style.dart';
import '../../utils/svg_util.dart';

class ChooseDiagnosis extends StatefulWidget {
  const ChooseDiagnosis({Key? key}) : super(key: key);

  @override
  _ChooseDiagnosisState createState() => _ChooseDiagnosisState();
}

class _ChooseDiagnosisState extends State<ChooseDiagnosis> {
  final TextEditingController _editingController = TextEditingController();
  String keywords = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar('添加诊断'),
        backgroundColor: ColorsUtil.bgColor,
        body: Column(children: <Widget>[
          // const SizedBox(height: 10.0,),
          Container(
            color: Colors.white,
            height: 43.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 32.0,
                    padding: const EdgeInsets.only(left:8.0,right: 16.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorsUtil.bgColor,
                      borderRadius: BorderRadius.circular(19.0),
                    ),
                    child: TextField(
                      controller: _editingController,
                      // focusNode: _contentFocusNode,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(20) //限制长度
                      ],
                      onChanged: (value) => {
                        setState(() {
                          keywords = value;
                        })
                      },
                      onEditingComplete: () {},
                      style: GSYConstant.textStyle(color: '#666666'),
                      cursorColor: ColorsUtil.hexStringColor('#666666'),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIconConstraints: const BoxConstraints(),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 31.0
                        ),
                        isCollapsed: true,
                        prefixIcon: SvgUtil.svg('search.svg'),
                        suffixIcon: keywords.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _editingController.clear();
                                  setState(() {
                                    keywords = '';
                                  });
                                },
                                child: SvgUtil.svg('delete.svg'))
                            : const SizedBox.shrink(),
                        hintStyle: GSYConstant.textStyle(color: '#888888'),
                        hintText: '搜索ICD名称、拼音码',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(16.0),
                ),
                TextButton(
                    onPressed: () {
                      _editingController.clear();
                      setState(() {
                        keywords = '';
                      });
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      '取消',
                      style: GSYConstant.textStyle(color: '#333333'),
                    ))
              ],
            ),
          )
        ]));
  }
}
