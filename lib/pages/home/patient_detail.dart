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
import '../../utils/desensitization_utils.dart';
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
  String mobileStr='';
  String cardnoStr='';
  int patientId=0;
  String consultSum='';
  int _page = 1; //加载的页数
  bool isMore = true; //是否正在加载数
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  List list=[];
  TextEditingController _textEditingController = TextEditingController();
  _PatientDetailState(this._dataMap);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mobileStr = DesensitizationUtil.desensitizationMobile(_dataMap['mobile']);
    cardnoStr = DesensitizationUtil.desensitizationMobile(_dataMap['cardno']);
    patientId = int.parse(_dataMap['patientId']);
    print('patientId===='+patientId.toString());
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
//        _getMore();
      }
    });
    setState(() {});
  }

  Future getData() async {
    var request = HttpRequest.getInstance();
    String url = Api.getPatientDetailApi + '?&patientId=$patientId';
    var res = await request.get(Api.getPatientDetailApi + '?&patientId=$patientId', {});
    if (res['code'] == 200) {
      setState(() {
        list = res['data']['consultList'];
        consultSum = res['data']['consultSum'].toString();
        print("List======="+list.toString());
      });
    } else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<void> _onRefresh() async {
    setState(() {
      _page = 1;
    });
    getData();
  }

  Widget _renderRow(BuildContext context, int index) {
    var item = list[index];
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 10.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          children: <Widget>[
            Container(
              height: 22,
              margin: const EdgeInsets.only(top: 10.0,left: 21.0),
              child: Text('问诊类型',style: GSYConstant.textStyle(color: '#333333',fontSize: 16.0)),
            ),
            const SizedBox(
              height: 9.0,
            ),
            Divider(
              height: 1,
              color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
            ),
            Container(
              height: 42.0,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16.0,right: 16.0),
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                  child:
                  Text(
                    item['createTime'],
                      style: GSYConstant.textStyle(color: '#666666'),
                    ),
                  ),
                ]
            ),),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '患者详情',
        isBack: true,
      ),
      body:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 22,
              margin: const EdgeInsets.only(top: 10.0,left: 21.0),
              child: Text('就诊人',style: GSYConstant.textStyle(color: '#333333',fontSize: 16.0)),
            ),
            Container(
              height: 71,
              margin: const EdgeInsets.only(top: 5.0,left: 0.0),
              child: ListTile(
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
                subtitle: Text(mobileStr+'   '+cardnoStr,style:GSYConstant.textStyle(color: '#666666')),
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
            Container(
                height: 42.0,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.grey),
                padding: const EdgeInsets.only(left: 21.0),
                alignment: Alignment.centerLeft,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child:
                      Text(
                        '最近诊断   '+_dataMap['diagnosis'],
                        style: GSYConstant.textStyle(color: '#666666'),
                      ),
                    ),
                  ],
                ),

            ),
            Container(
                height: 42.0,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.grey),
                padding: const EdgeInsets.only(left: 21.0),
                alignment: Alignment.centerLeft,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child:
                      Text(
                        '所属地区   '+_dataMap['province']+_dataMap['city']+_dataMap['district'],
                        style: GSYConstant.textStyle(color: '#666666'),
                      ),
                    ),
                  ],
                ),
            ),
            GestureDetector(
              onTap: () async{
                var request = HttpRequest.getInstance();
                var res = await request.get(Api.getPatientIdApi+'?cardNo=${_dataMap['cardno']}', {});
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
            ),
            Container(
              height: 22,
              margin: const EdgeInsets.only(top: 10.0,left: 21.0),
              child:
                Column(
                  children: <Widget>[
                    RichText(
                      text: const TextSpan(
                        text: '就诊记录  ',
                        style: TextStyle(color: Color(0xff333333),fontSize: 16.0),
                        children: <TextSpan>[
                          TextSpan( text: '共'),
                          TextSpan(text:'  ' ,style: TextStyle(color: Color(0xffF54033))
                            ),
                          TextSpan(text:'条'),
                        ],
                      ),
                    ),
                  ],
                ),
            ),
            Container(
              child:RefreshIndicator(
                displacement: 10.0,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: _renderRow,
                  itemCount: list.length,
                  controller: _scrollController,
                ),
              ),
            )
          ],
        ),
    );
  }
}
