import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/**
 * 通用逻辑
 * Created by guoshuyu
 * Date: 2018-07-16
 */

typedef StringList = List<String>;

class CommonUtils {
  static final double MILLIS_LIMIT = 1000.0;

  static final double SECONDS_LIMIT = 60 * MILLIS_LIMIT;

  static final double MINUTES_LIMIT = 60 * SECONDS_LIMIT;

  static final double HOURS_LIMIT = 24 * MINUTES_LIMIT;

  static final double DAYS_LIMIT = 30 * HOURS_LIMIT;

  static Locale? curLocale;

  static String getDateStr(DateTime? date) {
    if (date == null || date.toString() == "") {
      return "";
    } else if (date.toString().length < 10) {
      return date.toString();
    }
    return date.toString().substring(0, 10);
  }
  ///日期格式转换
  static String getNewsTimeStr(DateTime date) {
    int subTimes =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (subTimes < MILLIS_LIMIT) {
      return (curLocale != null)
          ? (curLocale!.languageCode != "zh")
              ? "right now"
              : "刚刚"
          : "刚刚";
    } else if (subTimes < SECONDS_LIMIT) {
      return (subTimes / MILLIS_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " seconds ago"
                  : " 秒前"
              : " 秒前");
    } else if (subTimes < MINUTES_LIMIT) {
      return (subTimes / SECONDS_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " min ago"
                  : " 分钟前"
              : " 分钟前");
    } else if (subTimes < HOURS_LIMIT) {
      return (subTimes / MINUTES_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " hours ago"
                  : " 小时前"
              : " 小时前");
    } else if (subTimes < DAYS_LIMIT) {
      return (subTimes / HOURS_LIMIT).round().toString() +
          ((curLocale != null)
              ? (curLocale!.languageCode != "zh")
                  ? " days ago"
                  : " 天前"
              : " 天前");
    } else {
      return getDateStr(date);
    }
  }

  static getLocalPath() async {
    Directory? appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getExternalStorageDirectory();
    }

    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      if (statuses[Permission.storage] != PermissionStatus.granted) {
        return null;
      }
    }
    String appDocPath = appDir!.path + "/gsygithubappflutter";
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath;
  }

  static getApplicationDocumentsPath() async {
    Directory appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getApplicationSupportDirectory();
    }
    String appDocPath = appDir.path + "/gsygithubappflutter";
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath.path;
  }

  static String? removeTextTag(String? description) {
    if (description != null) {
      String reg = "<g-emoji.*?>.+?</g-emoji>";
      RegExp tag = new RegExp(reg);
      Iterable<Match> tags = tag.allMatches(description);
      for (Match m in tags) {
        String match = m
            .group(0)!
            .replaceAll(new RegExp("<g-emoji.*?>"), "")
            .replaceAll(new RegExp("</g-emoji>"), "");
        description = description!.replaceAll(new RegExp(m.group(0)!), match);
      }
    }
    return description;
  }

  /*static saveImage(String url) async {
    Future<String> _findPath(String imageUrl) async {
      final file = await Cache.DefaultCacheManager().getSingleFile(url);
      if (file == null) {
        return null;
      }
      Directory localPath = await CommonUtils.getLocalPath();
      if (localPath == null) {
        return null;
      }
      final name = splitFileNameByPath(file.path);
      final result = await file.copy(localPath.path + name);
      return result.path;
    }

    return _findPath(url);
  }*/

  static splitFileNameByPath(String path) {
    return path.substring(path.lastIndexOf("/"));
  }

  static getFullName(String? repository_url) {
    if (repository_url != null &&
        repository_url.substring(repository_url.length - 1) == "/") {
      repository_url = repository_url.substring(0, repository_url.length - 1);
    }
    String fullName = '';
    if (repository_url != null) {
      StringList splicurl = repository_url.split("/");
      if (splicurl.length > 2) {
        fullName =
            splicurl[splicurl.length - 2] + "/" + splicurl[splicurl.length - 1];
      }
    }
    return fullName;
  }
  static getThemeData(Color color) {
    return ThemeData(
      primarySwatch: color as MaterialColor?,
      platform: TargetPlatform.android,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarContrastEnforced: true,
          systemStatusBarContrastEnforced: true,
          systemNavigationBarColor: color,
          statusBarColor: color,
          systemNavigationBarDividerColor: color.withAlpha(199),
        ),
      ),
      // 如果需要去除对应的水波纹效果
      // splashFactory: NoSplash.splashFactory,
      // textButtonTheme: TextButtonThemeData(
      //   style: ButtonStyle(splashFactory: NoSplash.splashFactory),
      // ),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ButtonStyle(splashFactory: NoSplash.splashFactory),
      // ),
    );
  }
  ///获取设备信息
  static Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return "";
    }
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.model;
  }


  static const IMAGE_END = [".png", ".jpg", ".jpeg", ".gif", ".svg"];

  static isImageEnd(path) {
    bool image = false;
    for (String item in IMAGE_END) {
      if (path.indexOf(item) + item.length == path.length) {
        image = true;
      }
    }
    return image;
  }

  // static void launchWebView(BuildContext context, String? title, String url) {
  //   if (url.startsWith("http")) {
  //     NavigatorUtils.goGSYWebView(context, url, title);
  //   } else {
  //     NavigatorUtils.goGSYWebView(
  //         context,
  //         new Uri.dataFromString(url,
  //                 mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
  //             .toString(),
  //         title);
  //   }
  // }


  // static Future<Null> showLoadingDialog(BuildContext context) {
  //   return NavigatorUtils.showGSYDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return new Material(
  //             color: Colors.transparent,
  //             child: WillPopScope(
  //               onWillPop: () => new Future.value(false),
  //               child: Center(
  //                 child: new Container(
  //                   width: 200.0,
  //                   height: 200.0,
  //                   padding: new EdgeInsets.all(4.0),
  //                   decoration: new BoxDecoration(
  //                     color: Colors.transparent,
  //                     //用一个BoxDecoration装饰器提供背景图片
  //                     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //                   ),
  //                   child: new Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       new Container(
  //                           child: SpinKitCubeGrid(color: GSYColors.white)),
  //                       new Container(height: 10.0),
  //                       new Container(
  //                           child: new Text(
  //                               GSYLocalizations.i18n(context)!.loading_text,
  //                               style: GSYConstant.normalTextWhite)),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ));
  //       });
  // }
  //
  // static Future<Null> showEditDialog(
  //   BuildContext context,
  //   String dialogTitle,
  //   ValueChanged<String>? onTitleChanged,
  //   ValueChanged<String> onContentChanged,
  //   VoidCallback onPressed, {
  //   TextEditingController? titleController,
  //   TextEditingController? valueController,
  //   bool needTitle = true,
  // }) {
  //   return NavigatorUtils.showGSYDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Center(
  //           child: new IssueEditDialog(
  //             dialogTitle,
  //             onTitleChanged,
  //             onContentChanged,
  //             onPressed,
  //             titleController: titleController,
  //             valueController: valueController,
  //             needTitle: needTitle,
  //           ),
  //         );
  //       });
  // }
  //
  // ///列表item dialog
  // static Future<Null> showCommitOptionDialog(
  //   BuildContext context,
  //   List<String?>? commitMaps,
  //   ValueChanged<int> onTap, {
  //   width = 250.0,
  //   height = 400.0,
  //   List<Color>? colorList,
  // }) {
  //   return NavigatorUtils.showGSYDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Center(
  //           child: new Container(
  //             width: width,
  //             height: height,
  //             padding: new EdgeInsets.all(4.0),
  //             margin: new EdgeInsets.all(20.0),
  //             decoration: new BoxDecoration(
  //               color: GSYColors.white,
  //               //用一个BoxDecoration装饰器提供背景图片
  //               borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //             ),
  //             child: new ListView.builder(
  //                 itemCount: commitMaps?.length ?? 0,
  //                 itemBuilder: (context, index) {
  //                   return GSYFlexButton(
  //                     maxLines: 1,
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     fontSize: 14.0,
  //                     color: colorList != null
  //                         ? colorList[index]
  //                         : Theme.of(context).primaryColor,
  //                     text: commitMaps![index],
  //                     textColor: GSYColors.white,
  //                     onPress: () {
  //                       Navigator.pop(context);
  //                       onTap(index);
  //                     },
  //                   );
  //                 }),
  //           ),
  //         );
  //       });
  // }
  //
  // ///版本更新
  // static Future<Null> showUpdateDialog(
  //     BuildContext context, String contentMsg) {
  //   return NavigatorUtils.showGSYDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: new Text(GSYLocalizations.i18n(context)!.app_version_title),
  //           content: new Text(contentMsg),
  //           actions: <Widget>[
  //             new TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: new Text(GSYLocalizations.i18n(context)!.app_cancel)),
  //             new TextButton(
  //                 onPressed: () {
  //                   launch(Address.updateUrl);
  //                   Navigator.pop(context);
  //                 },
  //                 child: new Text(GSYLocalizations.i18n(context)!.app_ok)),
  //           ],
  //         );
  //       });
  // }
}
