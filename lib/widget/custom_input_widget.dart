import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/material.dart';

/// 带图标的输入框
class CustomInputWidget extends StatefulWidget {
  final bool obscureText;

  final String? hintText;

  final IconData? iconData;

  final ValueChanged<String>? onChanged;

  final TextStyle? textStyle;
  final int? maxLines;
  final TextEditingController? controller;
  CustomInputWidget(
      {Key? key,
      this.hintText,
      this.iconData,
      required this.onChanged,
      this.textStyle,
      this.controller,
      this.obscureText = false, this.maxLines})
      : super(key: key);

  @override
  _CustomInputWidgetState createState() =>  _CustomInputWidgetState();
}

/// State for [CustomInputWidget] widgets.
class _CustomInputWidgetState extends State<CustomInputWidget> {

  @override
  Widget build(BuildContext context) {
    return  TextField(
       controller: widget.controller,
       onChanged: widget.onChanged,
        maxLines: widget.maxLines,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
            hintText: widget.hintText,
            // fillColor: Colors.transparent,
            // filled: true,
            icon: widget.iconData == null ? null :  Icon(widget.iconData),
            border:InputBorder.none,
            contentPadding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
            hintStyle: TextStyle(
                fontSize: 16.0,
            )
        ),
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 16.0, color: ColorsUtil.hexStringColor('#666666')),//输入文本的样式
        // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
        cursorColor: ColorsUtil.hexStringColor('#666666')
    );
  }
}
