import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/status_bar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
   CustomAppBar(this.title, {Key? key,this.onBackPressed,this.onForwardPressed,
    this.isBack=false, this.isForward=false,this.icon='', this.borderBottomWidth=1.0}) : super(key: key);
  final bool isBack;
  final String title;
  final bool isForward;
  final String icon;
  VoidCallback? onBackPressed;
  VoidCallback? onForwardPressed;
  final double borderBottomWidth;
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom:BorderSide(width: borderBottomWidth,color:ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)) )
      ),
      padding: EdgeInsets.only(top: StatusBarUtil.get(context)),
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child:Row(
                children: [
                  isBack?IconButton(onPressed: onBackPressed, icon:Image.asset('assets/images/back.png')):const Text(''),
                ],
              )),
            Text(
                title,
                style: GSYConstant.textStyle(fontSize: 16.0, color: '#333333'),
              ) ,
            Expanded(child:
            isForward?TextButton(onPressed: onForwardPressed, child:Image.asset(icon)):const Text('')
            )
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
