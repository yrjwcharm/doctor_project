import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/my/rp_detail.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/common_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:doctor_project/pages/my/write_case_detail.dart';
import '../../http/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../utils/toast_util.dart';

class MyPrescription extends StatefulWidget {
  final String userId;

  const MyPrescription({Key? key, required this.userId}) : super(key: key);

  @override
  _MyPrescriptionState createState() => _MyPrescriptionState(this.userId);
}

class _MyPrescriptionState extends State<MyPrescription> {
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  List list = [];
  String status = '';
  List tabList = [
    {'label': '全部', 'checked': true, 'value':''},
    {'label': '审核中', 'checked': false, 'value': '4'},
    {'label': '已审核', 'checked': false, 'value': '3'},
    {'label': '未通过', 'checked': false, 'value': '2'},
    // {'label': '已撤销', 'checked': false, 'value': '1'},
    // {'label':'已失效','checked':false,'value':'5'},
    {'label': '已取消', 'checked': false, 'value': '6'},
  ];
  String userId;

  _MyPrescriptionState(this.userId);

  int _page = 1; //加载的页数
  bool isMore = true; //是否正在加载数据
  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        _getMore();
      }
    });
  }

  /**
   * 初始化list数据 加延时模仿网络请求
   */
  Future getData() async {
    var request = HttpRequest.getInstance();
    var res = await request.get(
        Api.getRpListApi +
            '?status=$status&page=$_page&size=10',
        {});
    if (res['code'] == 200) {
      setState(() {
        list = res['data']['records'];
        print('list--------'+list.toString());
        isMore = true;
      });
    } else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<void> _onRefresh() async {
    setState(() {
      _page = 1;
    });
    getData();
  }

  Future _getMore() async {
    if (isMore) {
      _page += 1;
      var request = HttpRequest.getInstance();
      var res = await request.get(
          Api.getRpListApi +
              '?status=$status&page=$_page&size=10',
          {});
      if (res['code'] == 200) {
        var total = res['data']['total'];
        var size = res['data']['size'];
        int totalPage = (total / size).ceil();
        if (_page <= totalPage) {
          setState(() {
            list.addAll(res['data']['records']);
            isMore = true;
            _page;
          });
        } else {
          setState(() {
            isMore = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '我的处方',
      
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 48.0,
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: tabList
                  .map(
                    (item) => GestureDetector(
                      onTap: () {
                        tabList.forEach(($item) => {
                              $item['checked'] = false,
                              if (mapEquals($item, item))
                                $item['checked'] = true,
                            });
                        status = item['value'];
                        setState(() {
                          // tabList=tabList;
                        });
                        getData();
                      },
                      child: Text(
                        item['label'],
                        style: GSYConstant.textStyle(
                            fontSize: 15.0,
                            color: item['checked'] ? '#06B48D' : '#333333',
                            fontWeight: item['checked']
                                ? FontWeight.w500
                                : FontWeight.w400,
                            fontFamily: item['checked'] ? 'Medium' : 'Regular'),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
                displacement: 10.0,
                onRefresh: _onRefresh,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: list.length,
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      var item = list[index];
                      String prescriptionId = item['id'].toString();
                      String registeredId = item['registerId'].toString();
                      List<String>  diagnosis = [];
                      (item['diagnosisVOS']??[]).forEach((element) {
                          diagnosis.add(element['diagnosisName']);
                      });
                      String str = '';
                      diagnosis.forEach((f){
                        if(str == ''){
                          str = "$f";
                        }else {
                          str = "$str"",""$f";
                        }
                      });

                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>  RecipeDetail(rpDetailItem: {...item},diagnosis:str,prescriptionId:prescriptionId,registeredId:registeredId))).then((value) => {
                            getData()
                          });
                        },
                          child: Column(
                        children: [
                          Container(
                            // height: 100.0,
                            width: double.infinity,
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 16.0,bottom: 13.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipOval(
                                  child:item['photo'].isNotEmpty?Image.network(item['photo'],width: 40.0,height: 40.0,):(item['sex']=='1'?Image.asset('assets/images/boy.png'):Image.asset('assets/images/girl.png'))
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Text(item['name']??'',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'Medium',
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      ColorsUtil.hexStringColor(
                                                          '#333333'))),
                                          const SizedBox(
                                            width: 16.0,
                                          ),
                                          Text(
                                            '${item['sex'] == '1' ? '男' : '女'} | ${item['age']}岁 | ${item['deptName']}',
                                            style: GSYConstant.textStyle(
                                                color: '#666666'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        '处方编号：${item['recipeNo']}',
                                        style: GSYConstant.textStyle(
                                            color: '#333333'),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        '最近诊断：$str',
                                        style: GSYConstant.textStyle(
                                            color: '#333333'),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                    item['status'] == 1
                                        ? '撤销'
                                        : item['status'] == 2
                                            ? '未通过'
                                            : item['status'] == 3
                                                ? '已审核'
                                                : item['status'] == 4
                                                    ? '审核中'
                                                    : item['status'] == 5
                                                        ? '审核超时'
                                                        : '已取消',
                                    style:
                                        GSYConstant.textStyle(color: '#DE5347'),
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.5,
                                        color: ColorsUtil.hexStringColor(
                                            '#cccccc',
                                            alpha: 0.3)))),
                          ),
                          Container(
                            height: 42.0,
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 16.0),
                            alignment: Alignment.centerLeft,
                            color: Colors.white,
                            child: Text(
                              item['repictDate'],
                              style: GSYConstant.textStyle(color: '#666666'),
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                            width: double.infinity,
                          ),
                        ],
                      ));
                    })),
          )
        ],
      ),
    );
  }
}
