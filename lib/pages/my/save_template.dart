import 'dart:async';
import 'dart:math';
import 'package:doctor_project/pages/home/add_common_template.dart';
import 'package:doctor_project/pages/home/add_western_drug_list.dart';
import 'package:doctor_project/pages/home/diagnosis.dart';
import 'package:doctor_project/utils/picker_utils.dart';
import 'package:doctor_project/utils/screen_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/text_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/custom_safeArea_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';
import 'package:doctor_project/pages/my/choice_department.dart';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doctor_project/pages/home/add_chinese_drug_list.dart';
import 'package:doctor_project/pages/home/webviewVC.dart';
import 'package:doctor_project/pages/home/electronicSgnature.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';

import '../../model/western_rp_template.dart';
import '../../utils/common_utils.dart';
import '../../utils/event_bus_util.dart';
class SavePrescription extends StatefulWidget {
  Map dataMap;
  SavePrescription({Key? key, required this.dataMap}) : super(key: key);

  _SavePrescriptionState createState() =>
      _SavePrescriptionState(this.dataMap);
}

class _SavePrescriptionState extends State<SavePrescription> {
  Map dataMap;
  _SavePrescriptionState(this.dataMap);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _editingController1 = TextEditingController();
  final TextEditingController _editingController2 = TextEditingController();

  double screenWidth = window.physicalSize.width;
  double ratio = window.devicePixelRatio;
  List checkDataList = []; //选中的诊断数组
  List chineseMedicineTypeList = [];
  List drugList = []; //选中的药品数组
  List drugListParams = [];//药品传参数数组
  List<String> rpData = <String>[];
  List rpList = [];
  String rpTypeId = ''; //处方类型id
  String rpTypeName = ''; //处方分类
  String departmentId = '';//科室id
  String department = '';//科室名称

  List<String> tcmData = <String>[];
  List tcmList = [];

  int _radioGroup = 0;
  List<String> diagnosisName = [];

  String deptName = '';//科室名称
  List pharmacyList = []; //药房数据源
  List pharmacyNameList = []; //药房名称数据源
  String pharmacyName = ''; //药房类型
  String pharmacyId = ''; //药房id
  List<String> rpArray = ['西药/中成药处方', '中药处方'];
  bool tab1Active = true;//西药
  bool tab2Active = false;//中药
  String rpName = '西药/中成药处方';
  double totalPrice = 0; //药品总价格
  double oneCountPrice = 0;//一剂药总价格
  String prescriptionId = ""; //处方id


  List priceList = [];//每种中药的总价

  List<String> useTypeList = [];
  List _freqTypeList = [];
  String freq = "";
  List _useTypeList = [];
  String useType = "";
  List _baseUnitList = [];

  List<String> freqTypeList = [];
  List<String> baseUnitList = [];
  StreamSubscription? stream;
  String onceDosageDesc = '';
  List<MedicineVos> medicineVosList =[] ;
  @override
  void initState() {
    super.initState();

    print('-------save----'+dataMap.toString());
    print('\n\n\n\n\n\n');
    if(dataMap['categoryCode']==1){
      tab1Active = true;
      tab2Active = false;
      loadtDataForRP();
    }else {
      tab1Active = false;
      tab2Active = true;
      loadtDataForRP();
    }
    loadtDataForPharmacy();
    loadDataForBaseUnit();
    loadDataForFreqTYpe();
    loadDataForUseType();

    rpTypeName = dataMap["trType"];
    rpName = dataMap['category'];//处方类型
    pharmacyName = dataMap['room'];//药房
    pharmacyId = dataMap['roomId'];//药房id
    deptName = dataMap['deptName'];//科室名称
    departmentId = dataMap['deptId'];//科室id
    useType = dataMap['useType'];//使用方法
    freq = dataMap['freq']; //频次
    _editingController2.text = dataMap['remarks']; //备注
    onceDosageDesc = dataMap['onceDosageDes'];//中药药方单次计量

    //处方金额（元）
//    if(null!=dataMap['cost']){
//      totalPrice = double.parse(dataMap['cost']);
//    }
    drugList = dataMap['medicines'];//药品列表
    calculateThePrice();//计算总金额

    (dataMap['diagnoses'] ?? []).forEach((item) {
      Map map = {
        "diagnosisName": item['diagnosisName'],
        "isMain": item['isMaster'] == 1 ? true : false,
        "id": item['id'],
        "diagnosisId":item['diagnosisId']
      };
      checkDataList.add(map);
    });
    (dataMap['diagnoses'] ?? []).forEach((element) {
      diagnosisName.add(element['diagnosisName']!);//诊断
    });

    chineseMedicineTypeList = [
      {
        'title': '处方贴数',
        'subTitle': '(付/剂)',
        'detail': dataMap['countNum'],
        'isArrow': false,
        'value': ''
      },
      {
        'title': '单次剂量',
        'subTitle': 'ml',
        'detail': dataMap['onceDosageDes'],
        'isArrow': true,
        'value': ''
      },
      {'title': '用法', 'detail':useType, 'isArrow': true, 'value': ''},
      {'title': '频次', 'detail': freq, 'isArrow': true, 'value': ''}
    ];
    chineseMedicineTypeList[0]["value"] = dataMap['countNum'];
    chineseMedicineTypeList[1]["value"] = dataMap['onceDosage'];
    print('drugList111111======'+drugList.toString());
    drugListParams = drugList;
    stream = EventBusUtil.getInstance().on<Map>().listen((event) {
      print('stream======'+event.toString());
        Map item = new Map();
        item['unitPrice']=event['unitprice'];
        item['wmOnceDosage']=event['dosage'];
        item['recipeTemplateId']='';
        item['medicineNum']=event['count'];

        item['totalPrice']=calculateUnitprice(event);
        item['medicineId']=event['medicineid'];
        item['packageUnit']=event['packageUnit'];
        item['freq']=event['frequency'];
        item['useTypeCode']=event['usagecode'];
        item['specification']=event['specification'];
        item['useType']=event['usage'];
        item['dayNum']=event['medicationDays'];
        item['medicineName']=event['medicinename'];

        item['freqCode']=event['freqcode'];
        item['id']='';
        item['remarks']=event['remark'];
        drugList.add(item);
      print('drugList2222222======'+drugList.toString());
      drugListParams.add(item);
      print('drugListParams======'+drugListParams.toString());


      setState(() {
        calculateThePrice();
      });
    });

  }

  //新建处方接口
  void getNet_createPrescription() async {

    Map<String, dynamic> map;
    Map<String, dynamic> recipeTemplate;
    recipeTemplate = {
      'type': rpTypeId,
      'category':dataMap['categoryCode'],
      'roomId':pharmacyId,
      'useType':useType,
      'freq':freq,
      'countNum':chineseMedicineTypeList[0]["value"],
      'onceDosage':chineseMedicineTypeList[1]["value"],
      'onceDosageDes':onceDosageDesc,
      'remarks':_editingController2.text.isEmpty
          ? ""
          : _editingController2.text,
      'cost':totalPrice
    };

    List diagnosisParams = []; //诊断传参数组
    for (int i = 0; i < checkDataList.length; i++) {
      Map item = new Map();
      item["diagnosisId"] = checkDataList[i]["diagnosisId"];
      item["isMaster"] = checkDataList[i]["isMain"] ? "1" : "0";
      if(checkDataList.length<dataMap['diagnoses'].length){
        item["deleteFlag"] = 0;
      }else {
        item["deleteFlag"] = 1;
      }
      item["id"]= checkDataList[i]['id'];
      diagnosisParams.add(item);
    }

    map = {
      'id':dataMap['id'],
      'deptId':departmentId,
      'businessType':dataMap['businessType'],
      'name':dataMap['name'],
      'recipeTemplate':recipeTemplate,
      'diagnoses':diagnosisParams,
      'medicines':drugListParams
    };

      var res =
      await HttpRequest.getInstance().post(Api.addOrEditRecipe, map);
      print('map===='+map.toString());
      print('res===='+res.toString());
      if (res['code'] == 200) {
        //请求成功
        Fluttertoast.showToast(msg: "保存成功", gravity: ToastGravity.CENTER);
        setState(() {
          prescriptionId = res['data'].toString();
        });
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER);
      }
  }

//切换处方类型时 重置数据源
  void resetData() {
    setState(() {
      checkDataList.clear();
      diagnosisName = [];
      drugList.clear();
    });
  }

  //计算价格
  void calculateThePrice() {
    totalPrice = 0;
    oneCountPrice = 0;
    priceList.clear();
    print("drugList============="+drugList.toString());
    for (Map item in drugList) {
      String unitprice = item['unitPrice'].toString();
      String count = item['medicineNum'].toString();
      double price = double.parse(unitprice) * double.parse(count);
      Map <String, dynamic>priceMap;
      priceMap = {
        "price": price.toString(),
      };
      print("priceMap====="+priceMap.toString());
      priceList.add(priceMap);
      oneCountPrice += price;
    }
    print("priceList====="+priceList.toString());
    totalPrice = oneCountPrice *
        (tab1Active ? 1 : int.parse(chineseMedicineTypeList[0]['value']));
  }

  double calculateUnitprice(Map item){
    String unitprice = item['unitprice'].toString();
    String count = item['count'].toString();
    double price = double.parse(unitprice) * double.parse(count);
    return price;
  }


  //初始化加载处方分类列表---西药
  loadtDataForRP() async {
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.detailChildDicUrl + '?parentId=141', {});
    if (res['code'] == 200) {
      List data = res['data'];
      List<String> pickerData = [];
      for (var item in data) {
        pickerData.add(item['detailName']);
      }
      setState(() {
        rpData = pickerData;
        rpList = data;
        rpTypeId = rpList[0]['detailValue'].toString();
        rpTypeName = rpList[0]['detailName'];
      });
    }
  }

  //初始化加载处方类型列表---中药
  loadtDataForTCM() async {
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.detailChildDicUrl + '?parentId=142', {});
    if (res['code'] == 200) {
      List data = res['data'];
      List<String> pickerData = [];
      for (var item in data) {
        pickerData.add(item['detailName']);
      }
      setState(() {
        tcmData = pickerData;
        tcmList = data;
        rpTypeId = rpList[0]['detailValue'].toString();
        rpTypeName = rpList[0]['detailName'];
      });
    }
  }

  //初始化加载药房名称列表
  loadtDataForPharmacy() async {
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.pharmacyListUrl, {});
    if (res['code'] == 200) {
      List data = res['data'];
      List<String> pickerData = [];
      for (var item in data) {
        pickerData.add(item['name']);
      }
      setState(() {
        pharmacyNameList = pickerData;
        pharmacyList = data;
      });
    }
  }

  //初始化药品用法列表
  loadDataForUseType() async {
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.dataDicUrl + '?dictId=${tab1Active ? 23 : 15}', {});

    if (res['code'] == 200) {
      List data = res['data'];
      List<String> pickerData = [];
      for (var item in data) {
        pickerData.add(item['detailName']);
      }
      setState(() {
        useTypeList = pickerData;
        _useTypeList = data;
      });
    }
  }

  //初始化药品频次列表
  loadDataForFreqTYpe() async {
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request
        .get(Api.dataDicUrl + '?dictId=${tab1Active ? 16 : 21}', {});
    if (res['code'] == 200) {
      List data = res['data'];
      List<String> pickerData = [];
      for (var item in data) {
        pickerData.add(item['detailName']);
      }
      setState(() {
        freqTypeList = pickerData;
        _freqTypeList = data;
      });
    }
  }

  //初始化药品服药单位列表
  loadDataForBaseUnit() async {
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.dataDicUrl + '?dictId=19', {});
    if (res['code'] == 200) {
      List data = res['data'];
      List<String> pickerData = [];
      for (var item in data) {
        pickerData.add(item['detailName']);
      }
      setState(() {
        baseUnitList = pickerData;
        _baseUnitList = data;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream!.cancel();
      stream = null;
    }
    //不用的时候记得关闭
  }

  /*
  data 数据源数组
  item 需要改变的数据源
   */
  List<Widget> dialogData(List<String> data, List _data, Map item) {
    List<Widget> widgetList = [];
    for (int i = 0; i < data.length; i++) {
      StatelessWidget dialog = SimpleDialogOption(
        child: Text(data[i]),
        onPressed: () {
          Navigator.of(context).pop();
          if(i == 2){
            useType = _data[i];
          }else if(i == 3){
            freq = _data[i];
          }
          item['detail'] = data[i];
          item['value'] = _data[i]['detailValue'];
          setState(() {
            item;
          });
          // setState(() {
          //   item.update("detail", (value) => data[i]);
          //   item.update("value",(value)=>_data[i]['detailValue']);
          // });
        },
      );

      widgetList.add(dialog);
      widgetList.add(
        const Divider(),
      );
    }

    return widgetList;
  }

  void _showSimpleDialog1() async {
    var result = await showDialog(
        useRootNavigator: false,
        barrierDismissible: true, //表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return SimpleDialog(
            // title:Text(""),
            children: dialogData(
                useTypeList, _useTypeList, chineseMedicineTypeList[2]),
          );
        });
  }

  void _showSimpleDialog2() async {
    var result = await showDialog(
        useRootNavigator: false,
        barrierDismissible: true, //表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return SimpleDialog(
            // title:Text(""),
            children: dialogData(
                freqTypeList, _freqTypeList, chineseMedicineTypeList[3]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
          '开处方',
          isForward:true,
          onForwardPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>const AddCommonTemplate()));
          },
      ),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 44.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color:
                            ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                          ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '模板名称',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: ScreenUtil().setWidth(120.0),
                            child:TextField(
                              textAlign: TextAlign.right,
                              style: GSYConstant.textStyle(color: '#666666'),
                              cursorColor:ColorsUtil.hexStringColor('#666666') ,
                              inputFormatters: [],
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  hintText: dataMap['name'],
                                  border: InputBorder.none,
                                  hintStyle: GSYConstant.textStyle(color: '#666666')
                              ),
                            ),),
                        ],
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChoiceDepartment())).then((item) => {
                      setState((){
                        deptName = item.deptName;
                        departmentId = item.deptId;
                      })
                    });
                  },
                  child: Container(
                    height: 44.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color:
                              ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                            ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '科室选择',
                          style: GSYConstant.textStyle(color: '#333333'),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              deptName,
                              style: GSYConstant.textStyle(
                                  color:'#666666'),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            SvgUtil.svg('arrow_rp.svg')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  height: 44.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color:
                            ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                          ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '处方',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            rpName,
                            style: GSYConstant.textStyle(color: '#666666'),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (rpName == "中药处方") {
                      PickerUtil.showPicker(context, _scaffoldKey,
                          pickerData: tcmData,
                          confirmCallback: (Picker picker, List<int> selected) {
                            setState(() {
                              rpTypeId =
                                  tcmList[selected[0]]['detailValue'].toString();
                              rpTypeName = tcmList[selected[0]]['detailName'];
                            });
                          });
                    } else {
                      PickerUtil.showPicker(context, _scaffoldKey,
                          pickerData: rpData,
                          confirmCallback: (Picker picker, List<int> selected) {
                            setState(() {
                              rpTypeId =
                                  rpList[selected[0]]['detailValue'].toString();
                              rpTypeName = rpList[selected[0]]['detailName'];
                            });
                          });
                    }
                  },
                  child: Container(
                    height: 44.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color:
                              ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                            ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '处方分类',
                          style: GSYConstant.textStyle(color: '#333333'),
                        ),
                        Row(
                          children: <Widget>[
                            Text(rpTypeName,
                              style: GSYConstant.textStyle(color: '#666666'),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            SvgUtil.svg('arrow_rp.svg')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Diagnosis(
                              type: tab1Active ? 1 : 0,
                              checkedDataList: checkDataList,
                            ))).then((value) {
                              for(int i = 0;i<value.length;i++){
                                for (int j = 0; j < checkDataList.length; j++) {
                                  if(checkDataList[j]["diagnosisId"] == value[i]["id"]){
                                     i++;
                                     value.removeAt(i);
                                     return;
                                  }
                                }
                              }
                              for(int i=0;i<value.length;i++){
                                Map item = new Map();
                                item['diagnosisId']=value[i]['id'];
                                item['diagnosisName']= value[i]['dianame'];
                                item['']= value[i]['diadesc'];
                                item['']= value[i]['diacode'];
                                item['isMaster']= value[i]['isMain'];
                                item['id'] = '';
                              }

                      checkDataList = value;
                      print("checkDataList === "+checkDataList.toString());
                      List<String> str = [];

                      for (int i = 0; i < value.length; i++) {
                        String str1 = str.isEmpty
                            ? value[i]["diadesc"]
                            : "," + value[i]["diadesc"];
                        str.add(str1);
                      }
                      setState(() {
                        diagnosisName = str;
                      });
                    }); //type 诊断类（0-中医，1-西医）
                  },
                  child: Container(
                    height: 44.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color:
                              ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                            ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '诊断',
                          style: GSYConstant.textStyle(color: '#333333'),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(diagnosisName.toString(),
                                  textAlign: TextAlign.right,
                                  style: GSYConstant.textStyle(
                                      color:'#666666'),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              SvgUtil.svg('arrow_rp.svg')
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    PickerUtil.showPicker(context, _scaffoldKey,
                        pickerData: pharmacyNameList,
                        confirmCallback: (Picker picker, List<int> selected) {
                          setState(() {
                            pharmacyId = pharmacyList[selected[0]]['id'];
                            pharmacyName = pharmacyList[selected[0]]['name'];
                          });
                        });
                  },
                  child: Container(
                    height: 44.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color:
                              ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                            ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '药房',
                          style: GSYConstant.textStyle(color: '#333333'),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              pharmacyName,
                              style: GSYConstant.textStyle(
                                  color: '#666666'),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            SvgUtil.svg('arrow_rp.svg')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Offstage(
                  offstage: !tab2Active,
                  child: Column(
                    children: chineseMedicineTypeList
                        .map(
                          (item) => GestureDetector(
                        onTap: () {
                          if (item['title'] == "用法") {
                            _showSimpleDialog1();
                          } else if (item['title'] == "频次") {
                            _showSimpleDialog2();
                          } else if (item['title'] == '单次剂量') {
                            showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                // false = user must tap button, true = tap outside dialog
                                builder: (_) => WillPopScope(
                                    onWillPop: () async {
                                      return Future.value(false);
                                    }, child: StatefulBuilder(
                                    builder: (context, _setState) {
                                      return AlertDialog(
                                          contentPadding:
                                          const EdgeInsets.only(
                                              bottom: 20.0),
                                          // title: Text('title'),
                                          // titlePadding: const EdgeInsets.all(0),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: <Widget>[
                                                  Radio(
                                                    materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                    activeColor: ColorsUtil
                                                        .hexStringColor(
                                                        '#06b48d'),
                                                    value: 0,
                                                    groupValue: _radioGroup,
                                                    onChanged:
                                                        (int? value) {
                                                      _radioGroup = value!;
                                                      if (value == 0) {
                                                        onceDosageDesc = '';
                                                      }
                                                      _setState(() {});
                                                    },
                                                    // activeColor: Colors.blueAccent,
                                                  ),
                                                  Text(
                                                    '毫升',
                                                    style: GSYConstant
                                                        .textStyle(
                                                        fontSize: 16.0,
                                                        color:
                                                        '#333333'),
                                                  ),
                                                  SizedBox(
                                                    width: ScreenUtil()
                                                        .setWidth(5.0),
                                                  ),
                                                  Radio(
                                                    materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                    activeColor: ColorsUtil
                                                        .hexStringColor(
                                                        '#06b48d'),
                                                    value: 1,
                                                    groupValue: _radioGroup,
                                                    onChanged:
                                                        (int? value) {
                                                      _radioGroup = value!;
                                                      if (value == 0) {
                                                        onceDosageDesc = '';
                                                      }
                                                      _setState(() {});
                                                    },
                                                    // activeColor: Colors.blueAccent,
                                                  ),
                                                  Text(
                                                    '其他',
                                                    style: GSYConstant
                                                        .textStyle(
                                                        fontSize: 16.0,
                                                        color:
                                                        '#333333'),
                                                  )
                                                ],
                                              ),
                                              Visibility(
                                                visible: _radioGroup == 0,
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      height: 40.0,
                                                      width: 120.0,
                                                      // margin: const EdgeInsets.symmetric(horizontal: 16.0),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1.0,
                                                              color: ColorsUtil
                                                                  .hexStringColor(
                                                                  '#cccccc',
                                                                  alpha:
                                                                  0.6)),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              5.0)),
                                                      child: TextField(
                                                        keyboardType:
                                                        TextInputType
                                                            .number,
                                                        onChanged: (value) {
                                                          chineseMedicineTypeList[
                                                          1][
                                                          'value'] =
                                                              value;
                                                          chineseMedicineTypeList[
                                                          1][
                                                          'detail'] =
                                                              value + 'ml';
                                                          onceDosageDesc =
                                                          '';
                                                          setState(() {});
                                                        },
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                              "[0-9]"))
                                                        ],
                                                        style: GSYConstant
                                                            .textStyle(
                                                            fontSize:
                                                            14.0,
                                                            color:
                                                            '#888888'),
                                                        decoration:
                                                        InputDecoration(
                                                          // isDense: true,
                                                            isCollapsed:
                                                            true,
                                                            hintText:
                                                            '请输入数量',
                                                            border:
                                                            InputBorder
                                                                .none,
                                                            contentPadding: const EdgeInsets
                                                                .only(
                                                                left:
                                                                10.0),
                                                            fillColor:
                                                            Colors
                                                                .transparent,
                                                            filled:
                                                            true,
                                                            hintStyle: GSYConstant.textStyle(
                                                                fontSize:
                                                                14.0,
                                                                color:
                                                                '#888888')),
                                                      ),
                                                    ),
                                                    Container(
                                                        margin:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0),
                                                        child: Text(
                                                          'ml',
                                                          style: GSYConstant
                                                              .textStyle(
                                                              color:
                                                              '#333333'),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                  visible: _radioGroup == 1,
                                                  child: Container(
                                                    height: 80.0,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16.0),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1.0,
                                                            color: ColorsUtil
                                                                .hexStringColor(
                                                                '#cccccc',
                                                                alpha:
                                                                0.6)),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            5.0)),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                        chineseMedicineTypeList[
                                                        1]
                                                        ['value'] = '';
                                                        chineseMedicineTypeList[
                                                        1]
                                                        ['detail'] =
                                                            value;
                                                        onceDosageDesc =
                                                            value;
                                                        setState(() {});
                                                      },
                                                      inputFormatters: [],
                                                      style: GSYConstant
                                                          .textStyle(
                                                          fontSize:
                                                          14.0,
                                                          color:
                                                          '#888888'),
                                                      decoration: InputDecoration(
                                                          hintText:
                                                          '请输入用量描述',
                                                          border:
                                                          InputBorder
                                                              .none,
                                                          contentPadding: const EdgeInsets
                                                              .only(
                                                              left: 10.0),
                                                          fillColor: Colors
                                                              .transparent,
                                                          filled: true,
                                                          hintStyle: GSYConstant
                                                              .textStyle(
                                                              fontSize:
                                                              14.0,
                                                              color:
                                                              '#888888')),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                          buttonPadding:
                                          const EdgeInsets.all(0),
                                          actions: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(
                                                              context,
                                                              rootNavigator:
                                                              true)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          height: 40.0,
                                                          alignment:
                                                          Alignment
                                                              .center,
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  right: BorderSide(
                                                                      width:
                                                                      0.5,
                                                                      color: ColorsUtil.hexStringColor(
                                                                          '#cccccc',
                                                                          alpha:
                                                                          0.4)),
                                                                  top: BorderSide(
                                                                      width:
                                                                      1.0,
                                                                      color: ColorsUtil.hexStringColor(
                                                                          '#cccccc',
                                                                          alpha: 0.4)))),
                                                          child: Text(
                                                            '取消',
                                                            style: GSYConstant
                                                                .textStyle(
                                                                fontSize:
                                                                16.0,
                                                                color:
                                                                '#333333'),
                                                          ),
                                                        ))),
                                                Expanded(
                                                    child:
                                                    CustomElevatedButton(
                                                        borderRadius: const BorderRadius
                                                            .only(
                                                            bottomRight:
                                                            Radius.circular(
                                                                4.0)),
                                                        title: '确定',
                                                        height: 40.0,
                                                        onPressed: () {
                                                          if (_radioGroup ==
                                                              0) {
                                                            if (chineseMedicineTypeList[1]
                                                            [
                                                            "value"]
                                                                .isEmpty) {
                                                              ToastUtil.showToast(
                                                                  msg:
                                                                  '请输入单次剂量');
                                                              return;
                                                            }
                                                          } else {
                                                            if (onceDosageDesc
                                                                .isEmpty) {
                                                              ToastUtil.showToast(
                                                                  msg:
                                                                  '请输入用量描述');
                                                              return;
                                                            }
                                                          }
                                                          Navigator.of(
                                                              context,
                                                              rootNavigator:
                                                              true)
                                                              .pop();
                                                        }))
                                              ],
                                            )
                                          ]);
                                    })));
                          }
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 44.0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                        width: 1.0,
                                        color: ColorsUtil.hexStringColor(
                                            '#cccccc',
                                            alpha: 0.3),
                                      ))),
                              // margin: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        item['title'],
                                        style: GSYConstant.textStyle(
                                            color: '#333333'),
                                      ),
                                      // Text('(付/剂)',style: GSYConstant.textStyle(color: '#999999'),)
                                    ],
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 250.0,
                                          child: TextField(
                                            onChanged: (value) {
                                              item['value'] =
                                                  value.toString();
                                              setState(() {});
                                            },
                                            keyboardType:
                                            TextInputType.number,
                                            // controller: !item['isArrow']
                                            //     ? _editingController1
                                            //     : null,
                                            enabled: !item['isArrow'],
                                            textAlign: TextAlign.right,
                                            inputFormatters:
                                            !item['isArrow']
                                                ? [
                                              FilteringTextInputFormatter
                                                  .allow(RegExp(
                                                  "[0-9]")),
                                              //数字包括小数
                                            ]
                                                : [],
                                            textAlignVertical:
                                            TextAlignVertical.center,
                                            style: GSYConstant.textStyle(
                                                color: '#999999'),
                                            decoration: InputDecoration(
                                                hintText: item['detail'],
                                                isCollapsed: true,
                                                contentPadding:
                                                EdgeInsets.zero,
                                                // suffixIcon: Image.asset('assets/images/home/arrow_right.png'),
                                                border: InputBorder.none,
                                                // isCollapsed: true,
                                                hintStyle:
                                                GSYConstant.textStyle(
                                                    color: '#999999')),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        item['isArrow']
                                            ? Image.asset(
                                            'assets/images/home/arrow_right.png')
                                            : Container()
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 0,
                              color: ColorsUtil.hexStringColor('#cccccc',
                                  alpha: 0.3),
                            )
                          ],
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
                Offstage(
                  offstage: !tab2Active,
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0, top: 9.0),
                    constraints: const BoxConstraints(minHeight: 80.0),
                    alignment: Alignment.topLeft,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '备注：',
                          style: GSYConstant.textStyle(color: '#333333'),
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        Expanded(
                            child: TextField(
                              controller: _editingController2,
                              inputFormatters: [],
                              maxLines: 3,
                              textInputAction: TextInputAction.done,
                              cursorColor: ColorsUtil.hexStringColor('#666666'),
                              style: GSYConstant.textStyle(color: '#666666'),
                              decoration: InputDecoration(
                                  hintText: '请输入...',
                                  isCollapsed: true,
                                  hintStyle:
                                  GSYConstant.textStyle(color: '#999999'),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                ListTile(
                  tileColor: Colors.white,
                  title: const Text('RP'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SvgUtil.svg(
                        'add_drug.svg',
                      ),
                      TextButton(
                          onPressed: () {
                            Map map = {
                              "useType": useTypeList,
                              "_useType": _useTypeList,
                              "freqType": freqTypeList,
                              "_freqType": _freqTypeList,
                              "baseUnit": baseUnitList,
                              "_baseUnit": _baseUnitList,
                            };
                            if (pharmacyId.isEmpty) {
                              ToastUtil.showToast(msg: '请先选择药');
                              return;
                            }
                            Navigator.push(
                              //中药药品选择
                                context,
                                MaterialPageRoute(
                                    builder: (context) => tab1Active
                                        ? AddDrugList(
                                      pharmacyId: pharmacyId,
                                      instructionsMap: map,
                                    )
                                        : AddChineseMedicineList(
                                      pharmacyId: pharmacyId,
                                      selectedDrugList: [],
                                      isYinpian: rpTypeName=='饮片'?true:false,
                                    ))).then((value) {
                              if (tab2Active) {
                                //中药处方
                                drugList.addAll(value);
                                calculateThePrice();
                                setState(() {});
                              }
                            });
                          },
                          child: Text(
                            '添加药品',
                            style: GSYConstant.textStyle(color: '#06B48D'),
                          ))
                    ],
                  ),
                ),
                Offstage(
                  offstage: !drugList.isNotEmpty,
                  child: tab1Active
                      ? ListView(
                      shrinkWrap: true,
                      children: drugList
                          .asMap()
                          .keys
                          .map((index) => Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                // An action can be bigger than the others.
                                // flex: 2,
                                onPressed: (BuildContext context) {
                                  setState(() {
                                    drugList[index]['deleteFlag']=1;
                                    drugListParams = drugList;
                                    //此处需要请求一下修改接口
                                    drugList.removeAt(index);
                                    calculateThePrice();
                                  });

                                },
                                backgroundColor:
                                const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: '删除',
                              ),
                            ],
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                        width: 1.0,
                                        color: ColorsUtil.hexStringColor(
                                            '#cccccc',
                                            alpha: 0.3),
                                      ))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 11.0, bottom: 14.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Text(
                                                drugList[index][
                                                'medicineName'] +
                                                    drugList[index][
                                                    "specification"] +
                                                    "/" +
                                                    drugList[index]
                                                    ["packageUnit"],
                                                style: GSYConstant
                                                    .textStyle(
                                                    color:
                                                    '#333333'),
                                              ),
                                              const SizedBox(
                                                height: 4.0,
                                              ),
                                              Text(
                                                drugList[index]
                                                ['useType'] +
                                                    "：" +
                                                    drugList[index]
                                                    ['freq'] +
                                                    "," +
                                                    drugList[index]
                                                    ['wmOnceDosage'].toString() +
                                                    drugList[index]
                                                    ['packageUnit'],
                                                style: GSYConstant
                                                    .textStyle(
                                                    fontSize: 13.0,
                                                    color:
                                                    '#666666'),
                                              ),
                                              (drugList[index]['remark']
                                                  ?.toString() ??
                                                  '')
                                                  .isNotEmpty
                                                  ? Container(
                                                margin:
                                                const EdgeInsets
                                                    .only(
                                                    top: 4.0),
                                                child: Text(
                                                    '备注：${drugList[index]['remark']}',
                                                    style: GSYConstant.textStyle(
                                                        fontSize:
                                                        13.0,
                                                        color:
                                                        '#666666')),
                                              )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                '¥${drugList[index]['totalPrice']}',
                                                style: GSYConstant
                                                    .textStyle(
                                                    fontSize: 10.0,
                                                    color:
                                                    '#333333'),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                'x ${drugList[index]['medicineNum'].toString()}',
                                                style: GSYConstant
                                                    .textStyle(
                                                    fontSize: 12.0,
                                                    color:
                                                    '#888888'),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  index != drugList.length - 1
                                      ? Divider(
                                    height: 0,
                                    color:
                                    ColorsUtil.hexStringColor(
                                        '#cccccc',
                                        alpha: 0.3),
                                  )
                                      : Container()
                                ],
                              ))))
                          .toList()) //西药处方
                      : ListView(
                      shrinkWrap: true,
                      children: drugList
                          .asMap()
                          .keys
                          .map((index) => Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (BuildContext context) {
                                  setState(() {
                                    drugList.removeAt(index);
                                  });
                                  calculateThePrice();
                                },
                                backgroundColor:
                                const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: '删除',
                              ),
                            ],
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                        width: 1.0,
                                        color: ColorsUtil.hexStringColor(
                                            '#cccccc',
                                            alpha: 0.3),
                                      ))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 11.0, bottom: 14.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              drugList[index]
                                              ['medicineName']+' '+drugList[index]['medicineNum'].toString()+'g',
                                              style:
                                              GSYConstant.textStyle(
                                                  color: '#333333'),
                                            ),
                                            const SizedBox(
                                              height: 4.0,
                                            ),
                                            Text(
                                              "规格：${drugList[index]['specification']}${drugList[index]['decocting_method']==null?'':';'+drugList[index]['decocting_method']}",
                                              style:
                                              GSYConstant.textStyle(
                                                  fontSize: 13.0,
                                                  color: '#999999'),
                                            ),
                                            (drugList[index]['remarks']
                                                ?.toString() ??
                                                '')
                                                .isNotEmpty
                                                ? Container(
                                              margin:
                                              const EdgeInsets
                                                  .only(
                                                  top: 4.0),
                                              child: Text(
                                                  '备注：${drugList[index]['remark']}',
                                                  style: GSYConstant
                                                      .textStyle(
                                                      fontSize:
                                                      13.0,
                                                      color:
                                                      '#999999')),
                                            )
                                                : Container()
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '¥${priceList[index]['price']}',
                                              style:
                                              GSYConstant.textStyle(
                                                  fontSize: 13.0,
                                                  color: '#333333'),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              '${drugList[index]['unitprice']} x ${drugList[index]['count'].toString()}',
                                              style:
                                              GSYConstant.textStyle(
                                                  fontSize: 12.0,
                                                  color: '#888888'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  index != drugList.length - 1
                                      ? Divider(
                                    height: 0,
                                    color:
                                    ColorsUtil.hexStringColor(
                                        '#cccccc',
                                        alpha: 0.3),
                                  )
                                      : Container()
                                ],
                              ))))
                          .toList()), //中药处方
                ),
                Offstage(
                  offstage: drugList.isNotEmpty,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 25.0, bottom: 31.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      '暂时还没有药品添加',
                      style: GSYConstant.textStyle(
                          fontSize: 13.0, color: '#666666'),
                    ),
                  ),
                ),
                drugList.isNotEmpty ? Divider(
                  height: 0,
                  color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                ): Container(),
                Offstage(
                  offstage: !drugList.isNotEmpty,
                  child: tab2Active
                      ?Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom: BorderSide(
                                width: 1.0,
                                color: ColorsUtil.hexStringColor(
                                    '#cccccc',
                                    alpha: 0.3),
                              ))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 11.0, bottom: 14.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('单剂共计',
                                      style:
                                      GSYConstant.textStyle(
                                          color: '#333333'),
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      "数量",
                                      style:
                                      GSYConstant.textStyle(
                                          fontSize: 14.0,
                                          color: '#333333'),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      oneCountPrice.toStringAsFixed(2),
                                      style:
                                      GSYConstant.textStyle(
                                          fontSize: 13.0,
                                          color: '#333333'),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      'x ${chineseMedicineTypeList[0]["value"].toString()}',
                                      style:
                                      GSYConstant.textStyle(
                                          fontSize: 12.0,
                                          color: '#888888'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                        ],
                      )):Container(),
                ),
                Offstage(
                  offstage: !drugList.isNotEmpty,
                  child: tab1Active
                      ?Divider(
                    height: 0,
                    color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                  ): Container(),
                ),
                drugList.isNotEmpty
                    ? Container(
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      tab1Active
                          ?Text(
                        '共${drugList.length}件',
                        style: GSYConstant.textStyle(
                            fontSize: 13.0, color: '#999999'),
                      ):Text("合计：",style: GSYConstant.textStyle(fontSize: 14.0, color: '#333333',)),
                      Row(
                        children: <Widget>[
                          tab1Active
                              ?Text(
                            '合计:',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#333333'),
                          ):Text(""),
                          Text(
                            '¥ ' + totalPrice.toStringAsFixed(2),
                            style: GSYConstant.textStyle(
                                fontFamily: 'Medium',
                                fontSize: 16.0,
                                color: '#06B48D'),
                          )
                        ],
                      ),
                    ],
                  ),
                )
                    : Container(),
                Visibility(
                    visible: drugList.isNotEmpty,
                    child: Container(
                      height: 40.0,
                      // decoration: BoxDecoration(
                      //     color: Colors.white
                      // ),
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '*',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#FE5A6B'),
                          ),
                          Text(
                            '操作提示：左滑删除药品',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#666666'),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          // margin: const EdgeInsets.only(top: 30.0),
          alignment: Alignment.bottomCenter,
          child: CustomSafeAreaButton(
              title: '保存',
              onPressed: () {
                getNet_createPrescription();

              }),
        )
      ]),
    );
  }
}
