import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/api.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/model/common_diagnosis_modal.dart';
import 'package:doctor_project/pages/my/choice_department.dart';
import 'package:doctor_project/pages/my/choose_diagnosis.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_safeArea_button.dart';
import 'package:doctor_project/widget/custom_textField_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../model/department_modal.dart';

class UpdateCommonDiagnosis extends StatefulWidget {
  final String doctorId;
  final String id;
  final String name;
  final List<Details> diagnosis;
  final String deptId;
  final String deptName;
  const UpdateCommonDiagnosis({Key? key,required this.doctorId, required this.id, required this.name, required this.diagnosis, required this.deptId, required this.deptName}) : super(key: key);

  @override
  _AddCommonDiagnosisState createState() => _AddCommonDiagnosisState(this.doctorId,this.id,this.name,this.diagnosis,this.deptId,this.deptName);
}

class _AddCommonDiagnosisState extends State<UpdateCommonDiagnosis> {
  String templateName = '';
  String departmentId = '';
  String department = '';
  List<dynamic> diagnosisList = [];
  String doctorId;
  String name;
  String id;
  String deptId;
  String deptName;
  List<Details> diagnosis;
  final TextEditingController _editingController = TextEditingController();
  _AddCommonDiagnosisState(this.doctorId,this.id,this.name,this.diagnosis,this.deptId,this.deptName);

  @override
  void initState() {
    super.initState();
    templateName= name;
    departmentId=deptId;
    department =deptName;
    diagnosis.forEach((item) {
       Map map ={'id':item.diagnosisId,'isMaster':item.isMaster,'dianame':item.diagnosisName,'diacode':item.diagnosisCode,};
       diagnosisList.add(map);
    });
  }

  Widget _renderRow(BuildContext context, int index) {
    var _item = diagnosisList[index];
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          CustomSlidableAction(
            // An action can be bigger than the others.
            // flex: 2,
            onPressed: (BuildContext context) async {
              if (diagnosisList.isNotEmpty) {
                setState(() {
                  diagnosisList.removeAt(index);
                });
              }
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            // icon:Icons.delete,
            // label: '删除',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.delete),
                Text('删除',
                    style: TextStyle(fontSize: ScreenUtil().setSp(13.0))),
              ],
            ),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          diagnosisList.forEach((item) => {
                item['isMaster'] = 0,
                if (item['id'] == _item['id']) {item['isMaster'] = 1}
              });
          setState(() {
            diagnosisList = diagnosisList;
          });
        },
        child: Container(
          height: 43.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(
                      color:
                          ColorsUtil.hexStringColor('#cccccc', alpha: 0.3)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  '${_item['diacode']}  ${_item['dianame']}',
                  style:
                      GSYConstant.textStyle(fontSize: 14.0, color: '#333333'),
                ),
              ),
              _item['isMaster'] == 1
                  ? Text(
                      '主诊断',
                      style: GSYConstant.textStyle(
                          fontSize: 13.0, color: '#666666'),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                width: 8.0,
              ),
              SvgUtil.svg(
                  _item['isMaster'] == 1 ? 'active_radio.svg' : 'radio.svg')
              // : SvgUtil.svg('radio.svg')
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _editingController.value = TextEditingValue(
        text: templateName,
        selection: TextSelection.fromPosition(
            TextPosition(
                affinity: TextAffinity.downstream,
                offset: templateName.length)));
    return Scaffold(
      appBar: CustomAppBar(
        '诊断',
        child: SvgUtil.svg('add_diagnosis.svg'),
        isForward: true,
        onForwardPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChooseDiagnosis(
                        prevList: diagnosisList,
                      ))).then((value) => {
                if (value != null)
                  {
                    diagnosisList.addAll(value),
                    setState(() {
                      diagnosisList = value;
                    })
                  }
              });
        },
      ),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CustomTextFieldInput(
                    controller: _editingController,
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
                ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: diagnosisList.length,
                    itemBuilder: _renderRow)
              ],
            ),
          )),
          CustomSafeAreaButton(
            margin: const EdgeInsets.only(bottom: 16.0),
            onPressed: () async{
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
                ToastUtil.showToast(msg: '请选择主诊断');
                return;
              }
              var res = await HttpRequest.getInstance().post(Api.addDiagnosisTemplate,{
                "doctorId": doctorId, //测试使用
                // "id": id, //模版id
                "deptId": departmentId, //科室id
                "name": templateName, //模版名称
                "diagnosisTemplateDetails": list,
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
