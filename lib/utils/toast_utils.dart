import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil{
  static showToast({required String msg}){
    Fluttertoast.showToast(msg:msg,toastLength: Toast.LENGTH_LONG,gravity:ToastGravity.CENTER, );
  }
}