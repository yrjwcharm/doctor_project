import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:creator/creator.dart';
import 'package:doctor_project/common/creator/logic.dart';
import 'package:doctor_project/common/local/local_storage.dart';
import 'package:doctor_project/pages/home/chat_room.dart';
import 'package:doctor_project/pages/home/make_prescription.dart';
import 'package:doctor_project/pages/home/use_drug_info.dart';
import 'package:doctor_project/pages/home/video_topic.dart';
import 'package:doctor_project/utils/image_network_catch.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/style/gsy_style.dart';
import '../../config/zego_config.dart';
import '../../http/api.dart';
import '../../utils/colors_utils.dart';
import '../../utils/event_bus_util.dart';
import '../../utils/platform_utils.dart';
import '../home/notice_detail.dart';
import '../home/open_service.dart';
import '../home/order_detail.dart';
import '../home/patient-consult.dart';
import '../../http/http_request.dart';
import 'package:marquee/marquee.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool tab1Active = true;
  bool tab2Active = false;
  List<dynamic> list = [];
  int status = 1;
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数
  bool isMore = true; //是否正在加载数据
  int receiving = 0;
  int waitReceive = 0;
  Map doctorInfoMap = new Map();
  StreamSubscription? stream;
  String doctorName = '';
  String drPhotoUrl = '';
  String deptName = '';
  String orgName = '';
  String protitle = '';
  String receiveNum = '';
  String waitReceiveNum = '';
  String videoRegisterNum = '';
  List noticeList = [];
  String noticeStr = '';
  String noticeContent = '';
  String noticeTime = '';
  bool _useRtlText = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      getNoticeByPlatform();
      getNet_doctorInfo();
      getData();
      getCount();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        _getMore();
      }
    });
    stream = EventBusUtil.getInstance().on<Map>().listen((event) {
      getData();
      getCount();
    });
  }
  getNoticeByPlatform() async {
    HttpRequest request = HttpRequest.getInstance();
    var res = await request.get(Api.getNoticeByPlatform+'?orgId=1', {});
    if(res['code']==200){
      noticeList = res['data'];
      noticeStr = noticeList[2]['title'];
      noticeContent = noticeList[2]['content'];
      noticeTime = '2022-06-13';
    }
    print("noticeStr------" + noticeStr.toString());
    print("noticeContent------" + noticeContent.toString());


  }

  //获取医生信息
  getNet_doctorInfo() async {
    HttpRequest request = HttpRequest.getInstance();
    var res = await request.get(Api.getDoctorInfoUrl, {});
    print("getNet_doctorInfo------" + res.toString());

    if (res['code'] == 200) {
      context.ref.set(docIdCreator, res['data']['userId'].toString());
      // receiveNum: 1, userId: 10017, orgId: 1, waitReceiveNum: 0, videoRegisterNum: 0
      doctorInfoMap = res['data'];
      drPhotoUrl = res['data']['photoUrl'];
      doctorName = res['data']['realName'];
      orgName = res['data']['orgName'] ?? '';
      deptName = res['data']['deptName'] ?? '';
      protitle = res['data']['protitle_dictText'] ?? '';
      receiveNum = res['data']['receiveNum'].toString();
      waitReceiveNum = res['data']['waitReceiveNum'].toString();
      videoRegisterNum = res['data']['videoRegisterNum'].toString();
      setState(() {});
    }
  }

  getCount() async {
    var request = HttpRequest.getInstance();
    var res = await request.get(Api.getReceiveConsultCount, {'type': ''});
    if (res['code'] == 200) {
      setState(() {
        receiving = res['data']['receiving'];
        waitReceive = res['data']['waitReceive'];
      });
    }
  }

  /**
   * 初始化list数据 加延时模仿网络请求
   */
  Future getData() async {
    var request = HttpRequest.getInstance();
    var res = await request.get(
        Api.getReceiveConsultList + '?status=$status&page=$_page&size=10', {});
    if (res['code'] == 200) {
      setState(() {
        list = res['data']['records'];
        isMore = true;
      });
    } else {
      // ToastUtil.showToast(msg: res['msg']);
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
    getCount();
  }

  Future _getMore() async {
    if (isMore) {
      _page += 1;
      var request = HttpRequest.getInstance();
      var res = await request.get(
          Api.getReceiveConsultList + '?status=$status&page=$_page&size=10',
          {});
      if (res['code'] == 200) {
        var total = res['data']['total'];
        var size = res['data']['size'];
        int totalPage = (total / size).ceil();
        if (_page <= totalPage) {
          setState(() {
            list.addAll(res['data']['records']);
            isMore = true;
            _page;
          });
        } else {
          setState(() {
            isMore = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream!.cancel();
      stream = null;
    }
    _scrollController.dispose();
  }

  // {orderType: 0, sex_dictText: 未知字典, sex: 10, photo: , type_dictText: 图文问诊, type: 0, diseaseTime_dictText: 未知字典, orderType_dictText: 复诊拿药, times: 56299, diseaseTime: , diseaseData: [], name: 病人姓名, id: 432413381564170241, age: 22, diseaseDesc: }
  Widget _renderRow(BuildContext context, int index) {
    // int status =1;
    var item = list[index];
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetail(
                      map: list[index],
                      docName: doctorInfoMap['realName'] ?? '')));
        },
        child: Container(
            margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              children: [
                ListTile(
                  onTap: null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  subtitle: Text(
                    item['type_dictText'] ?? '',
                    style:
                        GSYConstant.textStyle(fontSize: 13.0, color: '#666666'),
                  ),
                  title: Row(mainAxisSize: MainAxisSize.max, children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            item['name'] ?? '',
                            style: GSYConstant.textStyle(
                                color: '#333333', fontSize: 15.0),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            item['sex_dictText'] ?? '',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#666666'),
                          ),
                          Text(
                            '｜',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#666666'),
                          ),
                          Text(
                            item['age'].toString() + '岁',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#666666'),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgUtil.svg(item['type'] == '2'
                            ? 'video_interrogation.svg'
                            : 'photo.svg'),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          status == 1 ? '接诊中' : '待接诊',
                          style: GSYConstant.textStyle(color: '#F94C26'),
                        )
                      ],
                    )
                  ]),
                  leading: Container(
                    width: 40.0,
                    height: 40.0,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: item['photo'] != null
                        ? Image.network(
                            item['photo'] ?? '',
                            fit: BoxFit.cover,
                          )
                        : item['sex_dictText'] == '男'
                            ? Image.asset('assets/images/boy.png')
                            : Image.asset('assets/images/girl.png'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 7.0),
                  child: Row(children: [
                    Text(
                      '病情描述：',
                      style: GSYConstant.textStyle(
                          fontFamily: 'Medium',
                          fontSize: 13.0,
                          color: '#333333'),
                    ),
                    Flexible(
                        child: Text(
                      item['diseaseDesc'] ?? '',
                      style: GSYConstant.textStyle(
                          fontSize: 13.0, color: '#666666'),
                    ))
                  ]),
                ),
                const SizedBox(
                  height: 9.0,
                ),
                Divider(
                  height: 1,
                  color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                ),
                Container(
                  height: 47,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        item['times'] ?? '',
                        style: GSYConstant.textStyle(color: '#888888'),
                      )),
                      status == 1
                          ? CustomOutlineButton(
                              title: '结束问诊',
                              textStyle: GSYConstant.textStyle(
                                  fontSize: 13.0, color: '#666666'),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13.0),
                              height: 28.0,
                              onPressed: () async {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) => WillPopScope(
                                          onWillPop: () async {
                                            return Future.value(false);
                                          },
                                          child: AlertDialog(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 45.0),
                                            contentTextStyle: TextStyle(
                                                fontSize: 16.0,
                                                color:
                                                    ColorsUtil.hexStringColor(
                                                        '#333333')),
                                            // title: Text("提示信息"),
                                            content: const Text(
                                              "请确认是否结束问诊？",
                                              textAlign: TextAlign.center,
                                            ),
                                            buttonPadding: EdgeInsets.zero,
                                            actions: [
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            height: 40.0,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    right: BorderSide(
                                                                        width:
                                                                            0.5,
                                                                        color: ColorsUtil.hexStringColor(
                                                                            '#cccccc',
                                                                            alpha:
                                                                                0.4)),
                                                                    top: BorderSide(
                                                                        width:
                                                                            1.0,
                                                                        color: ColorsUtil.hexStringColor(
                                                                            '#cccccc',
                                                                            alpha:
                                                                                0.4)))),
                                                            child: Text(
                                                              '取消',
                                                              style: GSYConstant
                                                                  .textStyle(
                                                                      fontSize:
                                                                          16.0,
                                                                      color:
                                                                          '#333333'),
                                                            ),
                                                          ))),
                                                  Expanded(
                                                      child: GestureDetector(
                                                    onTap: () async {
                                                      var request = HttpRequest
                                                          .getInstance();
                                                      Map<String, dynamic> map =
                                                          {};
                                                      map['registerId'] =
                                                          item['id'];
                                                      var res =
                                                          await request.post(
                                                              Api.finishTopicApi,
                                                              map);
                                                      if (res['code'] == 200) {
                                                        _page = 1;
                                                        list = [];
                                                        setState(() {});
                                                        getData();
                                                        getCount();
                                                        getNet_doctorInfo();

                                                        Navigator.pop(context);
                                                      } else {
                                                        ToastUtil.showToast(
                                                            msg: res['msg']);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 40.0,
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              left: BorderSide(
                                                                  width: 0.5,
                                                                  color: ColorsUtil
                                                                      .hexStringColor(
                                                                          '#cccccc',
                                                                          alpha:
                                                                              0.4)),
                                                              top: BorderSide(
                                                                  width: 0.5,
                                                                  color: ColorsUtil
                                                                      .hexStringColor(
                                                                          '#cccccc',
                                                                          alpha:
                                                                              0.4)))),
                                                      child: Text(
                                                        '确定',
                                                        style: GSYConstant
                                                            .textStyle(
                                                                fontSize: 16.0,
                                                                color:
                                                                    '#06B48D'),
                                                      ),
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ));
                              },
                              borderRadius: BorderRadius.circular(14.0),
                              borderColor: ColorsUtil.hexStringColor('#06B48D'))
                          : Container(),
                      const SizedBox(
                        width: 10.0,
                      ),
                      SizedBox(
                        // width: 77,
                        height: 28,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ColorsUtil.shallowColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0))),
                          onPressed: () async {
                            // if(status==0){
                            var request = HttpRequest.getInstance();
                            Map<String, dynamic> map = {};
                            map['registerId'] = item['id'];
                            var res = await request.post(
                                Api.getReceiveConsultApi, map);
                            if (res['code'] == 200) {
                              var res1 = await request.post(Api.createRoomApi, {
                                'orderId': item['orderId'],
                                'roomType': item['type'] == '2' ? 1 : 2,
                                'patientId': item['patientId'],
                              });
                              if (res1['code'] == 200) {
                                ZegoConfig.instance.userID =
                                    res1['data']['userId'].toString();
                                ZegoConfig.instance.userName =
                                    res1['data']['userName'];
                                ZegoConfig.instance.roomID =
                                    res1['data']['roomId'];
                                var res2 = await request.get(Api.getToken,
                                    {'roomId': res1['data']['roomId']});
                                if (res2['code'] == 200) {
                                  ZegoConfig.instance.token =
                                      res2['data']['token'];
                                  if (item['type'] == '2') {
                                    // LocalStorage.save('userMap', item);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VideoTopic(
                                                  regId: item['id'],
                                                  docName: doctorInfoMap[
                                                          "realName"] ??
                                                      '',
                                                  userInfoMap: item,
                                                ))).then((value) => {
                                          _page = 1,
                                          list = [],
                                          setState(() {}),
                                          getData(),
                                          getCount()
                                        });
                                  } else {
                                    // LocalStorage.save('userMap', item);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatRoom(
                                                  userInfoMap: item,
                                                ))).then((value) => {
                                          _page = 1,
                                          list = [],
                                          setState(() {}),
                                          getData(),
                                          getCount()
                                        });
                                  }
                                } else {
                                  ToastUtil.showToast(msg: res2['msg']);
                                }
                              } else {
                                ToastUtil.showToast(msg: res1['msg']);
                              }
                            } else {
                              ToastUtil.showToast(msg: res['msg']);
                            }
                          },
                          child: Text(
                            status == 1 ? '继续交流' : '接诊',
                            style: GSYConstant.textStyle(fontSize: 13.0),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ))
    );
  }

  @override
  Widget build(BuildContext context) {
    print('3333,${MediaQuery.of(context).padding.top}');

    Widget buildColumn(String title, String subTitle) {
      return Expanded(
        child: Column(children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Medium',
                  fontWeight: FontWeight.w500,
                  color: ColorsUtil.hexStringColor('#333333'))),
          const SizedBox(height: 1),
          Text(
            subTitle,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ColorsUtil.hexStringColor("#666666"),
                fontFamily: 'PingFangSC-Regular, PingFang SC'),
          )
        ]),
      );
    }

    Widget buildButtonColumn(
        String assetName, String label, GestureTapCallback onTap) {
      Color color = ColorsUtil.hexStringColor('#333333');

      return Expanded(
          child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(assetName),
              fit: BoxFit.cover,
            ),
            Container(
              margin: const EdgeInsets.only(top: 7.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'PingFangSC-Regular, PingFang SC',
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ));
    }

    Widget buildBg = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 184,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/home/rect.png',
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 22,
          left: 16.0,
          right: 16.0,
          child: Container(
            width: MediaQuery.of(context).size.width, // 获取屏幕尺寸,
            padding: const EdgeInsets.only(
                top: 12.0, bottom: 13.0, left: 16.0, right: 16.0),
            // margin:const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Container(
                              height: 43.0,
                              width: 43.0,
                              margin: const EdgeInsets.only(right: 16.0),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21.5)),
                              child: Visibility(
                                  visible: drPhotoUrl.isNotEmpty,
                                  child: Image.network(
                                    drPhotoUrl,
                                    fit: BoxFit.cover,
                                  ))),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    doctorName,
                                    style: GSYConstant.textStyle(
                                        fontSize: 18.0,
                                        color: '#333333',
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Medium'),
                                  ),
                                  const SizedBox(
                                    width: 7.0,
                                  ),
                                  Visibility(
                                      visible: protitle.isNotEmpty,
                                      child: CustomOutlineButton(
                                          height: 18.0,
                                          padding:const EdgeInsets.only(left: 7.0,right:8.0),
                                          // width: 66.0,
                                          textStyle: GSYConstant.textStyle(
                                              fontSize: 13.0, color: '#06B48D'),
                                          title: protitle,
                                          borderRadius:
                                              BorderRadius.circular(9.0),
                                          borderColor:
                                              ColorsUtil.hexStringColor(
                                                  '#06B48D'), onPressed: null,))
                                ],
                              ),
                              const SizedBox(height: 6.0,),
                              Row(
                                children: <Widget>[
                                  Text(
                                    orgName,
                                    style: GSYConstant.textStyle(
                                        fontSize: 13.0,
                                        color: '#999999',
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(width: 8.0,),
                                  Text(
                                    deptName,
                                    style: GSYConstant.textStyle(
                                        fontSize: 13.0,
                                        color: '#999999',
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SvgUtil.svg('scanner.svg')
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            receiveNum,
                            style: GSYConstant.textStyle(
                                fontFamily: 'Medium',
                                fontSize: 15.0,
                                color: '#333333',
                                fontWeight: FontWeight.w500),
                          ),
                          Text('今日已接诊',
                              style: GSYConstant.textStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: '#666666'))
                        ],
                      ),
                    ),
                    SvgUtil.svg('separator_line.svg'),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(waitReceiveNum,
                              style: GSYConstant.textStyle(
                                  fontFamily: 'Medium',
                                  fontSize: 15.0,
                                  color: '#333333',
                                  fontWeight: FontWeight.w500)),
                          Text('今日待接诊',
                              style: GSYConstant.textStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: '#666666'))
                        ],
                      ),
                    ),
                    SvgUtil.svg('separator_line.svg'),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(videoRegisterNum,
                              style: GSYConstant.textStyle(
                                  fontFamily: 'Medium',
                                  fontSize: 15.0,
                                  color: '#333333',
                                  fontWeight: FontWeight.w500)),
                          Text(
                            '视频预约',
                            style: GSYConstant.textStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: '#666666'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
    void _goToHealthHutModular() async {
      const platform = MethodChannel("flutterPrimordialBrige");
      bool result = false;
      try {
        result = await platform.invokeMethod("jumpToCallVideo"); //分析2
      } on PlatformException catch (e) {
        print(e.toString());
      }
    }

    Widget buttonSection = Container(
      margin:  const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 8.0),
      height: 96,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        children: [
          buildButtonColumn('assets/images/home/consult1.png', '患者咨询', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PatientConsult(
                          type: '1',
                          docName: doctorInfoMap['realName'] ?? '',
                        )));
          }),
          buildButtonColumn('assets/images/home/picture1.png', '图文问诊', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PatientConsult(
                        type: '0', docName: doctorInfoMap['realName'] ?? '')));
          }),
          buildButtonColumn('assets/images/home/video1.png', '视频问诊', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PatientConsult(
                        type: '2', docName: doctorInfoMap['realName'] ?? '')));
          }),
        ],
      ),
    );

    // Widget _buildMarquee() {
    //   return Marquee(
    //     key: Key("$_useRtlText"),
    //     text: !_useRtlText
    //         ? 'There once was a boy who told this story about a boy: "'
    //         : 'פעם היה ילד אשר סיפר סיפור על ילד:"',
    //     velocity: 50.0,
    //   );
    // }

    // Widget _buildComplexMarquee() {
    //   return Marquee(
    //     key: Key("$_useRtlText"),
    //     text: !_useRtlText
    //         ? 'Some sample text that takes some space.'
    //         : 'זהו משפט ראשון של הטקסט הארוך. זהו המשפט השני של הטקסט הארוך',
    //     style: TextStyle(fontWeight: FontWeight.bold),
    //     scrollAxis: Axis.horizontal,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     blankSpace: 20,
    //     velocity: 100,
    //     pauseAfterRound: Duration(seconds: 1),
    //     showFadingOnlyWhenScrolling: true,
    //     fadingEdgeStartFraction: 0.1,
    //     fadingEdgeEndFraction: 0.1,
    //     numberOfRounds: 3,
    //     startPadding: 10,
    //     accelerationDuration: Duration(seconds: 1),
    //     accelerationCurve: Curves.linear,
    //     decelerationDuration: Duration(milliseconds: 500),
    //     decelerationCurve: Curves.easeOut,
    //     textDirection: _useRtlText ? TextDirection.rtl : TextDirection.ltr,
    //   );
    // }

    // Widget _wrapWithStuff(Widget child) {
    //   return Padding(
    //     padding: EdgeInsets.all(16),
    //     child: Container(height: 50, color: Colors.white, child: child),
    //   );
    // }
    Widget noticeSection = Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Expanded(
              child: Row(children: [
                Image.asset('assets/images/home/notice.png', fit: BoxFit.cover),
                // Container(
                //   margin: const EdgeInsets.only(left: 6.0),
                //   child:ListView(
                //     children: [
                //       _buildMarquee(),
                //       _buildComplexMarquee(),
                //     ].map(_wrapWithStuff).toList(),
                //   ),
                 Text(
                   noticeStr,
                   style: TextStyle(
                     fontSize: 14,
                     color: ColorsUtil.hexStringColor('#333333'),
                     fontWeight: FontWeight.w400,
                   ),
//                  ),
                ),
              ])),
              Text(
                '今天',
                style: TextStyle(
                fontSize: 13,
                fontFamily: 'PingFangSC-Regular, PingFang SC',
                fontWeight: FontWeight.w400,
                color: ColorsUtil.hexStringColor('#999999'),
              ),
            )
        ],
      ),
    );



    Widget buildTextRow(String label, String value, double fontSize,
        String labelColor, String valueColor) {
      return Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                fontFamily: 'PingFangSC-Regular, PingFang SC',
                color: ColorsUtil.hexStringColor(labelColor),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                fontFamily: 'PingFangSC-Regular, PingFang SC',
                color: ColorsUtil.hexStringColor(valueColor),
              ),
            )
          ],
        ),
      );
    }

    _submitVerify() {
      Fluttertoast.showToast(msg: '资质未通过');
    }

    Widget inPassSection = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin:
              const EdgeInsets.only(top: 0, right: 0, bottom: 13.0, left: 0),
          child: const Image(
            image: AssetImage('assets/images/home/avatar.png'),
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
        ),
        buildTextRow('您的资质申请', '未通过', 14.0, '#666666', '#FF0020'),
        buildTextRow('驳回原因：', '执业医师证书无效', 12.0, '#999999', '#FF3131'),
        Container(
            margin: const EdgeInsets.only(top: 63.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: ColorsUtil.hexStringColor('#06B48D'),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: ColorsUtil.hexStringColor('#06B48D'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
              onPressed: () {
                _submitVerify();
              },
              child: Text(
                '重新提交资质认证',
                style: GSYConstant.textStyle(fontSize: 16.0),
              ),
            ))
      ],
    );
    Widget inOpenSection = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/home/status.png',
          fit: BoxFit.cover,
          width: 134,
          height: 134,
        ),
        Container(
          margin: const EdgeInsets.only(top: 37.0),
          child: Text(
            '您尚未开通问诊服务',
            style: GSYConstant.textStyle(color: '#666666'),
          ),
        ),
        Container(
          height: 44,
          width: 214,
          margin: const EdgeInsets.only(top: 39.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: ColorsUtil.hexStringColor('#06B48D'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0))),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const OpenService()));
            },
            child: Text(
              '立即开通',
              style: GSYConstant.textStyle(fontSize: 16.0),
            ),
          ),
        )
      ],
    );
    Widget adultSection = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/home/status.png',
          fit: BoxFit.cover,
          width: 134,
          height: 134,
        ),
        Container(
          margin: const EdgeInsets.only(top: 37.0),
          child: Text(
            '资质审核中，请您耐心等待…',
            style: GSYConstant.textStyle(color: '#666666'),
          ),
        ),
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: [
          buildBg,
          buttonSection,
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoticeDetail(
                          titleStr: noticeStr,
                          contentStr: noticeContent,
                          utstampStr: noticeTime)));
            },
            child: noticeSection,
          ),
          Container(
            // height: 44.0,
            margin: const EdgeInsets.only(top: 10.0, bottom: 13.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tab1Active = true;
                      tab2Active = false;
                      status = 1;
                      list = [];
                      _page = 1;
                    });
                    getData();
                    getCount();
                  },
                  child: Column(
                    children: [
                      Text(
                        '接诊中($receiving)',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      tab1Active
                          ? Container(
                              height: 2,
                              width: 69,
                              decoration: BoxDecoration(
                                  color: ColorsUtil.shallowColor,
                                  borderRadius: BorderRadius.circular(2.0)),
                            )
                          : const SizedBox()
                    ],
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tab2Active = true;
                      tab1Active = false;
                      status = 0;
                      list = [];
                      _page = 1;
                    });
                    getData();
                    getCount();
                  },
                  child: Column(
                    children: [
                      Text(
                        '待接诊($waitReceive)',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      tab2Active
                          ? Container(
                              height: 2,
                              width: 69,
                              decoration: BoxDecoration(
                                  color: ColorsUtil.shallowColor,
                                  borderRadius: BorderRadius.circular(2.0)),
                            )
                          : const SizedBox()
                    ],
                  ),
                ))
              ],
            ),
          ),
          Expanded(
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
          ),
          // Expanded(
          //   child: inPassSection,
          // ),
          // Expanded(child: inOpenSection),
          // // Expanded(child: adultSection)
        ],
      ),
    );
  }
}
