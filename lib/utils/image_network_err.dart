import 'package:flutter/cupertino.dart';

class NetWorkImageUtil{
  static Widget? buildImg(photo) {
    Image image = Image.network(photo);
    final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((_, __) {}, onError: (_, __) {
      print('走回掉了');
    }));
    return image;
  }
}