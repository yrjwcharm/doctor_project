import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';

import '../common/style/gsy_style.dart';
import '../utils/common_utils.dart';
class PhotoViewPage extends StatefulWidget {
  const PhotoViewPage({Key? key, required this.url}) : super(key: key);
  final String url ;
  @override
  _PhotoViewPageState createState() => _PhotoViewPageState(this.url);
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  final String url;
  _PhotoViewPageState(this.url);
  @override
  void deactivate() {
    super.deactivate();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton:  FloatingActionButton(
      //   child:  Icon(Icons.file_download),
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
        appBar:CustomAppBar('图片预览',isRequired: false, leftIcon:'assets/images/icon_back.png',titleColor: '#ffffff', startColor: Colors.black,endColor: Colors.black,),
        body:  Container(
          color: Colors.black,
          child:  PhotoView(
              imageProvider: NetworkImage(url),
              loadingBuilder: (
                  BuildContext context,
                  ImageChunkEvent? event,
                  ) {
                return SizedBox(
                  child:  Stack(
                    children: <Widget>[
                      Center(
                          child:  Image.asset(GSYICons.DEFAULT_IMAGE,
                              height: 180.0, width: 180.0)),
                      const Center(
                          child:  SpinKitFoldingCube(
                              color: Colors.white30, size: 60.0)),
                    ],
                  ),
                );
              }),
        ));
  }
}

/**
 * 图片预览
 * Created by guoshuyu
 * Date: 2018-08-09
 */