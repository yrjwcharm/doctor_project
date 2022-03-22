//
//  quick_start_page.dart
//  zego-express-example-topics-flutter
//
//  Created by Patrick Fu on 2020/12/04.
//  Copyright © 2020 Zego. All rights reserved.
//
import 'package:permission_handler/permission_handler.dart';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:zego_express_engine/zego_express_engine.dart';

import '../../config/zego_config.dart';

class VideoTopic extends StatefulWidget {
  VideoTopic({Key? key}) : super(key: key);

  @override
  _VideoTopicState createState() => _VideoTopicState();
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

  ZegoMediaPlayer? mediaPlayer;

  bool _isEngineActive = false;
  ZegoRoomState _roomState = ZegoRoomState.Disconnected;
  ZegoPublisherState _publisherState = ZegoPublisherState.NoPublish;
  ZegoPlayerState _playerState = ZegoPlayerState.NoPlay;

  final TextEditingController _publishingStreamIDController = TextEditingController();
  final TextEditingController _playingStreamIDController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    if (!_isMicrophonePermissionGranted||!_isCameraPermissionGranted) {
      requestPermission();
      // ZegoUtils.showAlert(context,
      //     'Microphone permission is not granted, please click the mic icon to request permission');
      return;
    }
    setZegoEventCallback();
    createEngine();
  }
  Future<void> muteMicrophone(bool mute) async {
    return await ZegoExpressEngine.instance.muteMicrophone(mute);
  }
  //关闭麦克风
  Future<void> muteSpeaker(bool mute) async {
    return await ZegoExpressEngine.instance.muteSpeaker(mute);
  }
  Future<void> useFrontCamera(bool enable, {ZegoPublishChannel? channel}) async {
    return await ZegoExpressEngine.instance.useFrontCamera(enable, channel: channel);
  }
  Future<void> requestPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus microphoneStatus = await Permission.microphone.request();
    setState(() => {
      _isCameraPermissionGranted = cameraStatus.isGranted,
      _isMicrophonePermissionGranted = microphoneStatus.isGranted
    });
    if(_isCameraPermissionGranted&&_isMicrophonePermissionGranted){
      setZegoEventCallback();
      createEngine();
    }
  }

  Future<void> requestMicrophonePermission() async {
    PermissionStatus microphoneStatus = await Permission.microphone.request();
    setState(() => _isMicrophonePermissionGranted = microphoneStatus.isGranted);
  }

  @override
  void dispose() {
    // Can destroy the engine when you don't need audio and video calls
    //
    // Destroy engine will automatically logout room and stop publishing/playing stream.
    ZegoExpressEngine.destroyEngine()
        .then((value) => print('async destroy success'));

    print('🏳️ Destroy ZegoExpressEngine');

    clearZegoEventCallback();

    super.dispose();
  }

  // MARK: - Step 1: CreateEngine

  void createEngine() {
    ZegoEngineProfile profile = ZegoEngineProfile(
        ZegoConfig.instance.appID, ZegoConfig.instance.scenario,
        appSign: ZegoConfig.instance.token,
        enablePlatformView: ZegoConfig.instance.enablePlatformView);
    ZegoExpressEngine.createEngineWithProfile(profile);

    // Notify View that engine state changed
    setState(() => _isEngineActive = true);

    ZegoExpressEngine.instance.getAudioConfig().then((value) => {
          if (_roomState == ZegoRoomState.Disconnected) {
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
    }catch(e){
      print("1111$e");
    }

    print('🚪 Start login room, roomID: $_roomID');
    if (_publisherState == ZegoPublisherState.NoPublish) {
      double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      Size? widgetSize = _previewViewContainerKey.currentContext?.size;
      startPublishingStream(_publishingStreamIDController.text.trim(),
          width: widgetSize!.width * pixelRatio,
          height: widgetSize.height * pixelRatio);
    } else {
      stopPublishingStream();
    }
    if (_playerState == ZegoPlayerState.NoPlay) {
      double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      Size? widgetSize = _playViewContainerKey.currentContext?.size;
      startPlayingStream(_playingStreamIDController.text.trim(),
          width: widgetSize!.width * pixelRatio,
          height: widgetSize.height * pixelRatio);
    } else {
      stopPlayingStream(_playingStreamIDController.text.trim());
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
            .createTextureRenderer(width.toInt(), height.toInt())
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
        '刘猛患者',
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
      Expanded(
        child: Column(
          children: <Widget>[
            viewsWidget(),
          ],
        ),
      ),
      // stepOneCreateEngineWidget(),
      // stepTwoLoginRoomWidget(),
      // stepThreeStartPublishingStreamWidget(),
      // stepFourStartPlayingStreamWidget(),
      // Padding(padding: const EdgeInsets.only(bottom: 20.0)),
      // CupertinoButton.filled(
      //   child: Text(
      //     'DestroyEngine',
      //     style: TextStyle(fontSize: 18.0),
      //   ),
      //   onPressed: destroyEngine,
      //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      // )
      Container(
        decoration: BoxDecoration(color: ColorsUtil.hexStringColor('#333333')),
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 7.0, left: 17.0, right: 23.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Column(
                children: <Widget>[
                  SvgUtil.svg('m_rp.svg'),
                  SizedBox(
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
              onTap: () {},
              child: Column(
                children: <Widget>[
                  SvgUtil.svg('video_.svg'),
                  SizedBox(
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
                }
              },
              child: SvgUtil.svg('close.svg'),
            ),
            GestureDetector(
              onTap: () {},
              child: Column(
                children: <Widget>[
                  SvgUtil.svg('silence.svg'),
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
              onTap: () {},
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
      )
    ]);
  }

  Widget viewsWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.65,
      child: GridView(
        // padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // mainAxisSpacing: 10.0,
          // crossAxisSpacing: 0,
          // childAspectRatio: 1,
        ),
        children: [
          Stack(children: [
            Container(
              color: Colors.black,
              child: _previewViewWidget,
              key: _previewViewContainerKey,
            ),
          ]),
          // Stack(children: [
          //   Container(
          //     color: Colors.red,
          //     child: _playViewWidget,
          //     key: _playViewContainerKey,
          //   ),
          //   Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 7.0),
          //     decoration: BoxDecoration(
          //       color: ColorsUtil.hexStringColor('#000000',alpha: 0.6)
          //     ),
          //     child: Text('医师 王建国',style: GSYConstant.textStyle(fontSize: 12.0),),
          //   )
          // ], alignment: Alignment.topCenter),
        ],
      ),
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
                    startPlayingStream(_playingStreamIDController.text.trim(),
                        width: widgetSize!.width * pixelRatio,
                        height: widgetSize.height * pixelRatio);
                  }
                : () {
                    stopPlayingStream(_playingStreamIDController.text.trim());
                  },
            padding: EdgeInsets.all(10.0),
          ),
        )
      ]),
      Divider(),
    ]);
  }
}
