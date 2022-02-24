import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/status_bar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
   CustomAppBar(this.title, {Key? key,this.onBackPressed,this.onForwardPressed,
    this.isBack=true, this.isForward=false,this.rightIcon='', this.borderBottomWidth=1.0, this.color=Colors.white, this.leftIcon='assets/images/back.png', this.titleColor='#333333'}) : super(key: key);
  final bool isBack;
  final Color color;
  final String title;
  final String titleColor;
  final bool isForward;
  final String leftIcon;
  final String rightIcon;
  VoidCallback? onBackPressed;
  VoidCallback? onForwardPressed;
  final double borderBottomWidth;
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          color: color,
          gradient: const LinearGradient(
            colors: [
              Colors.white,
              Colors.white
            ]
          ),
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
                  isBack?IconButton(onPressed: onBackPressed, icon:Image.asset(leftIcon)):const Text(''),
                ],
              )),
            Text(
                title,
                style: GSYConstant.textStyle(fontSize: 16.0, color: titleColor),
              ) ,
            Expanded(child:
            isForward?TextButton(onPressed: onForwardPressed, child:Image.asset(rightIcon)):const Text('')
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
