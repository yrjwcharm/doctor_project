import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/video_topic.dart';
import 'package:doctor_project/pages/home/webviewVC.dart';
import 'package:doctor_project/pages/photoview_page.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/desensitization_utils.dart';
import 'package:doctor_project/utils/event_bus_util.dart';
import 'package:doctor_project/utils/image_network_catch.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:doctor_project/widget/custom_webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../http/http_request.dart';
import '../../config/zego_config.dart';
import '../../http/api.dart';
import 'chat_room.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class PatientDetail extends StatefulWidget {
  PatientDetail({Key? key, required this.dataMap}) : super(key: key);
  Map dataMap ;

  @override
  _PatientDetailState createState() => _PatientDetailState(this.dataMap);
}

class _PatientDetailState extends State<PatientDetail> {
  Map _dataMap ;
  String refuseReason='';
  TextEditingController _textEditingController = TextEditingController();
  _PatientDetailState(this._dataMap);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('$_dataMap');
    // {orderType: 0, sex_dictText: 未知字典, sex: 10, photo: , type_dictText: 图文问诊, type: 0, diseaseTime_dictText: 未知字典, orderType_dictText: 复诊拿药, times: 61966, diseaseTime: , diseaseData: [], name: 病人姓名, id: 432413381564170241, age: 22, diseaseDesc: }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '患者详情',
        isBack: true,

      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 73,
                      child: ListTile(
                        onTap: () {},
                        title: Row(
                          children: <Widget>[
                            Text(
                              _dataMap['name'],
                              style: GSYConstant.textStyle(
                                  fontFamily: 'Medium',
                                  fontWeight: FontWeight.w500,
                                  color: '#333333'),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              _dataMap['sex_dictText'],
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                            Text(
                              '｜',
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                            Text(
                              _dataMap['age'].toString() + '岁',
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                          ],
                        ),
                        tileColor: Colors.white,
                        subtitle: Text(DesensitizationUtil.desensitizationMobile(
                            _dataMap['phone'])),
                        // leading:_map['photo'].isEmpty?Image.network(_map['photo']):Image.asset('assets/images/home/avatar.png'),
                        leading: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0)),
                            height: 40.0,
                            width: 40.0,
                            child: _dataMap['photo'] != null
                                ? Image.network(_dataMap['photo'] ?? '')
                                : _dataMap['sex_dictText'] == '男'
                                ? Image.asset('assets/images/boy.png')
                                : Image.asset('assets/images/girl.png')),
                        // trailing: SvgUtil.svg('arrow_right.svg')
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        '问诊类型',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                      trailing: Text(
                        _dataMap['type_dictText'],
                        style: GSYConstant.textStyle(color: '#666666'),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      // height: 266,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 17.0, bottom: 20.0),
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '咨询内容',
                            style: GSYConstant.textStyle(
                                fontWeight: FontWeight.w500,
                                color: '#333333',
                                fontFamily: 'Medium'),
                          ),
                          const SizedBox(
                            height: 14.0,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 84.0,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '患者名字',
                                  style: GSYConstant.textStyle(color: '#333333'),
                                ),
                              ),
                              Text(
                                _dataMap['name'],
                                style: GSYConstant.textStyle(color: '#666666'),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 84.0,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '患病时间：',
                                  style: GSYConstant.textStyle(color: '#333333'),
                                ),
                              ),
                              Text(
                                _dataMap['diseaseTime_dictText'] ?? '',
                                style: GSYConstant.textStyle(color: '#666666'),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 84.0,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '是否就诊过：',
                                  style: GSYConstant.textStyle(color: '#333333'),
                                ),
                              ),
                              Text(
                                _dataMap['isRepeat_dictText'],
                                style: GSYConstant.textStyle(color: '#666666'),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 84.0,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '病情描述：',
                                  style: GSYConstant.textStyle(color: '#333333'),
                                ),
                              ),
                              Flexible(
                                  child: Text(
                                    _dataMap['diseaseDesc'],
                                    style: GSYConstant.textStyle(color: '#666666'),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 84.0,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '上传资料：',
                                  style: GSYConstant.textStyle(color: '#333333'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async{
                        var request = HttpRequest.getInstance();
                        var res = await request.get(Api.getPatientIdApi+'?cardNo=${_dataMap['cardNo']}', {});
                        if(res['code']==200){
                          if(res['data'].isNotEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GSYWebView(
                                          Api.view360Api + '??paId=${res['data']}',
                                        )));
                          }else{
                            ToastUtil.showToast(msg: '暂不支持查看360视图');
                          }
                        }

                      },
                      child: Container(
                        height: 40.0,
                        margin: const EdgeInsets.only(top: 10.0),
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                        ),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '患者360视图',
                              style: GSYConstant.textStyle(color: '#333333'),
                            ),
                            SvgUtil.svg('arrow_right.svg')
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
