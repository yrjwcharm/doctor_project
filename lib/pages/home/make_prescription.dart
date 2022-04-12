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
import 'package:doctor_project/pages/home/webviewVC.dart';
import 'package:doctor_project/pages/home/electronicSgnature.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';

class MakePrescription extends StatefulWidget {
  Map userInfoMap ; //患者信息map
  MakePrescription({Key? key, required this.userInfoMap}) : super(key: key);

  @override
  _MakePrescriptionState createState() => _MakePrescriptionState(userInfoMap: this.userInfoMap);
}

class _MakePrescriptionState extends State<MakePrescription> {

  Map userInfoMap ; //患者信息map
  _MakePrescriptionState({required this.userInfoMap});

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
  double totalPrice =0 ; //药品总价格

  List<String> useTypeList = [];
  List<String> freqTypeList = [];
  List<String> baseUnitList = [];

  @override
  void initState() {
    super.initState();

    print("userInfoMap-------" +this.userInfoMap.toString());
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
        calculateThePrice();
      });
    });
  }

  //新建处方接口
  void getNet_createPrescription() async{

    if(pharmacyId.isEmpty){
      Fluttertoast.showToast(msg: "请选择药房", gravity: ToastGravity.CENTER);
      return ;
    }

    if(checkDataList.isEmpty || drugList.isEmpty){
      Fluttertoast.showToast(msg: "请选择诊断或药品", gravity: ToastGravity.CENTER);
      return ;
    }
    if(tab2Active){
      if(chineseMedicineTypeList[1]["detail"].indexOf("请选择") !=-1
          ||chineseMedicineTypeList[2]["detail"].indexOf("请选择") !=-1
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
        // "registerId" : 2,
        "registerId" : userInfoMap["id"].toString(), //挂号id
        "name" : rpTypeName, //处方类型
        "type" : 1, //模块（recipe-处方，register-挂号，logistics-物流，text-图文，video-视频）
        "roomId" : pharmacyId, //药房id
        "category" : 1, //处方类别（1-西药/中成药，2-中药）
        "diagnosisParams" : diagnosisParams,
        "medicineParams"  : medicineParams,
      };
    }else{

      map = {
        // "registerId" : 5,
        "registerId" : userInfoMap["id"].toString(), //挂号id
        "name" : rpTypeName, //处方类型
        "type" : 1, //模块（recipe-处方，register-挂号，logistics-物流，text-图文，video-视频）
        "roomId" : pharmacyId, //药房id
        "useType" : chineseMedicineTypeList[1]["detail"], //用法
        "freq" : chineseMedicineTypeList[2]["detail"], //频次
        "remarks" : _editingController2.text.isEmpty ?"" :_editingController2.text, //备注
        "countNum" : _editingController1.text, //副数、贴数（中药）
        "category" : 2, //处方类别（1-西药/中成药，2-中药）
        "diagnosisParams" : diagnosisParams,
        "medicineParams"  : medicineParams,
      };
    }
    print(map);

    SharedPreferences perfer = await SharedPreferences.getInstance();
    String? tokenValueStr = perfer.getString("tokenValue");
    var dio = new Dio();
    dio.options.headers = {
      "token": tokenValueStr,
    };
    var response = await dio.post(
      Api.BASE_URL +Api.createPrescriptionUrl,
        data: map
    );
    print(response.data);
    if(response.data['code'] == 200){
      //请求成功
      // Fluttertoast.showToast(msg: "新增处方成功", gravity: ToastGravity.CENTER);
      getNet_userSignature();

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

  //计算价格
  void calculateThePrice(){
    totalPrice = 0;
    for(Map item in drugList){
      String unitprice = item['unitprice'].toString();
      String count = item['count'].toString();
      double price = double.parse(unitprice) *double.parse(count);
      print(price);
      totalPrice += price;
      print("-----------totalPrice" +totalPrice.toString());
  }
  }

  //医信签电子签名接口
  void getNet_userSignature()async {

    HttpRequest? request = HttpRequest.getInstance();
    var res = await request?.get(Api.userSignatureUrl, {});
    print("getNet_userSignature------" +res.toString());
    Map data = res['data'];
    if (res['code'] == 200) {
      if(data["signatureImg"] !=null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> electronicSignaturePage(YXQDataMap: data,userInfoMap: userInfoMap,),));

      }else{
        String url = data["data"]["oauthURL"];

        Navigator.push(context, MaterialPageRoute(builder: (context)=> WebviewVC(url: url,)));
      }

    }else{
      Fluttertoast.showToast(msg: res['msg'], gravity: ToastGravity.CENTER);
    }
  }

  //初始化加载处方类型列表
  loadtDataForRP() async {

    HttpRequest? request = HttpRequest.getInstance();
    var res = await request?.get(Api.dataDicUrl + '?dictId=14',{});
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
    var res = await request?.get(Api.pharmacyListUrl,{});
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
    var res = await request?.get(Api.dataDicUrl + '?dictId=15',{});
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
    var res = await request?.get(Api.dataDicUrl + '?dictId=16',{});
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
    var res = await request?.get(Api.dataDicUrl + '?dictId=19',{});
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
                                        inputFormatters: !item['isArrow'] ?
                                        [
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9]")), //数字包括小数
                                        ] :[],
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

                          Navigator.push( //中药药品选择
                              context,
                              MaterialPageRoute(
                                  builder: (context) => tab1Active ? AddDrugList(instructionsMap: map,) : AddChineseMedicineList(selectedDrugList: [],))).then((value){

                                    print(value);
                                    if(tab2Active){ //中药处方
                                      setState(() {
                                        drugList.addAll(value);
                                        calculateThePrice();
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
                        .map((index) => Slidable(
                        endActionPane:  ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              // An action can be bigger than the others.
                              // flex: 2,
                              onPressed: (BuildContext context){
                                setState(() {
                                  drugList.removeAt(index);
                                });
                              },
                              backgroundColor: const Color(0xFFFE4A49),
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
                                        drugList[index]['medicinename'] +" " +drugList[index]["specification"] +"/" +drugList[index]["packageUnitid_dictValue"],
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
                        ))))
                        .toList()) //西药处方
                    : ListView(
                    shrinkWrap: true,
                    children: drugList
                        .asMap()
                        .keys
                        .map((index) => Slidable(
                        endActionPane:  ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(

                              onPressed: (BuildContext context){
                                setState(() {
                                  drugList.removeAt(index);
                                });
                              },
                              backgroundColor: const Color(0xFFFE4A49),
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
                                        "用量：${drugList[index]['specification']}" ,
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
                                '¥ ' +totalPrice.toStringAsFixed(2),
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
                  // getNet_userSignature();
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> WebviewVC(url: "https://www.baidu.com/",)));

                  String base64Str =
                  "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";

                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> electronicSignaturePage(imageStr: base64Str,userInfoMap: userInfoMap,),));


                }),
              )
            ],
          ),
        ));
  }

}
