import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/style/gsy_style.dart';
import '../utils/colors_utils.dart';

class CustomTextFieldInput extends StatelessWidget {
  const CustomTextFieldInput({Key? key, required this.label, required this.hintText, this.keyboardType=TextInputType.text, required this.onChanged,  this.height=43.0, this.controller}) : super(key: key);
  final String label;
  final String hintText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final double height;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom:BorderSide(color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)))
      ),
      child: Row(
        children: <Widget>[
          Text(label,style: GSYConstant.textStyle(fontSize: 14.0,color: '#333333'),),
          Expanded(child:
          TextField(
            controller: controller,
            enableInteractiveSelection: false,
            keyboardType:keyboardType ,
            textAlign: TextAlign.end,
            onChanged: onChanged,
            inputFormatters: [],
            cursorColor:ColorsUtil.hexStringColor('#666666'),
            style: GSYConstant.textStyle(fontSize: 14.0,color: '#666666'),
            decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                contentPadding:  EdgeInsets.zero,
                hintText: hintText,
                hintStyle: GSYConstant.textStyle(fontSize: 14.0,color: '#999999'),
                border: InputBorder.none
            ),
          )
          )
        ],
      ),
    );
  }
}
