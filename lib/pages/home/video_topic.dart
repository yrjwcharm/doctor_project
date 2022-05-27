//
//  quick_start_page.dart
//  zego-express-example-topics-flutter
//
//  Created by Patrick Fu on 2020/12/04.
//  Copyright © 2020 Zego. All rights reserved.
//
import 'dart:math';
import 'dart:convert' as convert;
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/home/make_prescription.dart';
import 'package:doctor_project/pages/my/write-case.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:zego_express_engine/zego_express_engine.dart';

import '../../config/zego_config.dart';
import '../../http/api.dart';

class VideoTopic extends StatefulWidget {
  VideoTopic(
      {Key? key,
      required this.regId,
      required this.docName,
      required this.userInfoMap})
      : super(key: key);
  final String regId;
  final String docName;
  Map userInfoMap;

  @override
  _VideoTopicState createState() =>
      _VideoTopicState(regId, userInfoMap, docName);
}

class _VideoTopicState extends State<VideoTopic> {
  String _version = "";

  ZegoScenario _scenario = ZegoScenario.General;
  bool _enablePlatformView = false;
  bool _isCameraPermissionGranted = false;
  bool _isMicrophonePermissionGranted = false;
  bool isMuteMicrophone = false; //设置是否静音（关闭麦克风）
  bool isMuteSpeaker = false; //  bool muteSpeaker = false; 设置是否静音（关闭音频输出）。
  final String _roomID = ZegoConfig.instance.roomID;
  int _previewViewID = -1;
  int _playViewID = -1;
  Widget? _previewViewWidget;
  Widget? _playViewWidget;
  final GlobalKey _playViewContainerKey = GlobalKey();
  final GlobalKey _previewViewContainerKey = GlobalKey();
  static const double viewRatio = 3.0 / 8.0;
  bool _isVisibility = false;
  ZegoMediaPlayer? mediaPlayer;
  bool _isEngineActive = false;
  ZegoRoomState _roomState = ZegoRoomState.Disconnected;
  ZegoPublisherState _publisherState = ZegoPublisherState.NoPublish;
  ZegoPlayerState _playerState = ZegoPlayerState.NoPlay;
  String _streamID = '';
  final TextEditingController _publishingStreamIDController =
      TextEditingController();
  final TextEditingController _playingStreamIDController =
      TextEditingController();
  String regId;
  String docName;
  String taskId = '';
  Map userInfoMap;

  _VideoTopicState(this.regId, this.userInfoMap, this.docName);

  _showDialog() async {
    await showDialog(
        useSafeArea: false,
        barrierDismissible: false,
        context: context,
        builder: (_) => WillPopScope(
              onWillPop: () async {
                return Future.value(false);
              },
              child: AlertDialog(
                contentPadding: const EdgeInsets.only(
                    top: 28.0, bottom: 20.0, left: 16.0, right: 16.0),
                buttonPadding: EdgeInsets.zero,
                // insetPadding: EdgeInsets.zero,
                contentTextStyle: GSYConstant.textStyle(color: '#333333'),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text(
                    '请务必等待患者进入房间后，点击开始录制',
                    textAlign: TextAlign.center,
                    style: GSYConstant.textStyle(color: '#333333'),
                  ),
                  // SizedBox(
                  //   height: 12.0,
                  // ),
                  // Text('2、处方开具医生须向患者说明处方使用规范和注意事项。',
                  //     textAlign: TextAlign.justify)
                ]),
                actions: [
                  Container(
                    height: 59.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 1.0,
                                color: ColorsUtil.hexStringColor('#cccccc',
                                    alpha: 0.4)))),
                    child: CustomElevatedButton(
                      title: '开始录制',
                      textStyle: GSYConstant.textStyle(fontSize: 16.0),
                      height: 36.0,
                      borderRadius: BorderRadius.circular(5.0),
                      width: 119.0,
                      primary: '#06B48D',
                      onPressed: () async {
                        // if(_streamID.isEmpty){
                        //   ToastUtil.showToast(msg: '请等待患者进入房间');
                        //   // Navigator.pop(context);
                        //   return;
                        // }
                        var request = HttpRequest.getInstance();
                        var res = await request.post(Api.startRecordVideo, {
                          'room_id': ZegoConfig.instance.roomID,
                          'startInfo': convert.jsonEncode({
                            'app_id': ZegoConfig.instance.appID,
                            'access_token': ZegoConfig.instance.token,
                            'room_id': ZegoConfig.instance.roomID,
                            'record_input_params': {
                              'record_mode': 2,
                              'mix_config': {
                                'mix_output_stream_id': "01_" +
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                'mix_output_video_config': {
                                  'width': 1920,
                                  'height': 1080,
                                  'fps': 15,
                                  'bitrate': 3000
                                }
                              }
                            },
                            'mix_input_list': {
                              'fill_mode': 2,
                            },
                            'record_output_params': {},
                          })
                        });
                        if (res['code'] == 200) {
                          String taskId = res['data']['video']['task_id'];
                          print('taskId++++++++++++ $taskId');
                          setState(() {
                            this.taskId = taskId;
                          });
                          Navigator.pop(context);
                        } else {
                          ToastUtil.showToast(msg: res['msg']);
                        }
                      },
                    ),
                  )
                ],
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    //第一种解决方案 使用dialog
    // Future.delayed(Duration.zero, () {
    //   _showDialog();
    // });
    //第二种
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _showDialog();
    });

    ZegoExpressEngine.getVersion()
        .then((value) => print('🌞 SDK Version: $value'));

    // if (ZegoConfig.instance.appID > 0) {
    //   _appIDEdController.text = ZegoConfig.instance.appID.toString();
    // }
    //
    // if (ZegoConfig.instance.userID.isNotEmpty) {
    //   _userIDEdController.text = ZegoConfig.instance.userID;
    // }
    //
    // _userNameEdController.text = ZegoConfig.instance.userName;
    //
    // if (ZegoConfig.instance.token.isNotEmpty) {
    //   _tokenEdController.text = ZegoConfig.instance.token;
    // }

    _scenario = ZegoConfig.instance.scenario;
    _enablePlatformView = ZegoConfig.instance.enablePlatformView;

    if (Platform.isAndroid || Platform.isIOS) {
      Permission.camera.status.then((value) => setState(() =>
          _isCameraPermissionGranted = value == PermissionStatus.granted));
      Permission.microphone.status.then((value) => setState(() =>
          _isMicrophonePermissionGranted = value == PermissionStatus.granted));
    } else {
      _isCameraPermissionGranted = true;
      _isMicrophonePermissionGranted = true;
    }
    if (!_isMicrophonePermissionGranted || !_isCameraPermissionGranted) {
      requestPermission();
      // ZegoUtils.showAlert(context,
      //     'Microphone permission is not granted, please click the mic icon to request permission');
      return;
    }
    setZegoEventCallback();
    createEngine();
  }

  bool _isEnableCamera = true;

  isEnableCamera() {
    ZegoExpressEngine.instance.enableCamera(_isEnableCamera);
  }
   bool _isFrontCamera = true;
  isTransformCamera()  {
    ZegoExpressEngine.instance.useFrontCamera(_isFrontCamera);
  }

  bool _isEnableMic = true;

  isEnableMic() {
    ZegoExpressEngine.instance.muteMicrophone(_isEnableMic);
  }
  bool _isEnableSpeaker = true;

  isEnableSpeaker() {
    ZegoExpressEngine.instance.muteSpeaker(_isEnableSpeaker);
  }

  Future<void> requestPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus microphoneStatus = await Permission.microphone.request();
    setState(() => {
          _isCameraPermissionGranted = cameraStatus.isGranted,
          _isMicrophonePermissionGranted = microphoneStatus.isGranted
        });
    if (_isCameraPermissionGranted && _isMicrophonePermissionGranted) {
      setZegoEventCallback();
      createEngine();
    }
  }

  Future<void> requestMicrophonePermission() async {
    PermissionStatus microphoneStatus = await Permission.microphone.request();
    setState(() => _isMicrophonePermissionGranted = microphoneStatus.isGranted);
  }

  @override
  void deactivate() {
    super.deactivate();
    print('1111222222221111走了啊');
  }

  @override
  void dispose() async {
    // Can destroy the engine when you don't need audio and video calls
    //
    // Destroy engine will automatically logout room and stop publishing/playing stream.
    ZegoExpressEngine.destroyEngine()
        .then((value) => print('async destroy success'));

    print('🏳️ Destroy ZegoExpressEngine');

    clearZegoEventCallback();
    print('11111111111111走了啊$taskId');
    super.dispose();
    print('11111111走了啊$taskId');
    var request = HttpRequest.getInstance();
    var res = await request.post(Api.stopRecordVideo, {'task_id': taskId});
    if (res['code'] == 200) {
      if (res['data']['video']['code'] == 0) {
        ToastUtil.showToast(msg: '录制结束！！！');
      }
    }
  }

  // MARK: - Step 1: CreateEngine

  void createEngine() {
    ZegoEngineProfile profile = ZegoEngineProfile(
        ZegoConfig.instance.appID, ZegoConfig.instance.scenario,
        // appSign: ZegoConfig.instance.token,
        enablePlatformView: ZegoConfig.instance.enablePlatformView);
    ZegoExpressEngine.createEngineWithProfile(profile);

    // Notify View that engine state changed
    setState(() => _isEngineActive = true);

    ZegoExpressEngine.instance.getAudioConfig().then((value) => {
          if (_roomState == ZegoRoomState.Disconnected)
            {
              loginRoom(),
            }
        });
  }

  // MARK: - Step 2: LoginRoom

  void loginRoom() {
    // Instantiate a ZegoUser object
    ZegoUser user =
        ZegoUser(ZegoConfig.instance.userID, ZegoConfig.instance.userName);

    ZegoRoomConfig config = ZegoRoomConfig.defaultConfig();
    config.token = ZegoConfig.instance.token;
    // Login Room
    try {
      ZegoExpressEngine.instance.loginRoom(_roomID, user, config: config);
    } catch (e) {
      print("1111$e");
    }

    print('🚪 Start login room, roomID: ${ZegoConfig.instance.userID}');
    if (_publisherState == ZegoPublisherState.NoPublish) {
      double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      Size? widgetSize = _previewViewContainerKey.currentContext?.size;
      startPublishingStream('1111',
          width: widgetSize!.width * pixelRatio,
          height: widgetSize.height * pixelRatio);
    } else {
      stopPublishingStream();
    }
    if (_playerState == ZegoPlayerState.NoPlay) {
      double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      Size? widgetSize = _playViewContainerKey.currentContext?.size;
      startPlayingStream(_streamID,
          width: widgetSize!.width * pixelRatio,
          height: widgetSize.height * pixelRatio);
    } else {
      stopPlayingStream(_streamID);
    }
  }

  void logoutRoom() {
    // Logout room will automatically stop publishing/playing stream.
    //
    // But directly logout room without destroying the [PlatformView]
    // or [TextureRenderer] may cause a memory leak.
    ZegoExpressEngine.instance.logoutRoom(_roomID);
    print('🚪 logout room, roomID: $_roomID');

    clearPreviewView();
    clearPlayView();
  }

  // MARK: - Step 3: StartPublishingStream

  void startPublishingStream(String streamID,
      {double width = 360, double height = 640}) {
    void _startPreview(int viewID) {
      ZegoCanvas canvas = ZegoCanvas.view(viewID);
      canvas.viewMode = ZegoViewMode.AspectFill;
      ZegoExpressEngine.instance.startPreview(canvas: canvas);
      print('🔌 Start preview, viewID: $viewID');
    }

    void _startPublishingStream(String streamID) {
      ZegoExpressEngine.instance.startPublishingStream(streamID);
      print('📤 Start publishing stream, streamID: $streamID');
    }

    if (Platform.isIOS || Platform.isAndroid) {
      if (ZegoConfig.instance.enablePlatformView) {
        // Render with PlatformView
        setState(() {
          _previewViewWidget =
              ZegoExpressEngine.instance.createPlatformView((viewID) {
            _previewViewID = viewID;
            _startPreview(_previewViewID);
            _startPublishingStream(streamID);
          });
        });
      } else {
        // Render with TextureRenderer
        ZegoExpressEngine.instance
            .createTextureRenderer(width.toInt(), height.toInt())
            .then((viewID) {
          _previewViewID = viewID;
          setState(() => _previewViewWidget = Texture(textureId: viewID));
          _startPreview(viewID);
          _startPublishingStream(streamID);
        });
      }
    } else {
      ZegoExpressEngine.instance.startPreview();
      ZegoExpressEngine.instance.startPublishingStream(streamID);
    }
  }

  void stopPublishingStream() {
    ZegoExpressEngine.instance.stopPublishingStream();
    ZegoExpressEngine.instance.stopPreview();
  }

  // MARK: - Step 4: StartPlayingStream

  void startPlayingStream(String streamID,
      {double width = 360, double height = 640}) {
    void _startPlayingStream(int viewID, String streamID) {
      ZegoCanvas canvas = ZegoCanvas.view(viewID);
      canvas.viewMode = ZegoViewMode.AspectFill;
      ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
      print('📥 Start playing stream, streamID: $streamID, viewID: $viewID');
    }

    if (Platform.isIOS || Platform.isAndroid) {
      if (ZegoConfig.instance.enablePlatformView) {
        // Render with PlatformView
        setState(() {
          _playViewWidget =
              ZegoExpressEngine.instance.createPlatformView((viewID) {
            _playViewID = viewID;
            _startPlayingStream(viewID, streamID);
          });
        });
      } else {
        // Render with TextureRenderer
        ZegoExpressEngine.instance
            .createTextureRenderer(375, 720)
            .then((viewID) {
          _playViewID = viewID;
          setState(() => _playViewWidget = Texture(textureId: viewID));
          _startPlayingStream(viewID, streamID);
        });
      }
    } else {
      ZegoExpressEngine.instance.startPlayingStream(streamID);
    }
  }

  void stopPlayingStream(String streamID) {
    ZegoExpressEngine.instance.stopPlayingStream(streamID);

    clearPlayView();
  }

  // MARK: - Exit

  void destroyEngine() async {
    clearPreviewView();
    clearPlayView();

    // Can destroy the engine when you don't need audio and video calls
    //
    // Destroy engine will automatically logout room and stop publishing/playing stream.
    ZegoExpressEngine.destroyEngine()
        .then((ret) => print('already destroy engine'));

    print('🏳️ Destroy ZegoExpressEngine');

    // Notify View that engine state changed
    setState(() {
      _isEngineActive = false;
      _roomState = ZegoRoomState.Disconnected;
      _publisherState = ZegoPublisherState.NoPublish;
      _playerState = ZegoPlayerState.NoPlay;
    });
  }

  // MARK: - Zego Event

  void setZegoEventCallback() {
    ZegoExpressEngine.onRoomStateUpdate = (String roomID, ZegoRoomState state,
        int errorCode, Map<String, dynamic> extendedData) {
      print(
          '🚩 🚪 Room state update, state: $state, errorCode: $errorCode, roomID: $roomID');
      setState(() => _roomState = state);
    };
    ZegoExpressEngine.onRoomStreamUpdate = (String roomID,
        ZegoUpdateType updateType,
        List<ZegoStream> streamList,
        Map<String, dynamic> extendedData) {
      if (updateType == ZegoUpdateType.Add) {
        setState(() {
          _streamID = streamList[0].streamID;
        });
        startPlayingStream(_streamID);
      }
    };
    ZegoExpressEngine.onPublisherStateUpdate = (String streamID,
        ZegoPublisherState state,
        int errorCode,
        Map<String, dynamic> extendedData) {
      print(
          '🚩 📤 Publisher state update, state: $state, errorCode: $errorCode, streamID: $streamID');
      setState(() => _publisherState = state);
    };

    ZegoExpressEngine.onPlayerStateUpdate = (String streamID,
        ZegoPlayerState state,
        int errorCode,
        Map<String, dynamic> extendedData) {
      print(
          '🚩 📥 Player state update, state: $state, errorCode: $errorCode, streamID: $streamID');
      setState(() => _playerState = state);
    };
  }

  void clearZegoEventCallback() {
    ZegoExpressEngine.onRoomStateUpdate = null;
    ZegoExpressEngine.onPublisherStateUpdate = null;
    ZegoExpressEngine.onPlayerStateUpdate = null;
    ZegoExpressEngine.onIMRecvBroadcastMessage = null;
    ZegoExpressEngine.onIMRecvCustomCommand = null;
    ZegoExpressEngine.onIMRecvBarrageMessage = null;
  }

  void clearPreviewView() {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    if (_previewViewWidget == null) {
      return;
    }

    // Developers should destroy the [PlatformView] or [TextureRenderer] after
    // [stopPublishingStream] or [stopPreview] to release resource and avoid memory leaks
    if (ZegoConfig.instance.enablePlatformView) {
      ZegoExpressEngine.instance.destroyPlatformView(_previewViewID);
    } else {
      ZegoExpressEngine.instance.destroyTextureRenderer(_previewViewID);
    }
    setState(() => _previewViewWidget = null);
  }

  void clearPlayView() {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    if (_playViewWidget == null) {
      return;
    }

    // Developers should destroy the [PlatformView] or [TextureRenderer]
    // after [stopPlayingStream] to release resource and avoid memory leaks
    if (ZegoConfig.instance.enablePlatformView) {
      ZegoExpressEngine.instance.destroyPlatformView(_playViewID);
    } else {
      ZegoExpressEngine.instance.destroyTextureRenderer(_playViewID);
    }
    setState(() => _playViewWidget = null);
  }

  // MARK: Widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        '${userInfoMap['name']}患者',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: GestureDetector(
        child: mainContent(),
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      ),
    );
  }

  Widget mainContent() {
    return Column(children: [
      viewsWidget(),
      SafeArea(
          child: Container(
        decoration: BoxDecoration(color: ColorsUtil.hexStringColor('#333333')),
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 7.0, left: 17.0, right: 23.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MakePrescription(registeredId: regId)));
              },
              child: Column(
                children: <Widget>[
                  SvgUtil.svg('m_rp.svg'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '开处方',
                    style: GSYConstant.textStyle(),
                  )
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  _isEnableCamera = !_isEnableCamera;

                  setState(() {
                });
                isEnableCamera();
              },
              child: Column(
                children: <Widget>[
                  Image.asset(_isEnableCamera
                      ? 'assets/images/open_video.png'
                      : 'assets/images/close_video.png'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '开启视频',
                    style: GSYConstant.textStyle(),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_roomState == ZegoRoomState.Connected) {
                  logoutRoom();
                  Navigator.pop(context);
                }
              },
              child: SvgUtil.svg('close.svg'),
            ),
            GestureDetector(
              onTap: () {
                _isEnableMic = !_isEnableMic;

                setState(() {
                });
                isEnableMic();
              },
              child: Column(
                children: <Widget>[
                  Image.asset(_isEnableMic
                      ? 'assets/images/mute.png'
                      : 'assets/images/open_mute.png'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '静音',
                    style: GSYConstant.textStyle(),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isVisibility = !_isVisibility;
                });
              },
              child: Column(
                children: <Widget>[
                  SvgUtil.svg('more.svg'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '更多',
                    style: GSYConstant.textStyle(),
                  )
                ],
              ),
            ),
          ],
        ),
      ))
    ]);
  }

  Widget viewsWidget() {
    return Expanded(
      child: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: _playViewWidget,
          key: _playViewContainerKey,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            width: 104.0,
            height: 132.0,
            child: _previewViewWidget,
            key: _previewViewContainerKey,
          ),
        ),
        Positioned(
            top: 115.0,
            right: 26.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              decoration: BoxDecoration(
                  color: ColorsUtil.hexStringColor('#000000', alpha: 0.6)),
              child: Text(
                '医师:$docName',
                style: GSYConstant.textStyle(fontSize: 12.0),
              ),
            )),
        Positioned(
          right: 8.0,
          bottom: 4.0,
          child: Visibility(
            visible: _isVisibility,
            // maintainAnimation: true,
            // maintainSize: true,
            // maintainState: true,
            child: Container(
              width: 189.0,
              height: 79.0,
              padding: const EdgeInsets.only(left: 10.0, right: 17.0),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/video_more.png'))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WriteCase(
                                    registeredId: regId,
                                    userInfoMap: userInfoMap,
                                  )));
                    },
                    child: Column(
                      //     font-size: 14px;
                      // font-family: PingFangSC-Regular, PingFang SC;
                      // font-weight: 400;
                      // color: #FFFFFF;
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgUtil.svg('write_case.svg'),
                        const SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          '写病历',
                          style: GSYConstant.textStyle(),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      _isEnableSpeaker = !_isEnableSpeaker;
                      setState(() {

                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgUtil.svg('silence.svg'),
                        const SizedBox(
                          height: 7.0,
                        ),
                        Text(
                          '免提',
                          style: GSYConstant.textStyle(),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _isFrontCamera= !_isFrontCamera;
                      setState(() {

                      });
                      isTransformCamera();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgUtil.svg('transform.svg'),
                        const SizedBox(
                          height: 7.0,
                        ),
                        Text(
                          '切换',
                          style: GSYConstant.textStyle(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget stepOneCreateEngineWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step1:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(children: [
          Column(
            children: [
              Text('AppID: ${ZegoConfig.instance.appID}',
                  style: TextStyle(fontSize: 10)),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            child: CupertinoButton.filled(
              child: Text(
                _isEngineActive ? '✅ CreateEngine' : 'CreateEngine',
                style: TextStyle(fontSize: 18.0),
              ),
              onPressed: createEngine,
              padding: EdgeInsets.all(10.0),
            ),
          )
        ]),
        Divider(),
      ],
    );
  }

  Widget stepTwoLoginRoomWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Step2:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Row(children: [
        Column(
          children: [
            Text('RoomID: $_roomID', style: TextStyle(fontSize: 10)),
            Text('UserID: ${ZegoConfig.instance.userID}',
                style: TextStyle(fontSize: 10)),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: CupertinoButton.filled(
            child: Text(
              _roomState == ZegoRoomState.Connected
                  ? '✅ LoginRoom'
                  : 'LoginRoom',
              style: TextStyle(fontSize: 18.0),
            ),
            onPressed: _roomState == ZegoRoomState.Disconnected
                ? loginRoom
                : logoutRoom,
            padding: EdgeInsets.all(10.0),
          ),
        )
      ]),
    ]);
  }

  Widget stepThreeStartPublishingStreamWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Step3:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Row(children: [
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: TextField(
            controller: _publishingStreamIDController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                isDense: true,
                labelText: 'Publish StreamID:',
                labelStyle: TextStyle(color: Colors.black54, fontSize: 18.0),
                hintText: 'Please enter streamID',
                hintStyle: TextStyle(color: Colors.black26, fontSize: 10.0),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0e88eb)))),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: CupertinoButton.filled(
            child: Text(
              _publisherState == ZegoPublisherState.Publishing
                  ? '✅ StartPublishing'
                  : 'StartPublishing',
              style: TextStyle(fontSize: 18.0),
            ),
            onPressed: _publisherState == ZegoPublisherState.NoPublish
                ? () {
                    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
                    Size? widgetSize =
                        _previewViewContainerKey.currentContext?.size;
                    startPublishingStream(
                        _publishingStreamIDController.text.trim(),
                        width: widgetSize!.width * pixelRatio,
                        height: widgetSize.height * pixelRatio);
                  }
                : () {
                    stopPublishingStream();
                  },
            padding: EdgeInsets.all(10.0),
          ),
        )
      ]),
      Divider(),
    ]);
  }

  Widget stepFourStartPlayingStreamWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Step4:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Row(children: [
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: TextField(
            controller: _playingStreamIDController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                isDense: true,
                labelText: 'Play StreamID:',
                labelStyle: TextStyle(color: Colors.black54, fontSize: 18.0),
                hintText: 'Please enter streamID',
                hintStyle: TextStyle(color: Colors.black26, fontSize: 10.0),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0e88eb)))),
          ),
        ),
        Spacer(),
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: CupertinoButton.filled(
            child: Text(
              _playerState == ZegoPlayerState.Playing
                  ? '✅ StartPlaying'
                  : 'StartPlaying',
              style: TextStyle(fontSize: 18.0),
            ),
            onPressed: _playerState == ZegoPlayerState.NoPlay
                ? () {
                    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
                    Size? widgetSize =
                        _playViewContainerKey.currentContext?.size;
                    startPlayingStream(ZegoConfig.instance.userID,
                        width: widgetSize!.width * pixelRatio,
                        height: widgetSize.height * pixelRatio);
                  }
                : () {
                    stopPlayingStream(ZegoConfig.instance.userID);
                  },
            padding: EdgeInsets.all(10.0),
          ),
        )
      ]),
      Divider(),
    ]);
  }
}
