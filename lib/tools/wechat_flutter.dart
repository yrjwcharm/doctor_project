export 'dart:ui';
export 'dart:async';
export 'package:flutter/services.dart';
export 'dart:io';
export 'package:dim/dim.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:connectivity/connectivity.dart';
export 'package:doctor_project/ui/bar/commom_bar.dart';
export 'package:doctor_project/config/const.dart';
export 'package:doctor_project/ui/button/commom_button.dart';
export 'package:doctor_project/generated/i18n.dart';
export 'package:doctor_project/ui/dialog/show_snack.dart';
export 'package:doctor_project/ui/dialog/show_toast.dart';
export 'package:doctor_project/ui/view/main_input.dart';
export 'package:doctor_project/config/contacts.dart';
export 'package:doctor_project/config/strings.dart';
export 'package:doctor_project/tools/shared_util.dart';
export 'package:doctor_project/ui/web/web_view.dart';
export 'package:doctor_project/ui/view/loading_view.dart';
export 'package:doctor_project/ui/view/image_view.dart';
export 'package:doctor_project/config/api.dart';
export 'package:doctor_project/http/req.dart';
export 'package:doctor_project/tools/data/data.dart';
export 'package:doctor_project/ui/view/null_view.dart';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:dim/dim.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Dim im = new Dim();

var subscription = Connectivity();

typedef Callback(data);

DefaultCacheManager cacheManager = new DefaultCacheManager();

const String defGroupAvatar =
    'http://www.flutterj.com/content/uploadfile/zidingyi/g.png';

const Color mainBGColor = Color.fromRGBO(240, 240, 245, 1.0);
