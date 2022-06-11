import 'package:doctor_project/pages/my/add_common_drug.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_safeArea_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/style/gsy_style.dart';
import '../../utils/svg_util.dart';

class CommonDrug extends StatefulWidget {
  const CommonDrug({Key? key}) : super(key: key);

  @override
  _CommonDrugState createState() => _CommonDrugState();
}

Widget _renderRow(BuildContext context, int index) {
  return Container(
    padding: const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 13.0),
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
                color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3)))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              '[阿莫灵]阿莫西林胶囊 0.25*24粒/盒',
              style: GSYConstant.textStyle(color: '#333333'),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: ColorsUtil.hexStringColor('#06b48d')),
              padding: const EdgeInsets.only(left: 8.0, right: 7.0),
              child: Text(
                '内科',
                style: GSYConstant.textStyle(fontSize: 13.0),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 3.0,
        ),
        Text(
          '口服：一次3粒，4次/天，2盒',
          style: GSYConstant.textStyle(fontSize: 13.0, color: '#888888'),
        )
      ],
    ),
  );
}

class _CommonDrugState extends State<CommonDrug> {
  List commonDrugList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('常用药品'),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: commonDrugList.isEmpty,
                  child: Container(
                    height: 43.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '共',
                          style: GSYConstant.textStyle(
                              fontSize: 15.0, color: '#666666'),
                        ),
                        const SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          commonDrugList.length.toString(),
                          style: GSYConstant.textStyle(
                              fontSize: 15.0, color: '#f34c35'),
                        ),
                        const SizedBox(
                          width: 3.0,
                        ),
                        Text('条常用药品',
                            style: GSYConstant.textStyle(
                                fontSize: 15.0, color: '#666666')),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: commonDrugList.isEmpty,
                    child: Container(
                      margin:
                          EdgeInsets.only(top: ScreenUtil().setHeight(147.0)),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SvgUtil.svg('no_data.svg'),
                          const SizedBox(
                            height: 14.0,
                          ),
                          Text(
                            '暂无药品～',
                            style: GSYConstant.textStyle(
                                fontSize: 15.0, color: '#666666'),
                          )
                        ],
                      ),
                    )),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: _renderRow),
                Visibility(
                    visible: commonDrugList.isNotEmpty,
                    child: Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      height: 40.0,
                      child: Row(
                        children: <Widget>[
                          Text(
                            '*',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#fe5a6b'),
                          ),
                          Text(
                            '操作提示：左滑删除常用药品',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#666666'),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          )),
          CustomSafeAreaButton(
              margin: const EdgeInsets.only(bottom: 16.0),
              custom: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SvgUtil.svg('increment.svg'),
                  const SizedBox(
                    width: 9.0,
                  ),
                  Text(
                    '添加常用药',
                    style: GSYConstant.textStyle(fontSize: 16.0),
                  )
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCommonDrug(
                              registeredId: '',
                            )));
              })
        ],
      ),
    );
  }
}
