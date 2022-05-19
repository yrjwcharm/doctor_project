import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'case_template.dart';

class WriteCaseDetail extends StatefulWidget {

  Map dataMap ;
  WriteCaseDetail({Key? key, required this.dataMap}) : super(key: key);

  @override
  _WriteCaseDetailState createState() => _WriteCaseDetailState(dataMap :this.dataMap);
}

class _WriteCaseDetailState extends State<WriteCaseDetail> {

  Map dataMap ;
  _WriteCaseDetailState({required this.dataMap});

  final TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(dataMap["name"],onBackPressed: (){
        Navigator.pop(context);
      },),
      body:Container(
        color: ColorsUtil.bgColor,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 260,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        dataMap["name"] +'：',
                        style: GSYConstant.textStyle(fontSize:16.0,color: '#333333'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                          child: TextField(
                            controller: _editingController,
                            inputFormatters: [],
                            maxLines: 8,
                            maxLength:500,
                            textInputAction: TextInputAction.done,
                            cursorColor: ColorsUtil.hexStringColor('#666666'),
                            style: GSYConstant.textStyle(color: '#666666'),
                            decoration: InputDecoration(
                                hintText: '请输入内容...',
                                isCollapsed: true,
                                hintStyle: GSYConstant.textStyle(color: '#999999'),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero),
                          )),
                      const SizedBox(
                        width: 16.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            SafeArea(child:
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 40.0,
              child: ElevatedButton(
                style:ElevatedButton.styleFrom(
                    primary: ColorsUtil.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))
                ),
                onPressed: () {
                  // Navigator.of(context).pop();
                  // _editingController.text = dataMap["detail"].isNotEmpty ? dataMap["detail"] : "";
                  if(_editingController.text.isNotEmpty){

                    dataMap["detail"] = _editingController.text;
                    Navigator.of(context).pop(dataMap);
                  }else{
                    Navigator.of(context).pop();
                  }
                },
                child: Text('保存',style: GSYConstant.textStyle(fontSize: 16.0),),),
            ),),

          ],
        ),
      ),
    );
  }
}
