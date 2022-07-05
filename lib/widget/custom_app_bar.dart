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
      this.child,  this.isRequired=true,})
      : super(key: key);
  final bool isBack;
  final String title;
  final String titleColor;
  final bool isForward;
  final String leftIcon;
  final String rightIcon;
  final Color startColor;
  final Color endColor;
  final bool isRequired;
  VoidCallback? onBackPressed;
  VoidCallback? onForwardPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [startColor, endColor]),
          border:isRequired? Border(
              bottom: BorderSide(
                  width: 1.0,
                  color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3))):const Border.fromBorderSide(BorderSide.none)),
      padding: EdgeInsets.only(top: StatusBarUtil.get(context)),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isBack
                    ? IconButton(
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
                        padding: const EdgeInsets.only(right: 16.0),
                        child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: onForwardPressed,
                            child: child!))
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
