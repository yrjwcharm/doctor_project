import 'dart:math';

import 'package:doctor_project/pages/home/add-drug.dart';
import 'package:doctor_project/pages/home/add_drug_list.dart';
import 'package:doctor_project/pages/home/diagnosis.dart';
import 'package:doctor_project/utils/picker_utils.dart';
import 'package:doctor_project/utils/svg_utils.dart';
import 'package:doctor_project/utils/text_utils.dart';
import 'package:doctor_project/utils/toast_utils.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'package:flutter/material.dart';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';
import 'dart:ui';
import 'package:doctor_project/utils/EventBus_Utils.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doctor_project/pages/home/add_chineseMedicine_list.dart';
import 'package:flutter_picker/Picker.dart';


class MakePrescription extends StatefulWidget {
  const MakePrescription({Key? key}) : super(key: key);

  @override
  _MakePrescriptionState createState() => _MakePrescriptionState();
}

class _MakePrescriptionState extends State<MakePrescription> {

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
  String rpTypeId = '1';
  String rpTypeName = '普通处方';

  String diagnosisName='';

  List pharmacyList = []; //药房数据源
  List pharmacyNameList = []; //药房名称数据源
  String pharmacyName='';
  String pharmacyId='';
  bool tab1Active = true;
  bool tab2Active = false;

  List<String> useTypeList = [];
  List<String> freqTypeList = [];
  List<String> baseUnitList = [];

  @override
  void initState() {
    super.initState();

    loadtDataForRP();
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
      },
      {
        'title': '用法',
        'detail': '请选择用法',
        'isArrow': true,
      },
      {
        'title': '频次',
        'detail': '请选择频次',
        'isArrow': true,
      }
    ];

    EventBusUtil.getInstance().on<Map>().listen((event) {
      setState(() {
        drugList.add(event);
        print(event);
      });
    });
  }

  //获取药房列表接口

  //新建处方接口
  void getNet_createPrescription() async{

    if(checkDataList.isEmpty || drugList.isEmpty){
      Fluttertoast.showToast(msg: "请选择诊断或药品", gravity: ToastGravity.CENTER);
      return ;
    }
    if(tab2Active){
      if(chineseMedicineTypeList[1]["detail"] =="请选择用法"
          ||chineseMedicineTypeList[2]["detail"] =="请选择频次"
          ||_editingController1.text.isEmpty){

        Fluttertoast.showToast(msg: "请选择或输入用法用量", gravity: ToastGravity.CENTER);
        return;
      }
    }

    List diagnosisParams = []; //诊断传参数组
    for(int i=0; i<checkDataList.length; i++){
      
      Map item = new Map();
      item["diagnosisId"] = checkDataList[i]["id"];
      item["isMaster"] = checkDataList[i]["isMain"] ? "1" : "0";
      diagnosisParams.add(item);
    }

    List medicineParams = []; //药品传参数组
    for(int j=0; j<drugList.length; j++){

      Map item = new Map();
      item["medicineId"] = drugList[j]["medicineid"];
      item["num"] = drugList[j]["count"];

      //中药无这几项值
      if(tab1Active){

        item["useType"] = drugList[j]["usage"];
        item["freq"] = drugList[j]["frequency"] +"," +drugList[j]["dosage"];
        item["dayNum"] = drugList[j]["medicationDays"];
        if(drugList[j]["remark"].isNotEmpty){
          item["remarks"] = drugList[j]["remark"];
        }
      }

      medicineParams.add(item);
    }

    Map map ;

    if(tab1Active){
      map = {
        "registerId" : 2,
        "name" : rpTypeName,
        "type" : 1, //模块（recipe-处方，register-挂号，logistics-物流，text-图文，video-视频）
        "roomId" : 3696, //药房id
        "category" : tab1Active ? 1 : 2, //处方类别（1-西药/中成药，2-中药）
        "diagnosisParams" : diagnosisParams,
        "medicineParams"  : medicineParams,
      };
    }else{

      map = {
        "registerId" : 5,
        "name" : rpTypeName,
        "type" : 1, //模块（recipe-处方，register-挂号，logistics-物流，text-图文，video-视频）
        "roomId" : 3696, //药房id
        "useType" : chineseMedicineTypeList[1]["detail"], //用法
        "freq" : chineseMedicineTypeList[2]["detail"], //频次
        "remarks" : _editingController2.text.isEmpty ?"" :_editingController2.text, //备注
        "countNum" : _editingController1.text, //副数、贴数（中药）
        "category" : tab1Active ? 1 : 2, //处方类别（1-西药/中成药，2-中药）
        "diagnosisParams" : diagnosisParams,
        "medicineParams"  : medicineParams,
      };
    }

    print(map);
    // HttpRequest? request = HttpRequest.getInstance();
    // var res = await request?.post(Api.createPrescriptionUrl,map);
    // print(res);
    // if (res['code'] == 200) {
    //
    // }

    SharedPreferences perfer = await SharedPreferences.getInstance();
    String? tokenValueStr = perfer.getString("tokenValue");
    var dio = new Dio();
    dio.options.headers = {
      "token": tokenValueStr,
    };
    var response = await dio.post(
        // 'https://interhospital.youjiankang.net/doctor/dr-service/recipe/create',
      Api.BASE_URL +Api.createPrescriptionUrl,
        data: map
    );
    print(response.data);
    if(response.data['code'] == 200){
      //请求成功
      Fluttertoast.showToast(msg: "新增处方成功", gravity: ToastGravity.CENTER);

    }else{
      Fluttertoast.showToast(msg: response.data['msg'], gravity: ToastGravity.CENTER);
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

  //初始化加载处方类型列表
  loadtDataForRP() async {

    HttpRequest? request = HttpRequest.getInstance();
    var res = await request?.get(Api.dataDicUrl + '?dictId=14');
    if (res['code'] == 200) {
      List data = res['data'];
      print("loadtDataForRP------" +data.toString());
      List<String> pickerData = [];
      for (var item in data) {
        pickerData.add(item['detailName']);
      }
      setState(() {
        rpData = pickerData;
        rpList =data;
      });
    }
  }

  //初始化加载药房名称列表
  loadtDataForPharmacy() async {

    HttpRequest? request = HttpRequest.getInstance();
    var res = await request?.get(Api.pharmacyListUrl);
    print("loadtDataForPharmacy------" +res.toString());
    if (res['code'] == 200) {
      List data = res['data'];
      List<String> pickerData = [];
      for (var item in data) {
        pickerData.add(item['name']);
      }
      setState(() {
        pharmacyNameList = pickerData;
        pharmacyList =data;
      });
    }
  }

  //初始化药品用法列表
  loadDataForUseType() async {

    HttpRequest? request = HttpRequest.getInstance();
    var res = await request?.get(Api.dataDicUrl + '?dictId=15');
    if (res['code'] == 200) {
      List data = res['data'];
      print("loadDataForUseType------" +data.toString());
      List<String> pickerData = [];
      for (var item in data) {
        pickerData.add(item['detailName']);
      }
      setState(() {
        useTypeList = pickerData;
      });
    }
  }

  //初始化药品频次列表
  loadDataForFreqTYpe() async {

    HttpRequest? request = HttpRequest.getInstance();
    var res = await request?.get(Api.dataDicUrl + '?dictId=16');
    if (res['code'] == 200) {
      List data = res['data'];
      print("loadDataForFreqTYpe------" +data.toString());
      List<String> pickerData = [];
      for (var item in data) {
        pickerData.add(item['detailName']);
      }
      setState(() {
        freqTypeList = pickerData;
      });
    }
  }

  //初始化药品服药单位列表
  loadDataForBaseUnit() async {

    HttpRequest? request = HttpRequest.getInstance();
    var res = await request?.get(Api.dataDicUrl + '?dictId=19');
    if (res['code'] == 200) {
      List data = res['data'];
      print("loadDataForBaseUnit------" +data.toString());
      List<String> pickerData = [];
      for (var item in data) {
        pickerData.add(item['detailName']);
      }
      setState(() {
        baseUnitList = pickerData;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    //不用的时候记得关闭
    EventBusUtil.getInstance().destroy();
  }

  /*
  data 数据源数组
  item 需要改变的数据源
   */
  List<Widget> dialogData(List<String> data, Map item)
  {
    List <Widget> widgetList = [];
    for(int i=0; i<data.length; i++){

      StatelessWidget dialog = SimpleDialogOption(
        child: Text(data[i]),
        onPressed: (){
          Navigator.of(context).pop();
          setState(() {

            item.update("detail", (value) => data[i]);
          });
        },
      );

      widgetList.add(dialog);
      widgetList.add(const Divider(),);
    }

    return widgetList ;
  }

  void _showSimpleDialog1() async{

    var result=await showDialog(
        useRootNavigator:false,
        barrierDismissible:true,   //表示点击灰色背景的时候是否消失弹出框
        context:context,
        builder: (context){
          return SimpleDialog(
            // title:Text(""),
            children: dialogData(useTypeList,chineseMedicineTypeList[1]),
          );
        }
    );
  }


  void _showSimpleDialog2() async{

    var result=await showDialog(
        useRootNavigator:false,
        barrierDismissible:true,   //表示点击灰色背景的时候是否消失弹出框
        context:context,
        builder: (context){
          return SimpleDialog(
            // title:Text(""),
            children: dialogData(freqTypeList,chineseMedicineTypeList[2]),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          '开处方',
          isBack: true,
          onBackPressed: () {
            Navigator.of(context).pop(this);
          },
        ),
        backgroundColor: ColorsUtil.bgColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 14.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          tab1Active = true;
                          tab2Active = false;
                          resetData();
                        });
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            tab1Active
                                ? 'assets/images/self_mention.png'
                                : 'assets/images/self_mention1.png',
                            width: screenWidth/ratio /2,
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                              width: screenWidth/ratio /2,
                              height: 44,
                              child: Center(
                                  child: Text(
                                '西药/中成药处方',
                                style: GSYConstant.textStyle(
                                    fontSize: 17.0,
                                    color: tab1Active ? '#06B48D' : '#333333'),
                              ))),
                        ],
                      ),
                    ),
                    Flexible(
                        child: GestureDetector(
                      onTap: () {
                        setState(() {
                          tab2Active = true;
                          tab1Active = false;
                          resetData();
                        });
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            tab2Active
                                ? 'assets/images/express_delivery1.png'
                                : 'assets/images/express_delivery.png',
                            fit: BoxFit.cover,
                            width: screenWidth/ratio /2,
                            height: 44,
                          ),
                          Positioned(
                              width: screenWidth/ratio /2,
                              height: 44,
                              child: Center(
                                child: Text(
                                  '中药处方',
                                  style: GSYConstant.textStyle(
                                      fontSize: 16.0,
                                      color:
                                          tab2Active ? '#06B48D' : '#333333'),
                                ),
                              )),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  PickerUtil.showPicker(context, _scaffoldKey,
                      pickerData: rpData,
                      confirmCallback: (Picker picker, List<int> selected) {
                    setState(() {
                       rpTypeId = rpList[selected[0]]['detailValue'];
                       rpTypeName = rpList[selected[0]]['detailName'];
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
                        color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                      ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '处方类型',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            rpTypeName,
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
                          builder: (context) =>
                              Diagnosis(type: tab1Active ? 1 : 0,checkedDataList: checkDataList,))).then((value) {
                    checkDataList =value;
                    print(value);
                    String str ="";

                    for(int i=0; i<value.length; i++){
                      String str1 = str.isEmpty ? value[i]["diadesc"] : "," +value[i]["diadesc"];
                      str += str1;
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
                            color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                          ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '诊断',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            TextUtil.isEmpty(diagnosisName)?'请选择诊断':diagnosisName,
                            style: GSYConstant.textStyle(color:TextUtil.isEmpty(diagnosisName)?'#999999':'#666666'),
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
                            color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
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
                            TextUtil.isEmpty(pharmacyId)?'请选择药房':pharmacyName,
                            style: GSYConstant.textStyle(color:TextUtil.isEmpty(pharmacyId)?'#999999':'#666666'),
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
            children: chineseMedicineTypeList.map(
                  (item) => GestureDetector(
                    onTap: (){
                      if(item['title'] =="用法"){
                        _showSimpleDialog1();
                      }else if(item['title'] =="频次"){
                        _showSimpleDialog2();
                      }
                    },

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
                                    color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                                  ))),
                          // margin: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    item['title'],
                                    style:
                                    GSYConstant.textStyle(color: '#333333'),
                                  ),
                                  // Text('(付/剂)',style: GSYConstant.textStyle(color: '#999999'),)
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    SizedBox(
                                      width:250.0,
                                      child: TextField(
                                        controller: !item['isArrow'] ? _editingController1 : null,
                                        enabled: !item['isArrow'],
                                        textAlign: TextAlign.right,
                                        textAlignVertical:
                                        TextAlignVertical.center,
                                        style: GSYConstant.textStyle(
                                            color: '#999999'),
                                        decoration: InputDecoration(
                                            hintText: item['detail'],
                                            isCollapsed: true,
                                            contentPadding: EdgeInsets.zero,
                                            // suffixIcon: Image.asset('assets/images/home/arrow_right.png'),
                                            border: InputBorder.none,
                                            // isCollapsed: true,
                                            hintStyle: GSYConstant.textStyle(
                                                color: '#999999')),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0,),
                                    item['isArrow']?Image.asset('assets/images/home/arrow_right.png'):Container()
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 0,
                          color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                        )
                      ],
                    ),
                  ),

            ).toList(),
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
                              hintStyle: GSYConstant.textStyle(color: '#999999'),
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
                      'increment.svg',
                    ),
                    TextButton(
                        onPressed: () {

                          Map map = {
                            "useType" : useTypeList,
                            "freqType" : freqTypeList,
                            "baseUnit" : baseUnitList,
                          };

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => tab1Active ? AddDrugList(instructionsMap: map,) : AddChineseMedicineList(selectedDrugList: drugList,))).then((value){

                                    print(value);
                                    if(tab2Active){ //中药处方
                                      setState(() {
                                        drugList =value;
                                      });
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
                child:  tab1Active ? ListView(
                    shrinkWrap: true,
                    children: drugList
                        .asMap()
                        .keys
                        .map((index) => Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                  width: 1.0,
                                  color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                                ))),

                        padding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 11.0, bottom: 14.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        drugList[index]['medicinename'],
                                        style: GSYConstant.textStyle(
                                            color: '#333333'),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        drugList[index]['usage'] +"：" +drugList[index]['frequency'] +"," +drugList[index]['dosage'],
                                        style: GSYConstant.textStyle(
                                            fontSize: 13.0,
                                            color: '#666666'),
                                      ),
                                      (drugList[index]['remark']
                                          ?.toString() ??
                                          '')
                                          .isNotEmpty
                                          ? Container(
                                        margin:
                                        const EdgeInsets.only(
                                            top: 4.0),
                                        child: Text(
                                            '备注：${drugList[index]['remark']}',
                                            style: GSYConstant
                                                .textStyle(
                                                fontSize: 13.0,
                                                color:
                                                '#666666')),
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
                                        style: GSYConstant.textStyle(
                                            fontSize: 10.0,
                                            color: '#333333'),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'x ${drugList[index]['count'].toString()}',
                                        style: GSYConstant.textStyle(
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
                              color: ColorsUtil.hexStringColor(
                                  '#cccccc',
                                  alpha: 0.3),
                            )
                                : Container()
                          ],
                        )))
                        .toList()) //西药处方
                    : ListView(
                    shrinkWrap: true,
                    children: drugList
                        .asMap()
                        .keys
                        .map((index) => Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                  width: 1.0,
                                  color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
                                ))),

                        padding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 11.0, bottom: 14.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        drugList[index]['medicinename'],
                                        style: GSYConstant.textStyle(
                                            color: '#333333'),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        "用量：" +drugList[index]['specification'],
                                        style: GSYConstant.textStyle(
                                            fontSize: 13.0,
                                            color: '#999999'),
                                      ),
                                      (drugList[index]['remark']
                                          ?.toString() ??
                                          '')
                                          .isNotEmpty
                                          ? Container(
                                        margin:
                                        const EdgeInsets.only(
                                            top: 4.0),
                                        child: Text(
                                            '备注：${drugList[index]['remark']}',
                                            style: GSYConstant
                                                .textStyle(
                                                fontSize: 13.0,
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
                                        style: GSYConstant.textStyle(
                                            fontSize: 12.0,
                                            color: '#333333'),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            index != drugList.length - 1
                                ? Divider(
                              height: 0,
                              color: ColorsUtil.hexStringColor(
                                  '#cccccc',
                                  alpha: 0.3),
                            )
                                : Container()
                          ],
                        )))
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
                                '¥ ${50.30}',
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
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                alignment: Alignment.bottomCenter,
                child: SafeAreaButton(text: '电子签名', onPressed: () {

                  getNet_createPrescription();
                }),
              )
            ],
          ),
        ));



  }
}
