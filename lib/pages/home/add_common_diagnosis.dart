import 'package:creator/creator.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/creator/logic.dart';
import '../../common/style/gsy_style.dart';
import '../../http/api.dart';
import '../../utils/svg_util.dart';
import '../../utils/toast_util.dart';
import '../../widget/custom_safeArea_button.dart';
import '../../widget/custom_textField_input.dart';
import '../my/choice_department.dart';

class AddCommonDiagnosis extends StatefulWidget {
  const AddCommonDiagnosis({Key? key, required this.diagnosisList}) : super(key: key);
  final List diagnosisList;
  @override
  _AddCommonDiagnosisState createState() => _AddCommonDiagnosisState(this.diagnosisList);
}

class _AddCommonDiagnosisState extends State<AddCommonDiagnosis> {
  String templateName='';
  String department='';
  String departmentId='';
  List diagnosisList =[];
  _AddCommonDiagnosisState(this.diagnosisList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar('常用诊断模板'),
      body: Column(
        children: <Widget>[
          Expanded(child: Column(
              children: <Widget>[
                CustomTextFieldInput(
                    // controller: _editingController,
                    label: '模板名称',
                    hintText:'请输入模板名称',
                    onChanged: (value) {
                      setState(() {
                        templateName = value;
                      });
                    }),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChoiceDepartment())).then((item) => {
                      setState((){
                        department = item.deptName;
                        departmentId = item.deptId;
                      })
                    });
                  },
                  child: Container(
                    height: 43.0,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '科室选择',
                          style: GSYConstant.textStyle(color: '#333333'),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              department.isEmpty?'请选择科室':department,
                              style: GSYConstant.textStyle(color: '#999999'),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            SvgUtil.svg('forward_arrow.svg')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomSafeAreaButton(
            margin: const EdgeInsets.only(bottom: 16.0),
            onPressed: () async{
              String doctorId = context.ref.read(docIdCreator);
              if (templateName.isEmpty) {
                ToastUtil.showToast(msg: '请输入模板名称');
                return;
              }
              if (department.isEmpty) {
                ToastUtil.showToast(msg: '请选择科室');
                return;
              }
              if (diagnosisList.isEmpty) {
                ToastUtil.showToast(msg: '请添加诊断');
                return;
              }
              List list =[];
              diagnosisList.forEach((item) {
                Map map ={
                  "id":item['id'],
                  "name":item['dianame'],
                  "isMaster":item['isMaster']
                };
                list.add(map);
              });
              List filterList=list.where((item) =>item['isMaster']==1).toList();
              if(filterList.isEmpty){
                ToastUtil.showToast(msg: '请选择一个主诊断');
                return;
              }
              var res = await HttpRequest.getInstance().post(Api.addDiagnosisTemplate,{
                "doctorId": doctorId, //测试使用
                // "id": id, //模版id
                "deptId": departmentId, //科室id
                "name": templateName, //模版名称
                "diagnosisTemplateDetails": [],
              });
              if(res['code']==200){
                Navigator.pop(context);
              }else{
                ToastUtil.showToast(msg: res['msg']);
              }
            },
            title: '保存',
          )
        ],
      ),
    );
  }
}
