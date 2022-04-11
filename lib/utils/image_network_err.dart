import 'package:doctor_project/utils/svg_utils.dart';
import 'package:flutter/cupertino.dart';

class NetWorkImageUtil{
  static Widget? buildImg(photo,) {
      Image image = Image.network(photo??'');
      final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
      stream.addListener(ImageStreamListener((_, __) {}, onError: (_, __) {
        print('走回调了');
      }));
      return image;
  }
}