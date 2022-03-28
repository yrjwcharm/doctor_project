import 'package:dio/dio.dart';
import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/add_multi_diagnosis.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/safe_area_button.dart';

class Diagnosis extends StatefulWidget {

  int type ; //诊断类型（0-中医，1-西医）
  Diagnosis({Key? key,this.type =0}) : super(key: key);

  @override
  _DiagnosisState createState() => _DiagnosisState(type :this.type);
}

class _DiagnosisState extends State<Diagnosis> {

  int type ;
  _DiagnosisState({this.type =0});

  Map dataMap = new Map(); //诊断列表数据
  List detailDataList = []; //诊断列表数据
  List commonList =[{'title':'风寒感冒'},{'title':'糖尿病'},{'title':'腰肌劳损'},{'title':'痛风'}];
  List checkedDataList = []; //选中的诊断 数组
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数
  bool isLoading = false; //判断 loading框是否隐藏
  String loadText = ""; //加载时显示的文字
  bool commonlyUsedIsHidden = true; //常用诊断是否隐藏
  bool diagnosisListIsHidden = false; //诊断列表是否隐藏
  bool checkedDiagnosisIsHidden = true; //选中列表是否隐藏

  final TextEditingController _editingController = TextEditingController();
  final FocusNode contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // getNet_diagnosisList();
    // getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        _getMore();
      }
    });
  }

void getNet_diagnosisList () async{

    // setState(() {
    //
    //   detailDataList = [
    //     {"dianame": "甲型H1N1流感", "diacode": "A49.2", "id": "42698", "diadesc": "甲型H1N1流感"},
    //     {"dianame": "人感染高致病性禽流感", "diacode": "J09", "id": "42697", "diadesc": "人感染高致病性禽流感"},
    //     {"dianame": "流感嗜血杆菌性肺炎", "diacode": "J14  01", "id": "5411", "diadesc": "流感嗜血杆菌性肺炎"},
    //     {"dianame": "流感伴有其他表现", "diacode": "J10.8", "id": "5406", "diadesc": "流感伴有其他表现"},
    //     {"dianame": "流感伴有其他呼吸道表现", "diacode": "J10.1", "id": "5405", "diadesc": "流感伴有其他呼吸道表现"}];
    //   loadText = "没有更多数据";
    //   diagnosisListIsHidden = false ;
    //   checkedDiagnosisIsHidden = true ;
    // });

    // return ;


  SharedPreferences perfer = await SharedPreferences.getInstance();
  String? tokenValueStr = perfer.getString("tokenValue");
  print("111111" + tokenValueStr.toString());

  var dio = new Dio();
  dio.options.headers = {
    // "token": "dfb33604-4686-4e55-abea-76571674c40a",
    "token": tokenValueStr,
  };

  String urlStr = "https://interhospital.youjiankang.net/doctor/dr-service/diagnosis/getList?keyword=" + _editingController.text + "&type=" +type.toString() +"&page=" +_page.toString() + "&size=10";
  var response = await dio.get(urlStr);

  if(response.data['code'] == 200){

    if(_page ==1){
      detailDataList.clear();
    }

    dataMap = response.data["data"];
    int total = dataMap["total"];
    int size = dataMap["size"];
    int totalPage = (total ~/ size) +1 ;
    print(totalPage);

    setState(() {

      // commonlyUsedIsHidden = true;
      diagnosisListIsHidden = false ;
      checkedDiagnosisIsHidden = true;
      detailDataList.addAll(dataMap["records"]);
    });


    if(dataMap["records"].length <10 || _page ==totalPage){

      loadText = "没有更多数据";
      isLoading = false ;
    }else{
      loadText = "上拉加载更多";
      isLoading = false;
    }

    print("data= " + response.data.toString() + "url= " + response.realUri.toString());

  }
}


  /**
   * 初始化list数据 加延时模仿网络请求
   */
  Future getData() async {
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        // detailDataList = List.generate(15, (i) => '哈喽,我是原始数据 $i');


      });
    });
  }

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<void> _onRefresh() async{
    _page = 1 ;
    getNet_diagnosisList();
  }

  Future _getMore() async {

    if(loadText =="没有更多数据"){
      return;
    }
    _page ++;
    setState(() {
      isLoading = true;
      loadText = "加载中";
    });

    getNet_diagnosisList();
  }

  /**
   * 加载更多时显示的组件,给用户提示
   */
  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: isLoading, //子组件是否可见，默认true（可见）
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue),),
                  width: 20.0,
                  height: 20.0,
                ),
            ),
            SizedBox(width: 15,),
            Text(loadText, style: TextStyle(fontSize: 16.0,color:ColorsUtil.hexStringColor("#333333"),),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
  //获取列表数据
  Widget _renderRow(BuildContext context, int index) {
    if (index < detailDataList.length) {
      return Column(
        children: [
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  flex : 2 ,
                  child: Text(detailDataList[index]["dianame"], style: GSYConstant.textStyle(color: '#888888'),),
                ),
                const SizedBox(width: 10.0,),
                Expanded(
                  flex : 1 ,
                  child:Text(detailDataList[index]["diacode"], style: GSYConstant.textStyle(color: '#333333'),),

                ),
                const SizedBox(width: 10.0,),
                Expanded(
                    flex : 2 ,
                    child:Text(detailDataList[index]["diadesc"], style: GSYConstant.textStyle(color: '#333330'),),
                )
              ],
            ),
            trailing: TextButton(onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddMultiDiagnosis()));
              setState(() {
                checkedDataList.add(detailDataList[index]);
                diagnosisListIsHidden = true;
                checkedDiagnosisIsHidden = false;
              });
            },
            style: TextButton.styleFrom(
              alignment: Alignment.centerRight,
              padding:EdgeInsets.zero,
            ),
            child: SvgUtil.svg('add_drug.svg'),)
          ),
          Divider(color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),)
        ],
      );
    }
    return _getMoreWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          CustomAppBar(
            '诊断',
            onBackPressed: () {
              Navigator.of(context).pop(this);
            },
          ),
          const SizedBox(height: 10.0,),
          Padding(padding:const EdgeInsets.only(top: 11.0,left: 17.0,right: 16.0), child:Row(
              children: <Widget>[
                Expanded(child:Container(
                  height: 32.0,
                  padding: const EdgeInsets.only(left:8.0,right: 16.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorsUtil.bgColor,
                    borderRadius: BorderRadius.circular(19.0),
                  ),
                  child: TextField(
                    controller: _editingController,
                    focusNode: contentFocusNode,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(20)//限制长度
                    ],
                    onChanged: (value)=>{
                      print(_editingController.text.isNotEmpty),
                    },
                    onEditingComplete: (){

                      contentFocusNode.unfocus();
                      _page = 1 ;
                      getNet_diagnosisList();
                    } ,
                    style:GSYConstant.textStyle(color: '#666666'),
                    cursorColor: ColorsUtil.hexStringColor('#666666'),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIconConstraints: const BoxConstraints(
                      ),
                      prefixIconConstraints: const BoxConstraints(
                          minWidth: 31.0
                      ),
                      // isDense: true,
                      isCollapsed: true,
                      prefixIcon: SvgUtil.svg('search.svg'),

                      suffixIcon:_editingController.text.isNotEmpty?SvgUtil.svg('delete.svg'):null,
                      hintStyle: GSYConstant.textStyle(color: '#888888'),
                      hintText: '搜索ICD名称、拼音码',
                    ),
                  ),
                ),),
                // const SizedBox(width: 16.0,),
                // Text('取消',style: GSYConstant.textStyle(color: '#333333'),)

                SizedBox(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        // commonlyUsedIsHidden = false;
                        diagnosisListIsHidden = true;
                        checkedDiagnosisIsHidden = checkedDataList.length >0 ? false : true;
                      });
                  },
                    style: TextButton.styleFrom(
                      alignment: Alignment.center,
                      padding:EdgeInsets.zero,
                      // backgroundColor: Colors.red,
                    ),
                    child: Text('取消',style: GSYConstant.textStyle(color: '#333333')),),
                  width: 45,
                ),
              ],
          ),),
          Visibility(
            visible: !commonlyUsedIsHidden,
              child: Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left:16.0,top: 24.0,bottom: 16.0),
                child: Text('常用诊断',style: GSYConstant.textStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: '#333333'),),
              ),
          ),
          Visibility(
            visible: !commonlyUsedIsHidden,
              child: Wrap(
                  runSpacing: 8.0,
                  spacing: 8.0,
                  children:commonList.map((item) =>CustomElevatedButton(elevation:0,title: item['title'],
                    onPressed: (){

                    },height: 29.0,primary: '#F7F7F7',textStyle: GSYConstant.textStyle(color: '#666666'), borderRadius: BorderRadius.circular(15.0),),
                  ).toList()
              ),
          ),
          Visibility(
            visible: !diagnosisListIsHidden,
              child: Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemBuilder: _renderRow,
                    itemCount: detailDataList.isEmpty ? detailDataList.length : detailDataList.length+1, //显示上啦加载更多控件
                    controller: _scrollController,
                  ),
                ),
              )
          ),
          Visibility(
            visible: !checkedDiagnosisIsHidden,
            child: Expanded(
              child: ListView.builder(
                itemBuilder: (context,index){
                  return Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              flex : 2 ,
                              child: Text(checkedDataList[index]["dianame"], style: GSYConstant.textStyle(color: '#888888'),),
                            ),
                            const SizedBox(width: 10.0,),
                            Expanded(
                              flex : 1 ,
                              child:Text(checkedDataList[index]["diacode"], style: GSYConstant.textStyle(color: '#333333'),),

                            ),
                            const SizedBox(width: 10.0,),
                            Expanded(
                              flex : 2 ,
                              child:Text(checkedDataList[index]["diadesc"], style: GSYConstant.textStyle(color: '#333330'),),
                            )
                          ],
                        ),
                      ),
                      Divider(color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),)
                    ],
                  );
                },
                itemCount: checkedDataList.length,
              ) ,

            ),
          ),
          Visibility(
            visible: !checkedDiagnosisIsHidden,
            child:
            Container(
            margin: const EdgeInsets.only(bottom:30.0),
            alignment: Alignment.bottomCenter,
            child: SafeAreaButton(text: '确认', onPressed:(){

              Navigator.of(context).pop(checkedDataList);

            }),
          ),),
        ],
      ),
    );
  }
}
