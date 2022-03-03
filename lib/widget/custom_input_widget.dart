import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/material.dart';

/// 带图标的输入框
class CustomInputWidget extends StatefulWidget {
  final bool obscureText;
  final double radius;
  final String? hintText;
  final TextStyle? hintStyle;
  final IconData? iconData;

  final ValueChanged<String>? onChanged;

  final TextStyle? textStyle;
  final int? maxLines;
  final TextEditingController? controller;
  final double left;
  CustomInputWidget(
      {Key? key,
      required this.hintText,
      this.iconData,
      this.radius=5.0,
      required this.onChanged,
      required this.textStyle,
      this.controller, this.left=16.0,
      this.obscureText = false, this.maxLines, this.hintStyle})
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
            fillColor: Colors.red,//背景颜色，必须结合filled: true,才有效
            filled: true,//重点，必须设置为true，fillColor才有效
            icon: widget.iconData == null ? null :  Icon(widget.iconData),
            border:OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide(
                width: 1,
                color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
            hintStyle: widget.hintStyle
        ),
        textDirection: TextDirection.ltr,
        style: widget.textStyle,//输入文本的样式
        // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//允许的输入格式
        cursorColor: ColorsUtil.hexStringColor('#666666')
    );
  }
}
