import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/utils/toast_util.dart';
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

class AddDrugList extends StatefulWidget {

  Map instructionsMap ; //药品使用方法列表（用量、服药单位、用法等）
  String pharmacyId;
  AddDrugList({Key? key, required this.instructionsMap,required this.pharmacyId}) : super(key: key);

  @override
  _AddDrugListState createState() => _AddDrugListState(instructionsMap: this.instructionsMap,pharmacyId: this.pharmacyId);
}

class _AddDrugListState extends State<AddDrugList> {

  Map instructionsMap ; //药品使用方法列表（用量、服药单位、用法等// ）
  String pharmacyId;
  _AddDrugListState({required this.instructionsMap,required this .pharmacyId});

  final TextEditingController _editingController = TextEditingController();
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
  bool drugListIsHidden = false ; //药品列表是否隐藏

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

    var dio = Dio();
    dio.options.headers = {
      "token": tokenValueStr,
    };
    print('54689,${type}');
    String urlStr =Api.BASE_URL+ "/doctor/dr-service/medicine/getList?keyword=" + _editingController.text + "&type=" +type.toString() +"&page=" +_page.toString() + "&size=" +pageSize.toString()+'&pharmacyId=$pharmacyId';
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
                      controller: _editingController,
                      focusNode: _contentFocusNode,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(20) //限制长度
                      ],
                      onChanged: (value) =>
                      {print(_editingController.text.isNotEmpty)},
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

                        suffixIcon: _editingController.text.isNotEmpty
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
                      setState(() {
                        // drugListIsHidden = true;
                        _editingController.clear();
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
            // Visibility(
            //   visible: drugListIsHidden,
            //   child: Container(
            //       width: double.infinity,
            //       decoration: const BoxDecoration(
            //           color: Colors.white
            //       ),
            //       padding: const EdgeInsets.only(left: 16.0),
            //       child: Text('常用药',style: GSYConstant.textStyle(fontSize: 15.0,color: '#333333'),),
            //     ),
            // ),

            // Visibility(
            //   visible: drugListIsHidden,
            //   child: Expanded(
            //     child: ListView.builder(
            //         shrinkWrap: true,
            //         itemCount: 5,
            //         itemBuilder: (BuildContext context, int index) {
            //           return Container(
            //             height: 68.0,
            //             padding: const EdgeInsets.only(left: 16.0),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: <Widget>[
            //                 Text('[阿莫灵]阿莫西林胶囊 0.25*24粒/盒',style: GSYConstant.textStyle(color: '#333333'),),
            //                 Text('口服：一次3粒，4次/天',style: GSYConstant.textStyle(fontSize: 13.0,color: '#888888'),)
            //               ],),
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 border: Border(bottom: BorderSide(width: 1.0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)))
            //             ),
            //           );
            //         }),
            //   ),
            // ),

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

                                if(int.parse(detailDataList[index]['stockNum'])==0){
                                  return;
                                }
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) =>
                                        UseDrugInfo(
                                          drugInfoMap: detailDataList[index],
                                          instructionsMap: instructionsMap,)));

                            },
                            child: Container(
                              height: 60.0,
                              padding: const EdgeInsets.only(left: 16.0),
                              child: ListTile(
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(detailDataList[index]["medicinename"] +" " +detailDataList[index]["specification"] +"  ", style: GSYConstant.textStyle(fontSize: 14.0,color:int.parse(detailDataList[index]['stockNum'])==0?'#999999': '#333333'),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                      Expanded(child: Text(detailDataList[index]["manuname"],style: GSYConstant.textStyle(fontSize: 14.0,color: '#999999'),overflow: TextOverflow.ellipsis,maxLines: 1,),),
                                    ],
                                  ),
                                  trailing: TextButton(onPressed: null,
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.centerRight,
                                      padding:EdgeInsets.zero,
                                    ),
                                    child:int.parse(detailDataList[index]['stockNum'])==0?SvgUtil.svg('add_graydrug.svg'): SvgUtil.svg('add_drug.svg'),
                                  ),
                                  subtitle: Text("库存:"+detailDataList[index]['stockNum'],style:GSYConstant.textStyle(fontSize: 11.0,color:int.parse(detailDataList[index]['stockNum'])==0?'#999999': '#666666')),
                              ),
                              decoration: BoxDecoration(
                                  color:Colors.white,
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

          ],
        ),
    );
  }
}

