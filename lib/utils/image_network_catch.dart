import 'package:doctor_project/utils/svg_utils.dart';
import 'package:flutter/cupertino.dart';

class ImageNetWorkCatchUtil{
 static Widget buildImg(imgUrl) {
    Image image = Image.network(imgUrl);
    final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((_,__){}, onError: (exception,stackTrace) {
      print('enter onError start');
      print(exception);
      print(stackTrace);
      print('enter onError end');
    }));
    return image;
  }
}