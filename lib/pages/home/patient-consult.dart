import 'dart:async';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/home/video_topic.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../config/zego_config.dart';
import '../../http/api.dart';
import '../../utils/event_bus_util.dart';
import '../../utils/image_network_catch.dart';
import '../../utils/svg_util.dart';
import '../../utils/toast_util.dart';
import '../../widget/custom_outline_button.dart';
import 'chat_room.dart';
import 'order_detail.dart';

class PatientConsult extends StatefulWidget {
  const PatientConsult({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  _PatientConsultState createState() => _PatientConsultState(type);
}

class _PatientConsultState extends State<PatientConsult> {
  bool tab1Active = true;
  bool tab2Active = false;
  List list = [];
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数
  bool isMore = true;
  int receiving = 0;
  int status = 1;
  int waitReceive = 0;
  String type;
  StreamSubscription? stream;
  _PatientConsultState(this.type);

  @override
  void initState() {
    super.initState();
    getData();
    getCount();
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

  getCount() async {
    var request = HttpRequest.getInstance();
    var res = await request.get(Api.getReceiveConsultCount, {'type': type});
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
        Api.getReceiveConsultList +
            '?status=$status&page=$_page&size=10&type=$type',
        {});
    if (res['code'] == 200) {
      setState(() {
        list = res['data']['records'];
        isMore = true;
      });
    } else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  Future _getMore() async {
    if (isMore) {
      _page += 1;
      var request = HttpRequest.getInstance();
      var res = await request.get(
          Api.getReceiveConsultList +
              '?status=$status&page=$_page&size=10&type=$type',
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
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream!.cancel();
      stream = null;
    }
    _scrollController.dispose();
  }

  Widget _renderRow(BuildContext context, int index) {
    // int status =1;
    var item = list[index];
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetail(map: list[index])));
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
                            await showDialog(
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
                                                    Navigator.pop(context);
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
                                                    getData();
                                                    getCount();
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
                                                              width: 1.0,
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
                                'patientId': item['patientId']
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VideoTopic(
                                              regId: item['id'],
                                              userInfoMap: item,
                                            ))).then((value) => {
                                      getData(),
                                      getCount()
                                    });
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatRoom(
                                              userInfoMap: item,
                                            ))).then(
                                            (value) => {
                                          getData(),
                                          getCount()
                                        });
                                  }
                                }
                              }
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
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: [
          CustomAppBar(
            type == '1'
                ? '患者咨询'
                : type == '0'
                    ? '图文问诊'
                    : '视频问诊',
            onBackPressed: () {
              Navigator.pop(context);
            },
          ),
          Container(
            margin: const EdgeInsets.only(top:10.0,bottom:14.0),
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
            child: RefreshIndicator(
              displacement: 10.0,
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding:EdgeInsets.zero,
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
