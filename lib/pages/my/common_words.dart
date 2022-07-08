import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/my/add_common_words.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../common/style/gsy_style.dart';
import '../../http/api.dart';
import '../../model/common_words_modal.dart';
import '../../widget/custom_safeArea_button.dart';

class CommonWords extends StatefulWidget {
  String doctorId;

  CommonWords({Key? key, required this.doctorId}) : super(key: key);

  @override
  _CommonWordsState createState() => _CommonWordsState(this.doctorId);
}

class _CommonWordsState extends State<CommonWords> {
  String doctorId;

  _CommonWordsState(this.doctorId);

  List<Data> commonWordsList = [];

  @override
  void initState() {
    super.initState();
    getCommonWordsList();
  }

  getCommonWordsList() async {
    var response = await HttpRequest.getInstance()
        .get(Api.getCommonWordsTemplateApi + '?doctorId=$doctorId', {});
    var res = CommonWordsModal.fromJson(response);
    if (res.code == 200) {
      commonWordsList = res.data!;
      setState(() {});
    }
  }

  Widget _renderRow(BuildContext context, int index) {
    var item = commonWordsList[index];
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            CustomSlidableAction(
              // An action can be bigger than the others.
              // flex: 2,
              onPressed: (BuildContext context) async {
                var res = await HttpRequest.getInstance()
                    .post(Api.delTemplateApi, {'id': item.id});
                if (res['code'] == 200) {
                  getCommonWordsList();
                } else {
                  ToastUtil.showToast(msg: res['msg']);
                }
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              // icon:Icons.delete,
              // label: '删除',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.delete),
                  Text('删除',
                      style: TextStyle(fontSize: ScreenUtil().setSp(13.0))),
                ],
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context)=>AddCommonWords(doctorId: doctorId,id:item.id!,remark: item.remark!,))).then((value) => getCommonWordsList());
          },
          child: Container(
            height: 44.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(
                        color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                        width: 1.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  item.remark!,
                  style:
                      GSYConstant.textStyle(fontSize: 14.0, color: '#333333'),
                ),
                SvgUtil.svg('forward_arrow.svg')
              ],
            ),
          ),
        ));
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
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: commonWordsList.isNotEmpty,
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
                          commonWordsList.length.toString(),
                          style: GSYConstant.textStyle(
                              fontSize: 15.0, color: '#f34c35'),
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
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding:EdgeInsets.zero,
                    itemCount: commonWordsList.length,
                    itemBuilder: _renderRow),
                Visibility(
                    visible: commonWordsList.isNotEmpty,
                    child: Container(
                      height: 40.0,
                      // decoration: BoxDecoration(
                      //     color: Colors.white
                      // ),
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '*',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#FE5A6B'),
                          ),
                          Text(
                            '操作提示：左滑删除常用语',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#666666'),
                          )
                        ],
                      ),
                    )),
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
                    '添加常用语',
                    style: GSYConstant.textStyle(fontSize: 16.0),
                  )
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCommonWords(
                              doctorId: doctorId,
                               id:'',
                            ))).then((value) => getCommonWordsList());
              })
        ],
      ),
    );
  }
}
