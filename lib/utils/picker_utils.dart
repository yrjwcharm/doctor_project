import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';

import '../common/style/gsy_style.dart';

class PickerUtil{
  static showPicker(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey,{required List pickerData,required PickerConfirmCallback confirmCallback}){
    Picker picker = Picker(
        headerDecoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)))
        ),
        adapter: PickerDataAdapter<String>(pickerdata: pickerData),
        changeToFirst: false,
        confirmText: '确定',
        cancelText: '取消',
        confirmTextStyle: GSYConstant.textStyle(fontSize: 16.0,color: '#06B48D'),
        cancelTextStyle: GSYConstant.textStyle(fontSize: 16.0,color: '#666666'),
        textAlign: TextAlign.left,
        textStyle: GSYConstant.textStyle(fontSize: 15.0, color: '#333333'),
        selectedTextStyle:
        GSYConstant.textStyle(fontSize: 15.0, color: '#06B48D'),
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm:confirmCallback);
    // picker.show(_scaffoldKey.currentState!);
    picker.showModal(context);
  }
}