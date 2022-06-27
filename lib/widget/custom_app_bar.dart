import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/status_bar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
   CustomAppBar(this.title, {Key? key,this.onBackPressed,this.onForwardPressed,
    this.isBack=true, this.isForward=false,this.rightIcon='', this.borderBottomWidth=1.0, this.leftIcon='assets/images/back.png', this.titleColor='#333333', this.startColor=Colors.white, this.endColor=Colors.white, this.child}) : super(key: key);
  final bool isBack;
  final String title;
  final String titleColor;
  final bool isForward;
  final String leftIcon;
  final String rightIcon;
  final Color startColor;
  final Color endColor;
  VoidCallback? onBackPressed;
  VoidCallback? onForwardPressed;
  final double borderBottomWidth;
  final Widget? child;
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          gradient:  LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              startColor,
              endColor
            ]
          ),
          border: Border(bottom:BorderSide(width: borderBottomWidth,color:ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)) )
      ),
      padding: EdgeInsets.only(top: StatusBarUtil.get(context)),
      child: SizedBox(
        height: 44,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  isBack?IconButton(
                      padding:EdgeInsets.zero,
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon:Image.asset(leftIcon)
                  ):const Text(''),
                ],
              )),
            Text(
                title,
                style: GSYConstant.textStyle(fontSize: 16.0, color: titleColor),
              ) ,
            Expanded(child:
            isForward?Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16.0),
                child:TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: onForwardPressed, child:child!)
            ):const SizedBox(child:Text(''))
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  @override
  Size get preferredSize => const Size(100, 50);
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
