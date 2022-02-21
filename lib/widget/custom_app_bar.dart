import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/status_bar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(this.title, {Key? key, this.isBack=false, this.isForward=false,this.icon=''}) : super(key: key);
  final bool isBack;
  final String title;
  final bool isForward;
  final String icon;
  @override
  Widget build(BuildContext context) {
    _back() {
      Navigator.pop(context);
    }
    _forward(){

    }
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: StatusBarUtil.get(context)),
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isBack?IconButton(onPressed: _back, icon: Image.asset('static/images/back.png')):const Text(''),
            Text(
              title,
              style: GSYConstant.textStyle(fontSize: 16.0, color: '#333333'),
            ),
            TextButton(onPressed: _forward, child:isForward?Image.asset(icon):const Text(''))
          ],
        ),
      ),
    );
  }
}


// class AppBarUtil {
//   static AppBar buildAppBar(BuildContext context, String title) {
//     return AppBar(
//       title: Text(title),
//       titleTextStyle: TextStyle(
//         fontSize: 16.0,
//         fontFamily: 'PingFangSC-Regular, PingFang SC',
//         fontWeight: FontWeight.w400,
//         color: ColorsUtil.hexStringColor('#333333'),
//         //   font-family: PingFangSC-Regular, PingFang SC;
//         // font-weight: 400;
//         // color: #333333;
//       ),
//       backgroundColor: Colors.white,
//     );
//   }
// }
