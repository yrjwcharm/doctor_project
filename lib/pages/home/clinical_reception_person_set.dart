import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClinicReceptionPersonSet extends StatefulWidget {
  const ClinicReceptionPersonSet({Key? key}) : super(key: key);

  @override
  _ClinicReceptionPersonSetState createState() => _ClinicReceptionPersonSetState();
}

class _ClinicReceptionPersonSetState extends State<ClinicReceptionPersonSet> {
  List list = [];

  @override
  void initState() {
    super.initState();
    list.add({'text': '10'});
    list.add({'text': '20'});
    list.add({'text': '30'});
    list.add({'text': '40'});
    list.add({'text': '50'});
    list.add({'text': '自定义'});
  }

  void showBottomSheet() {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
        builder: (BuildContext context) {
          //构建弹框中的内容
          return buildBottomSheetWidget(context);
        },
        backgroundColor: Colors.transparent, //重要
        context: context);
  }

  Widget buildBottomSheetWidget(BuildContext context) {
    return Container(
      height: 229,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      child: Column(
        children: [
          Container(
            height: 73,
            alignment: Alignment.center,
            child: Text(
              '自定义人数',
              style: GSYConstant.textStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: '#333333'),
            ),
          ),
          Container(
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: ColorsUtil.hexStringColor('#f9f9f9'),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: CustomInputWidget(
                hintText: '请输入自定义人数，1～100',
                onChanged: (String value) {},
              )),
          const SizedBox(
            height: 24.0,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: ColorsUtil.hexStringColor('#f9f9f9'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            '取消',
                            style: GSYConstant.textStyle(
                                fontSize: 16.0, color: '#666660'),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                      child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: ColorsUtil.hexStringColor('#f9f9f9'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child: Text(
                                '确定',
                                style: GSYConstant.textStyle(
                                    fontSize: 16.0, color: '#666660'),
                              ))))
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.hexStringColor('#f9f9f9'),
      body: Column(
        children: [
          CustomAppBar(
            '接诊人数',
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
                    '选择人数',
                    style: GSYConstant.textStyle(color: '#333333'),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0, //主轴上子控件的间距
                  runSpacing: 16.0, //交叉轴上子控件之间的间距
                  children: list
                      .asMap()
                      .keys
                      .map((index) => SizedBox(
                            width: 80,
                            height: 33,
                            child: OutlinedButton(
                                onPressed: () {
                                  if (index == 5) {
                                    showBottomSheet();
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  side: BorderSide(
                                      width: 1,
                                      color:
                                          ColorsUtil.hexStringColor('#cccccc')),
                                ),
                                child: Text(
                                  list[index]['text'],
                                  style:
                                      GSYConstant.textStyle(color: '#333333'),
                                )),
                          ))
                      .toList(),
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.bottomLeft,
            child: SafeAreaButton(
              onPressed: () {},
              text: '确定',
            ),
          ))
        ],
      ),
    );
  }
}
