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
import 'package:doctor_project/pages/my/write_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:doctor_project/pages/my/rp_detail.dart';
import 'package:flutter/material.dart';
import '../../http/http_request.dart';
import '../../config/zego_config.dart';
import '../../http/api.dart';
import 'chat_room.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class InquiryDetail extends StatefulWidget {
  InquiryDetail({Key? key, required this.dataMap}) : super(key: key);
  Map dataMap ;

  @override
  _InquiryDetailState createState() => _InquiryDetailState(this.dataMap);
}

class _InquiryDetailState extends State<InquiryDetail> {
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
  _InquiryDetailState(this._dataMap);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mobileStr = DesensitizationUtil.desensitizationMobile(_dataMap['mobile']);
    cardnoStr = DesensitizationUtil.desensitizationMobile(_dataMap['cardNo']);
    patientId = int.parse(_dataMap['patientId']);
//    print('_dataMap===='+_dataMap.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '问诊详情',
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
                    _dataMap['sex'],
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
                      : _dataMap['sex'] == '男'
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
        ],
      ),
    );
  }
}
