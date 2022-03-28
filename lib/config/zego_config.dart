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

  String userID = "123";
  String userName = "闫瑞锋";
  String token='03AAAAAGI64McAEDdvZ3JkcGFxYXJpcTRnZ2cAoNXS8s222fs6FXrMlJId9JNu7bKKT/rx+SsfbW55vBc2uDLrlHu6nLakbyPGcXfZ1hCCiSMBCwnzwIk8c2FbPg78TIjCxXk2LMIz1AoySEFNB6xvfzb1f63lDjVjHE7PQnd61dA3tNMu9aP03Ntgc6KsPobgQUndqEzIJvaAD+dMqO8EBUFEN7QUWj22IMefhfyKAFqanTMkg5qEs2nyD9w=';
  String roomID = "123";
  String streamID = "";

  // ----- Short-term params -----

  bool isPreviewMirror = true;
  bool isPublishMirror = false;

  bool enableHardwareEncoder = false;

}
