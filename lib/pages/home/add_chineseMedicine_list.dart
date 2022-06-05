import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../http/api.dart';
import '../../utils/colors_utils.dart';
import '../../utils/svg_util.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:doctor_project/pages/home/use_drug_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doctor_project/widget/safe_area_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../widget/numberwidget.dart';


class AddChineseMedicineList extends StatefulWidget {

  List selectedDrugList ; //中药选中的药品列表数据
  AddChineseMedicineList({Key? key, required this.selectedDrugList}) : super(key: key);

  @override
  _AddChineseMedicineListState createState() => _AddChineseMedicineListState(selectedDrugList: this.selectedDrugList);
}

class _AddChineseMedicineListState extends State<AddChineseMedicineList> {

  List selectedDrugList ;
  _AddChineseMedicineListState({required this.selectedDrugList});

  final TextEditingController _editingController1 = TextEditingController(); //搜索关键词TF
  final FocusNode _contentFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController(); //listview的控制器

  double screenWidth = window.physicalSize.width;
  double ratio = window.devicePixelRatio;
  bool tab1Active = true;
  bool tab2Active = false;
  int type = 1; //类型（1医保内，2医保外）
  int _page = 1; //加载的页数
  int pageSize = 15 ; //一页显示条数
  bool isLoading = false; //判断 loading框是否隐藏
  String loadText = ""; //加载时显示的文字
  bool drugListIsHidden = true ; //药品列表是否隐藏
  bool selectedDrugIsHidden = true ; //选中药品列表是否隐藏

  List commonlyUsedList = [
    {"title" : "[阿莫灵]阿莫西林胶囊 0.25*24粒/盒", "description" : "口服：一次3粒，4次/天"},
    {"title" : "[阿莫灵]阿莫西林胶囊 0.25*24粒/盒", "description" : "口服：一次3粒，4次/天"},
    {"title" : "[阿莫灵]阿莫西林胶囊 0.25*24粒/盒", "description" : "口服：一次3粒，4次/天"},
    {"title" : "[阿莫灵]阿莫西林胶囊 0.25*24粒/盒", "description" : "口服：一次3粒，4次/天"},
    {"title" : "[阿莫灵]阿莫西林胶囊 0.25*24粒/盒", "description" : "口服：一次3粒，4次/天"},
    {"title" : "[阿莫灵]阿莫西林胶囊 0.25*24粒/盒", "description" : "口服：一次3粒，4次/天"},
  ];//常用药品列表数据
  Map dataMap = new Map(); //药品列表数据
  List detailDataList = []; //药品列表数据

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        _getMore();
      }
    });
  }

  void getNet_drugList () async{

    SharedPreferences perfer = await SharedPreferences.getInstance();
    String? tokenValueStr = perfer.getString("tokenValue");
    print("111111" + tokenValueStr.toString());

    var dio = new Dio();
    dio.options.headers = {
      "token": tokenValueStr,
    };

    String urlStr =Api.BASE_URL+ "/doctor/dr-service/herbalMedicine/getList?keyword=" + _editingController1.text + "&type=" +type.toString() +"&page=" +_page.toString() + "&size=" +pageSize.toString();
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
        drugListIsHidden = false ;
        selectedDrugIsHidden = true ;
        detailDataList.addAll(dataMap["records"]);
      });


      if(dataMap["records"].length <pageSize || _page ==totalPage){

        loadText = "没有更多数据";
        isLoading = false ;
      }else{
        loadText = "上拉加载更多";
        isLoading = false;
      }

      print("data= " + response.data.toString() + "url= " + response.realUri.toString());

    }else{
      Fluttertoast.showToast(msg: response.data['msg'], gravity: ToastGravity.CENTER);
    }
  }

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<void> _onRefresh() async{
    _page = 1 ;
    getNet_drugList();
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

    getNet_drugList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '添加药品',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white
              ),
              padding:
              const EdgeInsets.only(top: 11.0,bottom: 15.0, left: 17.0, right: 16.0),
              child: Row(children: <Widget>[
                Expanded(
                  child: Container(
                    height: 32.0,
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          width: 1.0,
                          color: ColorsUtil.hexStringColor(
                            '#999999',
                          )),
                      borderRadius: BorderRadius.circular(19.0),
                    ),
                    child: TextField(
                      controller: _editingController1,
                      focusNode: _contentFocusNode,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(20) //限制长度
                      ],
                      onChanged: (value) =>
                      {print(_editingController1.text.isNotEmpty)},
                      onEditingComplete: (){

                        _contentFocusNode.unfocus();
                        _page = 1 ;
                        getNet_drugList();
                      } ,

                      style: GSYConstant.textStyle(color: '#666666'),
                      cursorColor: ColorsUtil.hexStringColor('#666666'),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIconConstraints: const BoxConstraints(),
                        prefixIconConstraints:
                        const BoxConstraints(minWidth: 31.0),
                        // isDense: true,
                        isCollapsed: true,
                        prefixIcon: SvgUtil.svg('search.svg'),

                        suffixIcon: _editingController1.text.isNotEmpty
                            ? SvgUtil.svg('delete.svg')
                            : null,
                        hintStyle: GSYConstant.textStyle(color: '#888888'),
                        hintText: '搜索药品名称、拼音码',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: TextButton(
                    onPressed: () {
                      _editingController1.clear();
                      setState(() {

                        if(selectedDrugList.length >0){
                          // commonlyUsedIsHidden = true;
                          selectedDrugIsHidden = false;
                        }else{
                          // commonlyUsedIsHidden = false;
                          selectedDrugIsHidden = true;
                        }
                        drugListIsHidden = true;
                        _contentFocusNode.unfocus();
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
              ]),
            ),
            Visibility(
              visible: !drugListIsHidden,
              child: Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: detailDataList.isEmpty ? detailDataList.length : detailDataList.length+1, //显示上啦加载更多控件
                      itemBuilder: (BuildContext context, int index) {
                        if (index < detailDataList.length){
                          return GestureDetector(
                            onTap: () async{
                              // var request  =HttpRequest.getInstance();
                              // var res  =await request.get(Api.eastDrugInventoryApi+'?id=${detailDataList[index]['medicineid']}',
                              //     {});
                              // if(res['code']==200) {
                              //   detailDataList[index]['stockNum']=res['data']??0;
                              // }
                              if(detailDataList[index]['stockNum']=='0'){
                                return;
                              }
                              setState(() {
                                detailDataList[index]["count"] = 1;
                                selectedDrugList.add(detailDataList[index]);
                                drugListIsHidden = true;
                                selectedDrugIsHidden = false ;
                              });
                            },
                            child: Container(
                              height: 44.0,
                              child: ListTile(
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(detailDataList[index]["medicinename"] +" " +detailDataList[index]["specification"] +"  ", style: GSYConstant.textStyle(color: '#333333'),),
                                      Expanded(child: Text(detailDataList[index]["manuname"],style: GSYConstant.textStyle(color: '#999999'),overflow: TextOverflow.ellipsis,maxLines: 1,),),
                                    ],
                                  ),
                                  trailing: TextButton(onPressed: null,
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.centerRight,
                                      padding:EdgeInsets.zero,
                                    ),
                                    child: SvgUtil.svg('add_drug.svg'),)
                              ),
                              decoration: BoxDecoration(
                                  color:detailDataList[index]['stockNum']=='0'?Colors.grey: Colors.white,
                                  border: Border(bottom: BorderSide(width: 1.0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)))
                              ),
                            ),
                          );

                        }
                        return _getMoreWidget();

                      }),
                ),
              ),
            ),
            
            Visibility(
              visible: !selectedDrugIsHidden,
                child: Expanded(
                  child: ListView.builder(
                      itemCount: selectedDrugList.length,
                      itemBuilder: (BuildContext context, int index){
                        return Slidable(
                            endActionPane:  ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  // An action can be bigger than the others.
                                  // flex: 2,
                                  onPressed: (BuildContext context){
                                    setState(() {
                                      selectedDrugList.removeAt(index);
                                      if(selectedDrugList.isEmpty){
                                        drugListIsHidden = true ;
                                        selectedDrugIsHidden = true ;
                                      }
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
                          margin: const EdgeInsets.only(bottom: 1.0),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 14.0, left: 16.0, right: 16.0),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    selectedDrugList[index]["medicinename"],
                                    style: GSYConstant.textStyle(
                                        fontSize: 15.0, color: '#333333'),
                                  ),
                                  const SizedBox(
                                    height: 6.0,
                                  ),
                                  Text(
                                    '规格：' +selectedDrugList[index]["specification"],
                                    style: GSYConstant.textStyle(
                                        fontSize: 13.0, color: '#888888'),
                                  ),
                                  Text(
                                    selectedDrugList[index]["manuname"],
                                    style: GSYConstant.textStyle(
                                        fontSize: 13.0, color: '#888888'),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  NumberControllerWidget(
                                    // iconWidth:10,
                                    numText: selectedDrugList[index]['count'].toString(),
                                    addValueChanged: (num){

                                    },
                                    removeValueChanged: (num){
                                    },
                                    updateValueChanged: (num){
                                      setState(() {
                                        selectedDrugList[index]['count']=num;
                                      });
                                      // setState(() {
                                      //   _productNum = num;
                                      //   setState(() {
                                      //     _saleprice = _productNum * widget.saleprice;
                                      //   });
                                      // });
                                    },
                                  ),
                                  const SizedBox(height: 10.0,),
                                  Text(
                                    '库存：${selectedDrugList[index]["stockNum"].toString().isEmpty?'0':selectedDrugList[index]["stockNum"].toString()}' ,
                                    style: GSYConstant.textStyle(
                                        color: '#888888', fontSize: 13.0),
                                  )
                                ],
                              )
                            ],
                          ),
                        ));
                      }),
                ),),

            Visibility(
              visible: !selectedDrugIsHidden,
              child:
              Container(
                margin: const EdgeInsets.only(bottom:30.0),
                alignment: Alignment.bottomCenter,
                child: SafeAreaButton(text: '确认', onPressed:(){

                  Navigator.of(context).pop(selectedDrugList);

                }),
              ),),

          ],
        ),
    );
  }
}

