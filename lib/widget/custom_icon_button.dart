import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomIconButton extends StatelessWidget {
  const CustomIconButton({Key? key, required this.onPressed, required this.icon}) : super(key: key);
  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return  IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed:onPressed, icon: icon,);
  }
}
