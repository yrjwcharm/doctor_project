import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:math' show Random;

import 'package:zego_express_engine/zego_express_engine.dart' show ZegoScenario;

class ZegoConfig {
  static final ZegoConfig instance = ZegoConfig._internal();
  ZegoConfig._internal();

  // ----- Persistence params -----
  int appID = 1762425862;
  ZegoScenario scenario = ZegoScenario.General;

  bool enablePlatformView = false;

  String userID = "";
  String userName = "";
  String token='';
  String roomID = "";
  String streamID = "";

  // ----- Short-term params -----

  bool isPreviewMirror = true;
  bool isPublishMirror = false;

  bool enableHardwareEncoder = false;

}
