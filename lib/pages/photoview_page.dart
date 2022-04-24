import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';

import '../common/style/gsy_style.dart';
import '../utils/common_utils.dart';

/**
 * 图片预览
 * Created by guoshuyu
 * Date: 2018-08-09
 */

class PhotoViewPage extends StatelessWidget {

  PhotoViewPage(this.url);
  final String url ;
  @override
  Widget build(BuildContext context) {
    // final String? url = ModalRoute.of(context)!.settings.arguments as String?;
    return new Scaffold(
        // floatingActionButton: new FloatingActionButton(
        //   child: new Icon(Icons.file_download),
        //   onPressed: () {
        //     // CommonUtils.saveImage(url).then((res) {
        //     //   if (res != null) {
        //     //     Fluttertoast.showToast(msg: res);
        //     //     if (Platform.isAndroid) {
        //     //       const updateAlbum = const MethodChannel(
        //     //           'com.shuyu.gsygithub.gsygithubflutter/UpdateAlbumPlugin');
        //     //       updateAlbum.invokeMethod('updateAlbum', {
        //     //         'path': res,
        //     //         'name': CommonUtils.splitFileNameByPath(res)
        //     //       });
        //     //     }
        //     //   }
        //     // });
        //   },
        // ),
        // appBar:CustomAppBar('图片预览',onBackPressed: (){
        //   Navigator.pop(context);
        // },),
        body: new Container(
          color: Colors.black,
          child: new PhotoView(
              imageProvider:
                  new NetworkImage(url),
              loadingBuilder: (
                BuildContext context,
                ImageChunkEvent? event,
              ) {
                return Container(
                  child: new Stack(
                    children: <Widget>[
                      new Center(
                          child: new Image.asset(GSYICons.DEFAULT_IMAGE,
                              height: 180.0, width: 180.0)),
                      new Center(
                          child: new SpinKitFoldingCube(
                              color: Colors.white30, size: 60.0)),
                    ],
                  ),
                );
              }),
        ));
  }
}