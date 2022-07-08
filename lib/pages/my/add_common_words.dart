import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_safeArea_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../http/api.dart';

class AddCommonWords extends StatefulWidget {
   String doctorId;
   String id;
   String remark='';
  AddCommonWords({Key? key,required this.doctorId, required this.id, this.remark=''}) : super(key: key);

  @override
  _AddCommonWordsState createState() => _AddCommonWordsState(this.doctorId,this.id,this.remark);
}

class _AddCommonWordsState extends State<AddCommonWords> {
  String doctorId;
  String remark='';
  String id;
  final TextEditingController _editingController = TextEditingController();
  _AddCommonWordsState(this.doctorId,this.id,this.remark);

  @override
  Widget build(BuildContext context) {
    _editingController.value = TextEditingValue(
        text: remark,
        selection: TextSelection.fromPosition(
            TextPosition(
                affinity: TextAffinity.downstream,
                offset: remark.length)));
    return Scaffold(
      appBar: CustomAppBar(
        id.isEmpty?'添加常用语':'修改常用语',
        // onBackPressed: () {
        //   Navigator.pop(context);
        // },
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
            Expanded(child:
             TextField(
              maxLines: 5,
              controller:_editingController ,
              inputFormatters: [],
              onChanged: (value){
                remark = value;
                setState(() {

                });
              },
               maxLength: 200,
              cursorColor: ColorsUtil.hexStringColor('#666666'),
              style: GSYConstant.textStyle(fontSize: 14.0, color: '#666666'),
              decoration: InputDecoration(
                  hintText: '请输入您的常用回复，请不要填写QQ、微信等联系方式或广告信息，否则系统将封禁您的账号',
                  // fillColor: Colors.transparent,
                  // filled: true,
                  counterText: remark.length.toString()+'/'+'200',
                  contentPadding: const EdgeInsets.only(left: 16.0,top: 16.0,right: 16.0),
                  border: InputBorder.none,
                  hintStyle:
                      GSYConstant.textStyle(fontSize: 14.0, color: '#999999')),
            ),),
           CustomSafeAreaButton(
             margin: const EdgeInsets.only(bottom: 16.0),
             onPressed: () async{
               if(remark.isEmpty){
                 ToastUtil.showToast(msg: '请输入常用语回复');
                 return;
               }
               if(id.isEmpty) {
                 var res = await HttpRequest.getInstance().post(
                     Api.addCommonWordsListApi,
                     {
                       "doctorId": doctorId, //测试使用
                       "remark":remark //常用语
                     });
                 if (res['code'] == 200) {
                   Navigator.pop(context);
                 }
               }else{
                 var res = await HttpRequest.getInstance().post(Api.updateCommonWordsApi,
                     {
                       "id": id, //模版id
                       "doctorId": doctorId, //测试使用
                       "remark": remark //常用语
                     });
                 if(res['code']==200){
                   Navigator.of(context).pop();
                 }else{
                   ToastUtil.showToast(msg: res['msg']);
                 }
               }
           },title: '保存',)
        ],
      ),
    );
  }
}
