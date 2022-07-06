import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/video_topic.dart';
import 'package:doctor_project/pages/home/webviewVC.dart';
import 'package:doctor_project/pages/home/prescription_list.dart';
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
import 'package:flutter/services.dart';
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
  var item;
  String refuseReason='';
  String mobileStr='';
  String cardnoStr='';
  String consultSum='';
  List diagnosisList = [];
  String diagnosis = '';
  String districtName = '';//区
  String cityName = '';//市
  String provinceName = '';//省
  String createTime = '';
  String payTime = '';
  String orderFee = '';
  String orderStatus = '';
  String orderId = '';
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
    mobileStr = "13313131313";
    mobileStr = DesensitizationUtil.desensitizationMobile(_dataMap['phone']);
    cardnoStr = DesensitizationUtil.desensitizationMobile(_dataMap['cardNo']);
    orderId = _dataMap['orderId'];
    getData();

  }

  Future getData() async {
    var request = HttpRequest.getInstance();
    print("--------orderId"+_dataMap['orderId']);
    var res = await request.get(Api.getRegisterOrderInfoDetail +'?orderId=$orderId',{});

    print("res ====="+res.toString());
    if (res['code'] == 200) {
      setState(() {});
      item = res['data'];
      cityName = res['data']['cityName']??'';
      districtName = res['data']['districtName']??'';
      provinceName = res['data']['provinceName']??'';

      List<String>  diagnosisList = [];
      (_dataMap['diagnoses']??[]).forEach((element) {
          diagnosisList.add(element['diagnosisName']);
      });
      diagnosisList.forEach((f){
        if(diagnosis == ''){
          diagnosis = "$f";
        }else {
          diagnosis = "$diagnosis"",""$f";
        }
      });
      createTime = res['data']['createTime'].toString();
      payTime = res['data']['payTime'].toString();
      orderFee = res['data']['orderFee'].toString();
      orderStatus = res['data']['orderStatus']==0?"待支付":"已支付";

    } else {
      ToastUtil.showToast(msg: res['msg']);
    }

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
                    _dataMap['sex'].toString()=="1"?"男":"女",
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
          Divider(
            height: 0.5,
            color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
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
                    '诊断             '+diagnosis,
                    style: GSYConstant.textStyle(color: '#666666'),
                  ),
                ),
              ],
            ),

          ),
          Divider(
            height: 0.5,
            color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
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
                    '所属地区       '+provinceName+cityName+districtName,
                    style: GSYConstant.textStyle(color: '#666666'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 42.0,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.grey),
            padding: const EdgeInsets.only(left: 21.0),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "问诊状态         ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: _dataMap['status_dictText'],
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(51, 51, 51, 1),),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 42.0,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.grey),
            padding: const EdgeInsets.only(left: 21.0),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "问诊类型         ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: _dataMap['type_dictText'],
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(51, 51, 51, 1),),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 42.0,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.grey),
            padding: const EdgeInsets.only(left: 21.0),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "病情描述         ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: _dataMap['diseaseDesc'],
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(51, 51, 51, 1),),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 0.5,
            color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
          ),
          GestureDetector(
            onTap: () async{
//              ToastUtil.showToast(msg: '点击了上传图片');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PhotoViewPage(_dataMap['diseaseData'].toString()))
              );
            },
            child: Container(
              height: 40.0,
              padding: const EdgeInsets.only(
                left: 21.0,
                right: 16.0,
              ),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '查看图片',
                    style: GSYConstant.textStyle(color: '#666666'),
                  ),
                  SvgUtil.svg('arrow_right.svg')
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 42.0,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 21.0),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "订单状态         ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: orderStatus,
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(51, 51, 51, 1),),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 42.0,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 21.0),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "实际支付         ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: orderFee.toString(),
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(51, 51, 51, 1),),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 40.0,
            padding: const EdgeInsets.only(
              left: 21.0,
              right: 16.0,
            ),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '订单编号        '+_dataMap['orderId'].toString(),
                  style: GSYConstant.textStyle(color: '#666666'),
                ),
                GestureDetector(
                  onTap: () async{
                    Clipboard.setData(ClipboardData(text:_dataMap['orderId'].toString()));
                    ToastUtil.showToast(msg: '已复制到剪贴板');
                  },
                  child: Container(
                    height: 40.0,
                    padding: const EdgeInsets.only(
                      right: 16.0,
                    ),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '复制',
                          style: GSYConstant.textStyle(color: '#FF3131'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 42.0,
            width: double.infinity,
//            decoration: const BoxDecoration(color: Colors.grey),
            padding: const EdgeInsets.only(left: 21.0),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "创建时间         ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: createTime,
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(51, 51, 51, 1),),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 42.0,
            width: double.infinity,
//            decoration: const BoxDecoration(color: Colors.grey),
            padding: const EdgeInsets.only(left: 21.0),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: RichText(
              text:TextSpan(
                children: [
                  const TextSpan(
                    text: "支付时间         ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: payTime,
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(51, 51, 51, 1),),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 65.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 0.0,right: 0.0,left: 0.0),
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:
                    Text(
                      '',
                      style: GSYConstant.textStyle(color: '#666666'),
                    ),
                  ),
                  _dataMap['status_dictText']=='已接诊'?CustomOutlineButton(
                    title: '处方查看',
                    textStyle: GSYConstant.textStyle(
                        fontSize: 13.0, color: '#666666'),
                    padding:(
                        const EdgeInsets.symmetric(horizontal: 13.0)
                    ),
                    height: 30.0,
                    borderRadius: BorderRadius.circular(14.0),
                    borderColor: ColorsUtil.hexStringColor('#09BB8F'),
                    onPressed: () async {
//                      ToastUtil.showToast(msg: '点击了处方查看');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> PrescriptionList(dataMap: item,prescriptionItem: _dataMap)));
                    },
                  ):Container(),
//                  SizedBox(
//                    width: 10,
//                  ),
//                  CustomOutlineButton(
//                    title: '查看聊天记录',
//                    textStyle: GSYConstant.textStyle(
//                        fontSize: 13.0, color: '#666666'),
//                    padding:(
//                        const EdgeInsets.symmetric(horizontal: 13.0)
//                    ),
//                    height: 30.0,
//                    borderRadius: BorderRadius.circular(14.0),
//                    borderColor: ColorsUtil.hexStringColor('#09BB8F'),
//                    onPressed: () async {
//                      ToastUtil.showToast(msg: '点击了查看聊天记录');
////                      Navigator.push(context,MaterialPageRoute(builder: (context) => WriteCase(registeredId:item['registerId'],userInfoMap: _dataMap,)));
//                    },
//                  ),
                ]
            ),
          ),

        ],
      ),
    );
  }
}
