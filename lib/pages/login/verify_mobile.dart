import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/api.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/login/verify_code.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/reg_util.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/text_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
class VerifyMobile extends StatefulWidget {
  const VerifyMobile({Key? key}) : super(key: key);

  @override
  _VerifyMobileState createState() => _VerifyMobileState();
}

class _VerifyMobileState extends State<VerifyMobile>  {
  final TextEditingController _textEditingController = TextEditingController();
  String phone='';
  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar('验证手机号',onBackPressed: (){
        Navigator.pop(context);
      },),
      body: Column(
        children: <Widget>[
           Container(
             alignment: Alignment.topLeft,
             margin: const EdgeInsets.only(top: 40.0,left: 16.0),
             child: Text('请输入您绑定的手机号',style: GSYConstant.textStyle(fontSize: 24.0,color: '#333333'),),
           ),
           Container(
             margin: const EdgeInsets.only(top: 33.0,left: 16.0,right: 16.0),
             padding: const EdgeInsets.symmetric(vertical: 12.0),
             decoration: BoxDecoration(
               border: Border(bottom: BorderSide(width: 1.0,color: ColorsUtil.hexStringColor('#cccccc')))
             ),
             child: Row(
               children: <Widget>[
                 Row(
                  children: <Widget>[
                     Text('+86',style: GSYConstant.textStyle(fontSize: 14.0,color: '#333333'),),
                     const SizedBox(width: 5.0,),
                     SvgUtil.svg('arrow_.svg')
                  ],
                ),
                Expanded(child: TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.number,
                  style: GSYConstant.textStyle(fontSize: 16.0,color: '#333333'),
                  cursorColor: ColorsUtil.hexStringColor('#333333'),
                  inputFormatters: <TextInputFormatter> [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged:(value){
                    setState(() {
                      phone = value;
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: '请输入手机号',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    border: InputBorder.none,
                    isDense: true,
                    suffixIconConstraints: const BoxConstraints(

                    ),

                    suffixIcon:_textEditingController.text.isNotEmpty?GestureDetector(
                      onTap: (){
                        _textEditingController.clear();
                      },
                      child: SvgUtil.svg('clear.svg'),
                    ):null,
                    hintStyle: GSYConstant.textStyle(color: '#999999',fontSize: 16.0)
                  ),
                ))
              ],
             ),
           ),
           Container(
             margin: const EdgeInsets.only(top: 138.0),
             padding: const EdgeInsets.symmetric(horizontal: 16.0),
             child: CustomElevatedButton(
                 borderRadius: BorderRadius.circular(22.0), title: '获取验证码', onPressed: () async{
                      if(!RegexUtil.isPhone(phone)){
                         ToastUtil.showToast(msg: '请输入手机号');
                         return;
                      }
                      var res = await HttpRequest.getInstance().get(Api.sendVerifyCode+'?phone=$phone&type=reset',
                          {});
                      if(res['code']==200){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> VerifyCode(phone: phone,)));
                      }
             }) ,
           )

        ],
      ),
    );
  }
}
