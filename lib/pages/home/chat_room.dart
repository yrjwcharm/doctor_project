import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/home/make_prescription.dart';
import 'package:doctor_project/pages/home/video_topic.dart';
import 'package:doctor_project/pages/my/write-case.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/common_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show MethodChannel, PlatformException, SystemChannels, rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import '../../config/zego_config.dart';
import '../../http/api.dart';
import '../../utils/svg_util.dart';

class ChatRoom extends StatelessWidget {
  Map userInfoMap; //患者信息map
  ChatRoom({Key? key, required this.userInfoMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(
          '${userInfoMap['name']}患者',
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: ChatPage(
          userInfoMap: this.userInfoMap,
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  Map userInfoMap;

  ChatPage({Key? key, required this.userInfoMap}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState(userInfoMap: this.userInfoMap);
}

class _ChatPageState extends State<ChatPage> {
  Map userInfoMap;

  _ChatPageState({required this.userInfoMap});

  List<types.Message> _messages = [];

  // final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  types.User _user = const types.User(id: '');
  bool _isVoice = false;
  bool _isMore = false;
  double keyboardHeight = 270.0;
  bool _emojiState = false;
  FocusNode _focusNode = new FocusNode();
  final String _roomID = ZegoConfig.instance.roomID;
  final request = HttpRequest.getInstance();
  String _messagesBuffer = '';

  bool _isEngineActive = false;
  ZegoRoomState _roomState = ZegoRoomState.Disconnected;

  List<ZegoUser> _allUsers = [];
  List<ZegoUser> _customCommandSelectedUsers = [];
  TextEditingController _editingController = new TextEditingController();
  TextEditingController _broadcastMessageController =
      new TextEditingController();
  TextEditingController _customCommandController = new TextEditingController();
  TextEditingController _barrageMessageController = new TextEditingController();
  TextEditingController _roomExtraInfoKeyController =
      new TextEditingController();
  TextEditingController _roomExtraInfoValueController =
      new TextEditingController();
  String msg = '';

  // Map res['data'] =Map();
  Map doctorMap = {};

  @override
  void initState() {
    super.initState();
    ZegoExpressEngine.getVersion()
        .then((value) => print('🌞 SDK Version: $value'));

    createEngine();

    loginRoom();

    setZegoEventCallback();
    print("userInfoMap-------" + this.userInfoMap.toString());

    // _loadMessages();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _emojiState = false;
          _isMore = false;
        });
      }
    });
    getNet_doctorInfo();
    getRecordList();
  }

  @override
  void dispose() {
    destroyEngine();

    clearZegoEventCallback();
    _focusNode.dispose();
    super.dispose();
  }

  getRecordList() async {
    List<types.Message> messageList = [];

    var res = await request.get(
        Api.getRecordListApi + '?roomId=${ZegoConfig.instance.roomID}', {});
    if (res['code'] == 200) {
      List<dynamic> list = res['data']['record'];
      list.sort((a,b)=>b['sendTime'].toString().compareTo(a['sendTime'].toString()));
      list.forEach((item) {
        if (item['type'] == '1') {
          types.Message _message = types.TextMessage.fromJson({
            "author": {
              "firstName": item['userName'],
              "id": item['userId'],
              "imageUrl": item['roleCode'] == '2'
                  ? userInfoMap['photo']
                  : doctorMap['photoUrl'] ?? ''
            },
            "createdAt":
                DateTime.parse(item['sendTime']).millisecondsSinceEpoch,
            "id": const Uuid().v4(),
            "status": item['roleCode'] == '2' ? "seen" : "sent",
            "text": item['info'],
            "type": 'text'
          });
          messageList.add(_message);
        } else if (item['type'] == '2') {
          types.Message _message = types.ImageMessage.fromJson({
            "author": {
              "firstName": item['userName'],
              "id": item['userId'],
              "imageUrl": item['roleCode'] == '2'
                  ? userInfoMap['photo']
                  : doctorMap['photoUrl'] ?? ''
            },
            "createdAt":
                DateTime.parse(item['sendTime']).millisecondsSinceEpoch,
            "height": 12,
            "id": const Uuid().v4(),
            "name": "image",
            "size": 0,
            'width':12,
            "status": item['roleCode'] == '2' ? "seen" : "sent",
            "type": "image",
            "uri": item['info'],
          });

          messageList.add(_message);
        }
      });

      setState(() {
        _messages = messageList;
      });
    }
  }

  //获取医生信息
  getNet_doctorInfo() async {
    HttpRequest request = HttpRequest.getInstance();
    var res = await request.get(Api.getDoctorInfoUrl, {});
    print("getNet_doctorInfo------" + res.toString());

    if (res['code'] == 200) {
      setState(() {
        doctorMap = res['data'];
        _user = types.User(
            id: res['data']['userId'].toString(),
            firstName: res['data']['realName'],
            imageUrl: res['data']['photoUrl'] ?? '');
      });
    }
  }

  void createEngine() {
    ZegoEngineProfile profile = ZegoEngineProfile(
        ZegoConfig.instance.appID, ZegoConfig.instance.scenario,
        enablePlatformView: ZegoConfig.instance.enablePlatformView);
    ZegoExpressEngine.createEngineWithProfile(profile);

    // Notify View that engine state changed
    setState(() => _isEngineActive = true);

    print('🚀 Create ZegoExpressEngine');
  }

  void loginRoom() {
    // Instantiate a ZegoUser object
    ZegoUser user =
        ZegoUser(ZegoConfig.instance.userID, ZegoConfig.instance.userName);

    ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig();
    roomConfig.token = ZegoConfig.instance.token;
    // Login Room
    ZegoExpressEngine.instance.loginRoom(_roomID, user, config: roomConfig);

    print('🚪 Start login room, roomID: $_roomID');
  }

  // MARK: - Exit

  void destroyEngine() async {
    // Can destroy the engine when you don't need audio and video calls
    //
    // Destroy engine will automatically logout room and stop publishing/playing stream.
    ZegoExpressEngine.destroyEngine();

    print('🏳️ Destroy ZegoExpressEngine');
  }

  // MARK: - Event

  void setZegoEventCallback() {
    ZegoExpressEngine.onRoomStateUpdate = (String roomID, ZegoRoomState state,
        int errorCode, Map<String, dynamic> extendedData) {
      print(
          '🚩 🚪 Room state update, roomID: $roomID, state: $state, errorCode: $errorCode');
      setState(() => _roomState = state);
    };

    ZegoExpressEngine.onRoomUserUpdate =
        (String roomID, ZegoUpdateType updateType, List<ZegoUser> userList) {
      print(
          '🚩 🕺 Room user update, roomID: $roomID, type: ${updateType.toString()}, count: ${userList.length}');
      if (updateType == ZegoUpdateType.Add) {
        setState(() => _allUsers.addAll(userList));
      } else if (updateType == ZegoUpdateType.Delete) {
        for (ZegoUser removedUser in userList) {
          for (ZegoUser user in _allUsers) {
            if (user.userID == removedUser.userID &&
                user.userName == removedUser.userName) {
              setState(() => _allUsers.remove(user));
            }
          }
        }
      }
    };

    ZegoExpressEngine.onIMRecvBroadcastMessage =
        (String roomID, List<ZegoBroadcastMessageInfo> messageList) {
      for (ZegoBroadcastMessageInfo message in messageList) {
        appendMessage(message);
      }
    };

    ZegoExpressEngine.onIMRecvCustomCommand =
        (String roomID, ZegoUser fromUser, String command) {
      print(
          '🚩 💭 Received custom command, fromUser: ${fromUser.userID}, roomID: $roomID, command: $command');
    };

    ZegoExpressEngine.onIMRecvBarrageMessage =
        (String roomID, List<ZegoBarrageMessageInfo> messageList) {
      // for (ZegoBarrageMessageInfo message in messageList) {
      //   print('🚩 🗯 Received barrage message, ID: ${message.messageID}, fromUser: ${message.fromUser.userID}, sendTime: ${message.sendTime}, roomID: $roomID');
      //   appendMessage('🗯 ${message.message} [ID:${message.messageID}] [From:${message.fromUser.userName}]');
      // }
    };

    ZegoExpressEngine.onRoomExtraInfoUpdate =
        (String roomID, List<ZegoRoomExtraInfo> roomExtraInfoList) {
      print('🚩 📢 Room extra info update');
      // for (ZegoRoomExtraInfo info in roomExtraInfoList) {
      //   print('🚩 📢 --- Key: ${info.key}, Value: ${info.value}, Time: ${info.updateTime}, UserID: ${info.updateUser.userID}');
      //   appendMessage('📢 RoomExtraInfo: Key: [${info.key}], Value: [${info.value}], From:${info.updateUser.userName}');
      // }
    };
  }

  void clearZegoEventCallback() {
    ZegoExpressEngine.onRoomStateUpdate = null;
    ZegoExpressEngine.onRoomUserUpdate = null;
    ZegoExpressEngine.onIMRecvBroadcastMessage = null;
    ZegoExpressEngine.onIMRecvCustomCommand = null;
    ZegoExpressEngine.onIMRecvBarrageMessage = null;
  }

  // MARK: - Message

  // void sendBroadcastMessage(message) {
  //   // String message = _broadcastMessageController.text.trim();
  //   ZegoExpressEngine.instance
  //       .sendBroadcastMessage(_roomID, message)
  //       .then((value) {
  //     print(
  //         '🚩 💬 Send broadcast message result, errorCode: ${value.errorCode}');
  //   });
  // }

  void sendCustomCommand() {
    // TODO: Support selecting users
    _customCommandSelectedUsers = _allUsers;

    String command = _customCommandController.text.trim();
    ZegoExpressEngine.instance
        .sendCustomCommand(_roomID, command, _customCommandSelectedUsers)
        .then((value) {
      print('🚩 💭 Send custom command result, errorCode: ${value.errorCode}');
    });
  }

  void sendBarrageMessage() {
    String message = _barrageMessageController.text.trim();
    ZegoExpressEngine.instance
        .sendBarrageMessage(_roomID, message)
        .then((value) {
      print('🚩 🗯 Send barrage message, errorCode: ${value.errorCode}');
    });
  }

  void setRoomExtraInfo() {
    String key = _roomExtraInfoKeyController.text.trim();
    String value = _roomExtraInfoValueController.text.trim();
    ZegoExpressEngine.instance
        .setRoomExtraInfo(_roomID, key, value)
        .then((result) {
      print('🚩 📢 Set room extra info result, errorCode: ${result.errorCode}');
    });
  }

  void appendMessage(ZegoBroadcastMessageInfo message) {
    print('msg,${message.message}',);
    if (CommonUtils.isImageEnd(message.message)) {
      print('11111,走了');
      types.Message _message = types.ImageMessage.fromJson(
        {
          "author": {
            "firstName": userInfoMap['name'],
            "id": userInfoMap['patientId'],
            "imageUrl": userInfoMap['photo']
          },
          "createdAt": DateTime.now().millisecondsSinceEpoch,
          "height": 0,
          "id": const Uuid().v4(),
          "name": "image",
          "size": 0,
          "status": "seen",
          "type": "image",
          "uri": message.message,
          "width": 0
        },
      );
      // saveRecord(message.message, '1', userInfoMap['patientId'],
      //     userInfoMap['name'], '2');
      _addMessage(_message);
    } else {
      print('111111,${userInfoMap['photo']}',);

      // appendMessage('💬 ${message.message} [ID:${message.messageID}] [From:${message.fromUser.userName}]');
      types.Message _message = types.TextMessage.fromJson({
        "author": {
          "firstName": userInfoMap['name']??'',
          "id": userInfoMap['patientId']??'',
          "imageUrl": userInfoMap['photo']
        },
        "createdAt": message.sendTime,
        "id": const Uuid().v4(),
        "status": "seen",
        "text": message.message,
        "type": 'text'
      });
      // saveRecord(response[0]['text'], '1', userInfoMap['patientId'],
      //     userInfoMap['name'], '2');
      _addMessage(_message);
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAtachmentPressed() {}

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author:_user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void pickerImage(ImageSource source) async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: source,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      FormData formData =
          FormData.fromMap({'file': await MultipartFile.fromFile(result.path)});
      var request = HttpRequest.getInstance();
      var $result = await request.uploadFile(Api.uploadImgApi, formData);
      if ($result['code'] == 200) {
        final message = types.ImageMessage(
          author:_user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: const Uuid().v4(),
          name: result.name,
          status: Status.sent,
          size: bytes.length,
          uri: $result['data']['url'],
          width: image.width.toDouble(),
        );
        // $result['data']['url']
        ZegoExpressEngine.instance
            .sendBroadcastMessage(_roomID, $result['data']['url'])
            .then((value) {
              if(value.errorCode==0){
                _addMessage(message);
              }
        });
      }
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage.fromPartial(  createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        status: Status.sent,
        author: _user, partialText: message);
    ZegoExpressEngine.instance
        .sendBroadcastMessage(_roomID, textMessage.text)
        .then((value) {
      if(value.errorCode==0){
        _addMessage(textMessage);
      }else{
        ToastUtil.showToast(msg: '发送消息失败${value.errorCode}');
      }
      print(
          '🚩 💬 Send broadcast message result, errorCode: ${value.errorCode}');
    });
  }

  // void _loadMessages() async {
  //   final messages = []
  //       .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
  //       .toList();
  //
  //   setState(() {
  //     _messages = messages;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Chat(
      
        imageMessageBuilder: (types.ImageMessage imageMessage, {required int messageWidth}){
          return SizedBox(
            width:100.0,
            height:80.0 ,
            // height: 50.0,
            child: Image.network(imageMessage.uri,fit: BoxFit.contain,),
          );
       },
        disableImageGallery: false,
        usePreviewData:false,
        theme: DefaultChatTheme(
          backgroundColor: ColorsUtil.hexStringColor('#f9f9f9'),
            // seenIcon: SizedBox.shrink(),
            // userNameTextStyle:GSYConstant.textStyle(fontSize:14.0,color: '#333333' ),
          statusIconPadding: const EdgeInsets.all(10.0),
          messageBorderRadius:4.0,
            userAvatarNameColors:[
            //   // Color(0xffff6767),
            //   // Color(0xff66e0da),
            //   // Color(0xfff5a2d9),
            //   // Color(0xfff0c722),
            //   // Color(0xff6a85e5),
            //   Color(0xfffd9a6f),
              Color(0xff92db6e),
            //   // Color(0xff73b8e5),
            //   // Color(0xfffd7590),
            //   // Color(0xffc78ae5),
            ],
            messageInsetsVertical:10.0,
          messageInsetsHorizontal:10.0,
          // statusIconPadding: EdgeInsets.zero,
          // dateDividerMargin: EdgeInsets.zero,
          deliveredIcon:Stack(children: [
            Container(
            // margin: const EdgeInsets.symmetric(horizontal: 10.0),
          width: 34.0, height: 34.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17)
          ),
          clipBehavior: Clip.hardEdge,
          child:doctorMap['photoUrl']==null?const SizedBox.shrink():Image.network(doctorMap['photoUrl'],fit: BoxFit.cover,),
        )],)),
        hideBackgroundOnEmojiMessages:false,
      emptyState: const SizedBox.shrink(),
      dateFormat:DateFormat('yyyy/MM/dd') ,
      // dateLocale:'HH:mm',
      timeFormat: DateFormat('HH:mm'),
      isLastPage:true,
      customBottomWidget: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 54.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          color: ColorsUtil.hexStringColor('#cccccc',
                              alpha: 0.3)))),
              child: Row(
                children: <Widget>[
                  // SvgUtil.svg('voice.svg'),
                  // const SizedBox(
                  //   width: 5.0,
                  // ),
                  Expanded(
                      child: Container(
                          height: 33.0,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                              color: ColorsUtil.hexStringColor('#f8f8f8'),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: TextField(
                            controller: _editingController,
                            textInputAction: TextInputAction.send,
                            focusNode: _focusNode,
                            inputFormatters: [],
                            onChanged: (value) {},
                            onSubmitted: (value) {
                              _handleSendPressed(PartialText(text: value));
                              _editingController.clear();
                            },
                            cursorColor: ColorsUtil.hexStringColor('#666666'),
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#666666'),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: true,
                                hintText: '输入你想回复患者的话…',
                                hintStyle: GSYConstant.textStyle(
                                    fontSize: 13.0, color: '#999999')),
                          ))),
                  const SizedBox(
                    width: 21.0,
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _emojiState = !_emojiState;
                            _isMore = false;
                          });
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        },
                        child: SvgUtil.svg('smile.svg'),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isMore = !_isMore;
                            _emojiState = false;
                          });
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        },
                        child: SvgUtil.svg('add_.svg'),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Offstage(
                offstage: !_isMore,
                child: Container(
                  padding: const EdgeInsets.only(top: 11.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              pickerImage(ImageSource.gallery);
                            },
                            child: SvgUtil.svg('picture.svg'),
                          ),
                          const SizedBox(
                            height: 9.0,
                          ),
                          Text(
                            '相册',
                            style: GSYConstant.textStyle(
                                color: '#333333', fontSize: 12.0),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              pickerImage(ImageSource.camera);
                            },
                            child: SvgUtil.svg('camera.svg'),
                          ),
                          const SizedBox(
                            height: 9.0,
                          ),
                          Text(
                            '拍摄',
                            style: GSYConstant.textStyle(
                                color: '#333333', fontSize: 12.0),
                          )
                        ],
                      ),
                      Visibility(
                        visible: userInfoMap['type'] == '0',
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) => WillPopScope(
                                    onWillPop: () async {
                                      return Future.value(false);
                                    },
                                    child: AlertDialog(
                                      contentPadding: const EdgeInsets.only(
                                          top: 28.0,
                                          bottom: 20.0,
                                          left: 16.0,
                                          right: 16.0),
                                      buttonPadding: EdgeInsets.zero,
                                      // insetPadding: EdgeInsets.zero,
                                      contentTextStyle: GSYConstant.textStyle(
                                          color: '#333333'),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const <Widget>[
                                            Text(
                                              '1、远程复诊开药处方的适用对象是在线下医院经过规范治疗后，诊断明确、病情的治疗方案基本稳定、依从性良好的慢性病种复诊患者。',
                                              textAlign: TextAlign.justify,
                                            ),
                                            SizedBox(
                                              height: 12.0,
                                            ),
                                            Text('2、处方开具医生须向患者说明处方使用规范和注意事项。',
                                                textAlign: TextAlign.justify)
                                          ]),
                                      actions: [
                                        Container(
                                          height: 59.0,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      width: 1.0,
                                                      color: ColorsUtil
                                                          .hexStringColor(
                                                              '#cccccc',
                                                              alpha: 0.4)))),
                                          child: CustomElevatedButton(
                                            title: '我已知晓',
                                            textStyle: GSYConstant.textStyle(
                                                fontSize: 16.0),
                                            height: 36.0,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            width: 119.0,
                                            primary: '#06B48D',
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MakePrescription(
                                                            registeredId:
                                                                userInfoMap[
                                                                        "id"]
                                                                    .toString(),
                                                          )));
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: SvgUtil.svg('rp.svg'),
                            ),
                            const SizedBox(
                              height: 9.0,
                            ),
                            Text(
                              '开处方',
                              style: GSYConstant.textStyle(
                                  color: '#333333', fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: userInfoMap['type'] == '0',
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WriteCase(
                                              registeredId:
                                                  userInfoMap["id"].toString(),
                                              userInfoMap: userInfoMap,
                                            )));
                              },
                              child: SvgUtil.svg('case.svg'),
                            ),
                            const SizedBox(
                              height: 9.0,
                            ),
                            Text(
                              '写病历',
                              style: GSYConstant.textStyle(
                                  color: '#333333', fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      // Column(
                      //   children: <Widget>[
                      //     GestureDetector(
                      //      child: SvgUtil.svg('words.svg'),),
                      //     const SizedBox(height: 9.0,),
                      //     Text('常用语',style: GSYConstant.textStyle(color: '#333333',fontSize: 12.0),)
                      //   ],
                      // ),
                    ],
                  ),
                )),
            Offstage(
              offstage: !_emojiState,
              child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      _handleSendPressed(PartialText(text: emoji.emoji));
                      // Do something when emoji is tapped
                    },
                    onBackspacePressed: () {
                      // Backspace-Button tapped logic
                      // Remove this line to also remove the button in the UI
                    },
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      initCategory: Category.RECENT,
                      bgColor: Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      progressIndicatorColor: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      noRecentsText: 'No Recents',
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                    ),
                  )),
            )
          ],
        ),
      ),
      emojiEnlargementBehavior: EmojiEnlargementBehavior.multi,
      showUserAvatars: true,
      showUserNames: true,
      messages: _messages,
      onAttachmentPressed: _handleAtachmentPressed,
      onMessageTap: _handleMessageTap,
      onPreviewDataFetched: _handlePreviewDataFetched,
      onSendPressed: _handleSendPressed,
      user: _user,
    );
  }
}
