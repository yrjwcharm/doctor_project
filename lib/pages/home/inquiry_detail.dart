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
//    print("--------mobile"+_dataMap['mobile'].toString());
    print("--------cardNo"+_dataMap['cardNo'].toString());
    mobileStr = "13313131313";
//    mobileStr = DesensitizationUtil.desensitizationMobile(_dataMap['mobile']);
    cardnoStr = DesensitizationUtil.desensitizationMobile(_dataMap['cardNo']);
    patientId = int.parse(_dataMap['patientId']);
//    getData();
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        print('滑动到了最底部');
//        _getMore();
//      }
//    });
//    setState(() {});
  }

//  Future getData() async {
//    var request = HttpRequest.getInstance();
//    String url = Api.getPatientDetailApi + '?&patientId=$patientId';
//    var res = await request.get(Api.getPatientDetailApi + '?&patientId=$patientId', {});
//    if (res['code'] == 200) {
//      setState(() {
//        list = res['data']['consultList'];
//        consultSum = res['data']['consultSum'].toString();
//
//        print("List======="+list.toString());
//      });
//    } else {
//      ToastUtil.showToast(msg: res['msg']);
//    }
//  }

//  /**
//   * 下拉刷新方法,为list重新赋值
//   */
//  Future<void> _onRefresh() async {
//    setState(() {
//      _page = 1;
//    });
//    getData();
//  }

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
                    '诊断        '+_dataMap['diseaseDesc'],
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
//                    '所属地区   '+_dataMap['province']+_dataMap['city']+_dataMap['district'],
                  '所属地区   云南省玉溪市通海县备份',
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
                    text: "问诊状态    ",
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
                    text: "问诊类型    ",
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
                    text: "病情描述    ",
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
              ToastUtil.showToast(msg: '点击了上传图片');
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
                    '上传图片',
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
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "订单状态    ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: "已完成",
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
                    text: "实际支付    ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: _dataMap['cost'],
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
                  '订单编号    3556432456112',
                  style: GSYConstant.textStyle(color: '#666666'),
                ),
                Text("复制",style: GSYConstant.textStyle(color: '#FF3131'),),
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
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "创建时间    ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: "2022-03-23 20:00",
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
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "支付时间    ",
                    style: TextStyle(fontSize: 14.0, color: Color.fromRGBO(102, 102, 102, 1),),
                  ),
                  TextSpan(
                    text: "2022-03-23 20:00",
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
            padding: const EdgeInsets.only(bottom: 0.0),
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
                  CustomOutlineButton(
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
                      ToastUtil.showToast(msg: '点击了处方查看');
//                      Navigator.push(context, MaterialPageRoute(builder: (context)=> RecipeDetail(rpDetailItem: {..._dataMap,}, diagnosis: item['diagnosis'],prescriptionId:item['recipeId'],registeredId:item['registerId'])));
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomOutlineButton(
                    title: '查看聊天记录',
                    textStyle: GSYConstant.textStyle(
                        fontSize: 13.0, color: '#666666'),
                    padding:(
                        const EdgeInsets.symmetric(horizontal: 13.0)
                    ),
                    height: 30.0,
                    borderRadius: BorderRadius.circular(14.0),
                    borderColor: ColorsUtil.hexStringColor('#09BB8F'),
                    onPressed: () async {
                      ToastUtil.showToast(msg: '点击了查看聊天记录');
//                      Navigator.push(context,MaterialPageRoute(builder: (context) => WriteCase(registeredId:item['registerId'],userInfoMap: _dataMap,)));
                    },
                  ),
                ]
            ),
          ),

        ],
      ),
    );
  }
}
