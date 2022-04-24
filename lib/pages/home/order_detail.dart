import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/video_topic.dart';
import 'package:doctor_project/pages/photoview_page.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/desensitization_utils.dart';
import 'package:doctor_project/utils/event_bus_util.dart';
import 'package:doctor_project/utils/image_network_catch.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../http/http_request.dart';
import '../../config/zego_config.dart';
import '../../http/api.dart';
import 'chat_room.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key, required this.map}) : super(key: key);
  final Map<String, dynamic> map;

  @override
  _OrderDetailState createState() => _OrderDetailState(this.map);
}

class _OrderDetailState extends State<OrderDetail> {
  late Map<String, dynamic> _map;

  _OrderDetailState(map) {
    _map = map;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('$_map');
    // {orderType: 0, sex_dictText: 未知字典, sex: 10, photo: , type_dictText: 图文问诊, type: 0, diseaseTime_dictText: 未知字典, orderType_dictText: 复诊拿药, times: 61966, diseaseTime: , diseaseData: [], name: 病人姓名, id: 432413381564170241, age: 22, diseaseDesc: }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '订单详情',
        isBack: true,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 11),
                  height: 73,
                  child: ListTile(
                      onTap: () {},
                      title: Row(
                        children: <Widget>[
                          Text(
                            _map['name'],
                            style: GSYConstant.textStyle(
                                fontFamily: 'Medium',
                                fontWeight: FontWeight.w500,
                                color: '#333333'),
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            _map['sex_dictText'],
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          Text(
                            '｜',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          Text(
                            _map['age'].toString() + '岁',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                        ],
                      ),
                      tileColor: Colors.white,
                      subtitle: Text(
                          DesensitizationUtil.desensitizationMobile(_map['phone'])),
                      // leading:_map['photo'].isEmpty?Image.network(_map['photo']):Image.asset('assets/images/home/avatar.png'),
                      leading: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0)),
                          height: 40.0,
                          width: 40.0,
                          child: _map['photo'] != null
                              ? Image.network(_map['photo'] ?? '')
                              : _map['sex_dictText'] == '男'
                              ? Image.asset('assets/images/boy.png')
                              : Image.asset('assets/images/girl.png')),
                      trailing: SvgUtil.svg('arrow_right.svg')),
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
                    _map['type_dictText'],
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
                            _map['name'],
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
                            _map['diseaseTime_dictText'] ?? '',
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
                            _map['isRepeat_dictText'],
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
                                _map['diseaseDesc'],
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
                          Flexible(
                            child: Wrap(
                                spacing: 10.0,
                                children: _map['diseaseData']
                                    .map<Widget>((item) => GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoViewPage(item)));
                                    },
                                    child: Image.network(
                                      item,
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    )))
                                    .toList()),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          Container(
                alignment: Alignment.bottomLeft,
                child: SafeArea(
                  child: Row(
                    children: <Widget>[
                          Expanded(
                              child: SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0))),
                                onPressed: () async{
                                 if( _map['status'] == '0') {
                                   showDialog<void>(
                                     context: context,
                                     builder: (BuildContext context) {
                                       return SimpleDialog(
                                         contentPadding: const EdgeInsets.all(
                                             0),
                                         titlePadding: const EdgeInsets.only(
                                             top: 14.0,
                                             left: 16.0,
                                             right: 16.0,
                                             bottom: 13.0),
                                         title: Text(
                                           '拒诊原因',
                                           style: GSYConstant.textStyle(
                                               fontSize: 15.0,
                                               color: '#333333'),
                                         ),
                                         children: <Widget>[
                                           SimpleDialogOption(
                                             padding: const EdgeInsets
                                                 .symmetric(
                                                 horizontal: 16.0),
                                             child: Container(
                                               decoration: BoxDecoration(
                                                   borderRadius:
                                                   BorderRadius.circular(
                                                       5.0),
                                                   border: Border.all(
                                                       width: 1,
                                                       color: ColorsUtil
                                                           .hexStringColor(
                                                           '#cccccc'))),
                                               height: 88,
                                               child: TextField(
                                                 decoration: InputDecoration(
                                                   hintText: '',
                                                   border: InputBorder.none,
                                                   hintStyle:
                                                   GSYConstant.textStyle(
                                                       color: '#999999'),
                                                 ),
                                                 style: GSYConstant.textStyle(
                                                     color: '#666666'),
                                                 cursorColor:
                                                 ColorsUtil.hexStringColor(
                                                     '#666666'),
                                               ),
                                             ),
                                             onPressed: () {
                                               Navigator.of(context).pop();
                                             },
                                           ),
                                           SimpleDialogOption(
                                             padding: const EdgeInsets.only(
                                                 top: 31.0, left: 0),
                                             child: Row(
                                               children: [
                                                 Expanded(
                                                     child: CustomElevatedButton(
                                                       title: '确认',
                                                       onPressed: () {
                                                         Navigator.pop(context);
                                                       },
                                                       height: 48,
                                                       textStyle:
                                                       GSYConstant.textStyle(
                                                         fontSize: 15.0,
                                                       ),
                                                       borderRadius:
                                                       const BorderRadius.only(
                                                           bottomLeft:
                                                           Radius.circular(
                                                               4.0)),
                                                     )),
                                                 Expanded(
                                                     child: CustomOutlineButton(
                                                       height: 48.0,
                                                       title: '取消',
                                                       onPressed: () {
                                                         Navigator.pop(context);
                                                       },
                                                       primary: '#ffffff',
                                                       textStyle:
                                                       GSYConstant.textStyle(
                                                           fontSize: 15.0,
                                                           color: '#666666'),
                                                       borderRadius:
                                                       const BorderRadius.only(
                                                           bottomRight:
                                                           Radius.circular(
                                                               4.0)),
                                                       borderColor:
                                                       ColorsUtil
                                                           .hexStringColor(
                                                           '#cccccc'),
                                                     ))
                                               ],
                                             ),
                                             // onPressed: () {
                                             //   Navigator.of(context).pop();
                                             // },
                                           ),
                                         ],
                                       );
                                     },
                                   ).then((val) {});
                                 }else {
                                   var request = HttpRequest.getInstance();
                                   Map<String, dynamic> map = {};
                                   map['registerId'] = _map['id'];
                                   var res = await request.post(Api.finishTopicApi, map);
                                   if(res['code']==200){
                                      Navigator.of(context).pop();
                                      EventBusUtil.getInstance().fire({'success':true});
                                   }
                                 }
                                },
                                child: Text(
                                  _map['status'] == '1'?'结束问诊':'拒诊',
                                  style: GSYConstant.textStyle(shadows: [
                                    const Shadow(
                                        offset: Offset(0, -1.0),
                                        blurRadius: 4.0,
                                        // text-shadow: 0px -1px 4px rgba(225, 225, 225, 0.5);
                                        color:
                                            Color.fromRGBO(225, 225, 225, 0.5))
                                  ], fontSize: 15.0, color: '#666666'),
                                ),
                              ),
                            )),
                      Expanded(
                          child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ColorsUtil.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          onPressed: () async {
                            var request = HttpRequest.getInstance();
                            Map<String, dynamic> map = {};
                            map['registerId'] = _map['id'];
                            var res = await request.post(
                                Api.getReceiveConsultApi, map);
                            if (res['code'] == 200) {
                              var res1 = await request.post(Api.createRoomApi, {
                                'orderId': _map['orderId'],
                                'roomType': _map['type'] == '2' ? 1 : 2,
                                'patientId': _map['patientId']
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
                                  if (_map['type'] == '2') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VideoTopic(
                                                  regId: _map['id'],
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatRoom(
                                                  userInfoMap: _map,
                                                )));
                                  }
                                }
                              }
                            }
                          },
                          child: Text(
                            _map['status'] == '1' ? '继续交流' : '接诊',
                            style: GSYConstant.textStyle(shadows: [
                              const Shadow(
                                  offset: Offset(0, -1.0),
                                  blurRadius: 4.0,
                                  // text-shadow: 0px -1px 4px rgba(225, 225, 225, 0.5);
                                  color: Color.fromRGBO(225, 225, 225, 0.5))
                            ], fontSize: 15.0, color: '#ffffff'),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
          )
        ],
      ),
    );
  }
}
