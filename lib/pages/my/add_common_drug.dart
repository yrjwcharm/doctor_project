import 'dart:async';
import 'dart:math';
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
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doctor_project/pages/home/add_chinese_drug_list.dart';
import 'package:doctor_project/pages/home/webviewVC.dart';
import 'package:doctor_project/pages/home/electronicSgnature.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';

import '../../utils/common_utils.dart';
import '../../utils/event_bus_util.dart';

class AddCommonDrug extends StatefulWidget {
  String registeredId; //挂号Id
  AddCommonDrug({Key? key, required this.registeredId}) : super(key: key);

  _MakePrescriptionState createState() =>
      _MakePrescriptionState(registeredId: this.registeredId);
}

class _MakePrescriptionState extends State<AddCommonDrug> {
  String registeredId; //挂号Id
  _MakePrescriptionState({required this.registeredId});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _editingController1 = TextEditingController();
  final TextEditingController _editingController2 = TextEditingController();

  double screenWidth = window.physicalSize.width;
  double ratio = window.devicePixelRatio;
  List checkDataList = []; //选中的诊断数组
  List chineseMedicineTypeList = [];
  List drugList = [
    // {
    //   'name': '[阿莫灵]阿莫西林胶囊0.25*24粒/盒',
    //   'usage': '一次3粒，4次/天',
    //   'price': '38.30',
    //   'count': '2'
    // },
    // {
    //   'name': '先锋霉素VI胶囊 头孢拉定胶囊0.25*24粒/盒',
    //   'remark': '饭后半小时吃',
    //   'usage': '一次3粒，4次/天',
    //   'price': '38.30',
    //   'count': '2'
    // }
  ]; //选中的药品数组
  List<String> rpData = <String>[];
  List rpList = [];
  String rpTypeId = ''; //处方类型id
  String rpTypeName = ''; //处方分类

  List<String> tcmData = <String>[];
  List tcmList = [];

  int _radioGroup = 0;
  String diagnosisName = '';

  List pharmacyList = []; //药房数据源
  List pharmacyNameList = []; //药房名称数据源
  String pharmacyName = ''; //药房类型
  String pharmacyId = ''; //药房id
  List<String> rpArray = ['西药/中成药处方', '中药处方'];
  bool tab1Active = true;
  bool tab2Active = false;
  String rpName = '西药/中成药处方';
  double totalPrice = 0; //药品总价格
  String prescriptionId = ""; //处方id

  List<String> useTypeList = [];
  List _freqTypeList = [];
  List _useTypeList = [];
  List _baseUnitList = [];

  List<String> freqTypeList = [];
  List<String> baseUnitList = [];
  StreamSubscription? stream;
  String onceDosageDesc = '';

  @override
  void initState() {
    super.initState();

    loadtDataForRP();
    loadtDataForTCM();
    loadtDataForPharmacy();
    loadDataForUseType();
    loadDataForFreqTYpe();
    loadDataForBaseUnit();

    chineseMedicineTypeList = [
      {
        'title': '处方贴数',
        'subTitle': '(付/剂)',
        'detail': '请输入数量',
        'isArrow': false,
        'value': ''
      },
      {
        'title': '单次剂量',
        'subTitle': 'ml',
        'detail': '请选择',
        'isArrow': true,
        'value': ''
      },
      {'title': '用法', 'detail': '请选择用法', 'isArrow': true, 'value': ''},
      {'title': '频次', 'detail': '请选择频次', 'isArrow': true, 'value': ''}
    ];
    stream = EventBusUtil.getInstance().on<Map>().listen((event) {
      setState(() {
        drugList.add(event);
        calculateThePrice();
      });
    });
  }

  //新建处方接口
  void getNet_createPrescription() async {
    print('55555555,${drugList.toString()}');
    if (pharmacyId.isEmpty) {
      Fluttertoast.showToast(msg: "请选择药房", gravity: ToastGravity.CENTER);
      return;
    }
    if (tab2Active) {
      if (chineseMedicineTypeList[0]["detail"].indexOf("请选择") != -1) {
        ToastUtil.showToast(msg: '请输入贴数');
        return;
      }
      if (chineseMedicineTypeList[1]["detail"].indexOf("请选择") != -1) {
        ToastUtil.showToast(msg: '请选择单次剂量');
        return;
      }
      if (_radioGroup == 0) {
        if (chineseMedicineTypeList[1]["value"].isEmpty) {
          ToastUtil.showToast(msg: '请输入数量');
          return;
        }
      } else {
        if (onceDosageDesc.isEmpty) {
          ToastUtil.showToast(msg: '请输入用量描述');
          return;
        }
      }
      if (chineseMedicineTypeList[2]["detail"].indexOf("请选择") != -1) {
        Fluttertoast.showToast(msg: "请选择用法用量", gravity: ToastGravity.CENTER);
        return;
      }
      if (chineseMedicineTypeList[3]["detail"].indexOf("请选择") != -1) {
        ToastUtil.showToast(msg: '请选择频次');
        return;
      }
    }
    if (checkDataList.isEmpty || drugList.isEmpty) {
      Fluttertoast.showToast(msg: "请选择诊断或药品", gravity: ToastGravity.CENTER);
      return;
    }

    List diagnosisParams = []; //诊断传参数组
    for (int i = 0; i < checkDataList.length; i++) {
      Map item = new Map();
      item["diagnosisId"] = checkDataList[i]["id"];
      item["isMaster"] = checkDataList[i]["isMain"] ? "1" : "0";
      diagnosisParams.add(item);
    }

    List medicineParams = []; //药品传参数组
    for (int j = 0; j < drugList.length; j++) {
      Map item = new Map();
      item["medicineId"] = drugList[j]["medicineid"];
      item["num"] = drugList[j]["count"];
      item["wmOnceDosage"] = drugList[j]['dosage'];

      //中药无这几项值
      if (tab1Active) {
        item["useType"] = drugList[j]["_usage"];
        item["freq"] = drugList[j]["_frequency"];
        item["dayNum"] = drugList[j]["medicationDays"];
        if (drugList[j]["remark"].isNotEmpty) {
          item["remarks"] = drugList[j]["remark"];
        }
      }

      medicineParams.add(item);
    }

    Map<String, dynamic> map;

    if (tab1Active) {
      map = {
        // "registerId" : 2,
        "registerId": registeredId, //挂号id
        "name": rpTypeName, //处方类型
        "type": rpTypeId, //处方id
        "roomId": pharmacyId, //药房id
        "category": 1, //处方类别（1-西药/中成药，2-中药）
        "diagnosisParams": diagnosisParams,
        "medicineParams": medicineParams,
      };
    } else {
      map = {
        // "registerId" : 5,
        "registerId": registeredId, //挂号id
        "name": rpTypeName, //处方类型
        "type": rpTypeId, //处方id
        "roomId": pharmacyId, //药房id
        "useType": chineseMedicineTypeList[2]["value"], //用法
        "freq": chineseMedicineTypeList[3]["value"], //频次
        "remarks": _editingController2.text.isEmpty
            ? ""
            : _editingController2.text, //备注
        "countNum": chineseMedicineTypeList[0]["value"], //副数、贴数（中药）
        'onceDosage': chineseMedicineTypeList[1]['value'],
        'onceDosageDesc': onceDosageDesc,
        "category": 2, //处方类别（1-西药/中成药，2-中药）
        "diagnosisParams": diagnosisParams,
        "medicineParams": medicineParams,
      };
    }
    if (prescriptionId.isEmpty) {
      var res =
      await HttpRequest.getInstance().post(Api.createPrescriptionUrl, map);
      if (res['code'] == 200) {
        //请求成功
        // Fluttertoast.showToast(msg: "新增处方成功", gravity: ToastGravity.CENTER);
        setState(() {
          prescriptionId = res['data'].toString();
        });
        getNet_userSignature();
      } else {
        Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER);
      }
    }
  }

//切换处方类型时 重置数据源
  void resetData() {
    setState(() {
      checkDataList.clear();
      diagnosisName = "";
      drugList.clear();
    });
  }

  //计算价格
  void calculateThePrice() {
    totalPrice = 0;
    for (Map item in drugList) {
      String unitprice = item['unitprice'].toString();
      String count = item['count'].toString();
      double price = double.parse(unitprice) * double.parse(count);
      totalPrice += price;
    }
    totalPrice = totalPrice *
        (tab1Active ? 1 : int.parse(chineseMedicineTypeList[0]['value']));
  }

  //医信签电子签名接口
  void getNet_userSignature() async {
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.userSignatureUrl, {});
    print("getNet_userSignature------" + res.toString());
    Map data = res['data'];
    if (res['code'] == 200) {
      if (data["signatureImg"] != null) {
        // Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => electronicSignaturePage(
                  YXQDataMap: data,
                  registeredId: registeredId,
                  category: tab1Active ? "1" : "2",
                  prescriptionId: prescriptionId),
            ));
      } else {
        String url = data["data"]["oauthURL"];
        // Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebviewVC(
                  url: url,
                )));
      }
    } else {
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER);
    }
  }

  //初始化加载处方分类列表---西药
  loadtDataForRP() async {
    HttpRequest? request = HttpRequest.getInstance();
    var res = await request.get(Api.detailChildDicUrl + '?parentId=141', {});
    if (res['code'] == 200) {
      List data = res['data'];
      print("loadtDataForRP------" + data.toString());
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
      print("loadtDataForTCM------" + data.toString());
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
    print("loadtDataForPharmacy------" + res.toString());
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
    var res = await request.get(Api.dataDicUrl + '?dictId=15', {});
    if (res['code'] == 200) {
      List data = res['data'];
      print("loadDataForUseType------" + data.toString());
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
      // print("loadDataForFreqTYpe------" + data.toString());
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
      print("loadDataForBaseUnit------" + data.toString());
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
        '添加药品',
        isBack: true,
        onBackPressed: () {
          Navigator.of(context).pop(this);
        },
      ),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    PickerUtil.showPicker(context, _scaffoldKey,
                        pickerData: rpArray,
                        confirmCallback: (Picker picker, List<int> selected) {
                          if (selected[0] == 0) {
                            setState(() {
                              tab1Active = true;
                              tab2Active = false;
                              rpName = rpArray[0];
                              rpTypeName = rpList[0]['detailName'];
                            });
                          } else {
                            setState(() {
                              tab1Active = false;
                              tab2Active = true;
                              rpName = rpArray[1];
                              rpTypeName = tcmList[0]['detailName'];
                            });
                          }
                          loadDataForFreqTYpe();
                          resetData();
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
                            SvgUtil.svg('arrow_rp.svg')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 44.0,
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '科室选择',
                        style: GSYConstant.textStyle(
                            fontSize: 14.0, color: '#333333'),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '请选择科室',
                            style: GSYConstant.textStyle(
                                fontSize: 14.0, color: '#999999'),
                          ),
                          const SizedBox(
                            width: 7.0,
                          ),
                          SvgUtil.svg('forward_more.svg'),
                        ],
                      ),
                    ],
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
                            // if (pharmacyId.isEmpty) {
                            //   ToastUtil.showToast(msg: '请先选择药');
                            //   return;
                            // }
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
                                    ))).then((value) {
                              print(value);
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
                                                'medicinename'] +
                                                    " " +
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
                                                ['usage'] +
                                                    "：" +
                                                    drugList[index]
                                                    ['frequency'] +
                                                    "," +
                                                    drugList[index]
                                                    ['dosage'] +
                                                    drugList[index]
                                                    ['baseUnit'],
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
                                                '¥${drugList[index]['unitprice']}',
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
                                                'x ${drugList[index]['count'].toString()}',
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
                                              ['medicinename'],
                                              style:
                                              GSYConstant.textStyle(
                                                  color: '#333333'),
                                            ),
                                            const SizedBox(
                                              height: 4.0,
                                            ),
                                            Text(
                                              "用量：${drugList[index]['specification']}",
                                              style:
                                              GSYConstant.textStyle(
                                                  fontSize: 13.0,
                                                  color: '#999999'),
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
                                              '¥${drugList[index]['unitprice']}',
                                              style:
                                              GSYConstant.textStyle(
                                                  fontSize: 12.0,
                                                  color: '#333333'),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              'x ${drugList[index]['count'].toString()}',
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
                drugList.isNotEmpty
                    ? Divider(
                  height: 0,
                  color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                )
                    : Container(),
                drugList.isNotEmpty
                    ? Container(
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '共${drugList.length}件',
                        style: GSYConstant.textStyle(
                            fontSize: 13.0, color: '#999999'),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            '合计:',
                            style: GSYConstant.textStyle(
                                fontSize: 13.0, color: '#333333'),
                          ),
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
                if (prescriptionId.isEmpty) {
                  // CommonUtils.throttle(getNet_createPrescription,
                  //     durationTime: 1000);
                } else {
                  // //从授权界面返回，直接签名
                  // getNet_userSignature();
                }
              }),
        )
      ]),
    );
  }
}
