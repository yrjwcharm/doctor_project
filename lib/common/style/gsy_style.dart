import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/material.dart';

///颜色
class GSYColors {
  static const int primaryIntValue = 0xFF24292E;

  static const MaterialColor primarySwatch = const MaterialColor(
    primaryIntValue,
    const <int, Color>{
      50: const Color(primaryIntValue),
      100: const Color(primaryIntValue),
      200: const Color(primaryIntValue),
      300: const Color(primaryIntValue),
      400: const Color(primaryIntValue),
      500: const Color(primaryIntValue),
      600: const Color(primaryIntValue),
      700: const Color(primaryIntValue),
      800: const Color(primaryIntValue),
      900: const Color(primaryIntValue),
    },
  );

  static const String primaryValueString = "#24292E";
  static const String primaryLightValueString = "#42464b";
  static const String primaryDarkValueString = "#121917";
  static const String miWhiteString = "#ececec";
  static const String actionBlueString = "#267aff";
  static const String webDraculaBackgroundColorString = "#282a36";

  static const Color primaryValue = Color(0xFF24292E);
  static const Color primaryLightValue = Color(0xFF42464b);
  static const Color primaryDarkValue = Color(0xFF121917);

  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color miWhite = Color(0xffececec);
  static const Color white = Color(0xFFFFFFFF);
  static const Color actionBlue = Color(0xff267aff);
  static const Color subTextColor = Color(0xff959595);
  static const Color subLightTextColor = Color(0xffc4c4c4);

  static const Color mainBackgroundColor = miWhite;

  static const Color mainTextColor = primaryDarkValue;
  static const Color textColorWhite = white;
}

///文本样式
class GSYConstant {
  static const String app_default_share_url =
      "https://github.com/CarGuo/gsy_github_app_flutter";
  static const  fontFamily = 'Regular';
  static  textStyle({double fontSize=14.0,List<Shadow>? shadows, double? lineHeight,String color='#ffffff',String fontFamily=GSYConstant.fontFamily,FontWeight fontWeight=FontWeight.w400}) {
    return  TextStyle(
      color: ColorsUtil.hexStringColor(color),
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      height: lineHeight,
      shadows:shadows,
    );
  }
}

class GSYICons {
  static const String FONT_FAMILY = 'wxcIconFont';

  static const String DEFAULT_USER_ICON = 'assets/images/logo.png';
  static const String DEFAULT_IMAGE = 'assets/images/default_img.png';
  static const String DEFAULT_REMOTE_PIC =
      'http://img.cdn.guoshuyu.cn/gsy_github_app_logo.png';
}
