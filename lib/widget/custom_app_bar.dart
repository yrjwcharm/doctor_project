import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/status_bar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
   CustomAppBar(this.title,
      {Key? key,
      this.onBackPressed,
      this.onForwardPressed,
      this.isBack = true,
      this.isForward = false,
      this.rightIcon = '',
      this.leftIcon = 'assets/images/back.png',
      this.titleColor = '#333333',
      this.startColor = Colors.white,
      this.endColor = Colors.white,
      this.child=const SizedBox.shrink(), this.border= const Border(bottom:BorderSide(width: 0.5,color: Color.fromRGBO(204, 204, 204,0.3))), this.padding =const EdgeInsets.only(right: 16.0)})
      : super(key: key);
  final bool isBack;
  final String title;
  final String titleColor;
  final bool isForward;
  final String leftIcon;
  final String rightIcon;
  final Color startColor;
  final Color endColor;
  final VoidCallback? onBackPressed;
  final VoidCallback? onForwardPressed;
  final BoxBorder? border;
  final Widget child;
   final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [startColor, endColor]),
          border:border),
      padding: EdgeInsets.only(top: StatusBarUtil.get(context)),
      child: Container(
        padding:const EdgeInsets.symmetric(horizontal: 16.0),
        height: 44,
        child: Row(
          children: [
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isBack
                    ? IconButton(
                        constraints: const BoxConstraints(
                          maxWidth: 9.0,
                          minHeight: 17.0
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).pop();
                          // });
                        },
                        icon: Image.asset(leftIcon))
                    : const SizedBox.shrink(),
              ],
            )),
            Text(
              title,
              style: GSYConstant.textStyle(fontSize: 16.0, color: titleColor),
            ),
            Expanded(
                child: isForward
                    ? Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize:Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: onForwardPressed,
                            child: child))
                    : const SizedBox.shrink())
          ],
        ),
      ),
    );
  }

  @override
  @override
  Size get preferredSize => const Size(100, 50);
}
