import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:doctor_project/pages/my/write-caseDetail.dart';
import '../../http/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../utils/toast_util.dart';

class MyPrescription extends StatefulWidget {
  const MyPrescription({Key? key}) : super(key: key);

  @override
  _MyPrescriptionState createState() => _MyPrescriptionState();
}

class _MyPrescriptionState extends State<MyPrescription> {
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  List list =[];
  List tabList =[
    {'label':'全部','checked':true,'value':''},
    {'label':'审核中','checked':false,'value':'1'},
    {'label':'已审核','checked':false,'value':'2'},
    {'label':'待支付','checked':false,'value':'3'},
    {'label':'已取消','checked':false,'value':'4'},
  ];
  int _page = 1; //加载的页数
  bool isMore = true; //是否正在加载数据
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

  /**
   * 初始化list数据 加延时模仿网络请求
   */
  Future getData() async {
    var request = HttpRequest.getInstance();
    var res = await request.get(
        Api.getRpListApi, {});
    if (res['code'] == 200) {
      setState(() {
        list = res['data']['records'];
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
          Api.getRpListApi,
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
      appBar: CustomAppBar('我的处方',onBackPressed: (){
        Navigator.pop(context);
      },
      ),
      body:Column(
        children: <Widget>[
            Container(
              height: 48.0,
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: tabList.map((item) => GestureDetector(
                  onTap:(){
                    tabList.map(($item) => {
                      $item['checked']=false,
                      if (mapEquals($item, item))
                        $item['checked'] = true,
                    });
                    setState(() {

                    });

                  },
                  child: Text(item['label'],style: GSYConstant.textStyle(fontSize:15.0,color:item['checked']?'#06B48D':'#333333',fontWeight:item['checked']? FontWeight.w500:FontWeight.w400,fontFamily:item['checked']? 'Medium':'Regular' ),),

                ),).toList(),
              ),
            ),
          Expanded(child:
          RefreshIndicator(
            displacement: 10.0,
            onRefresh: _onRefresh,
            child:  ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        height: 100.0,
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 16.0,top: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ClipOval(child: Image(image: AssetImage('assets/images/home/avatar.png'),fit: BoxFit.cover,width: 40.0,height: 40.0,),),
                            const SizedBox(width: 16.0,),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(children: [
                                    Text('李史市',style: TextStyle(
                                        fontSize:14.0,
                                        fontFamily: 'Medium',
                                        fontWeight: FontWeight.w400,
                                        color: ColorsUtil.hexStringColor('#333333')
                                    )),
                                    const SizedBox(width: 16.0,),
                                    Text('男 | 22岁 | 内科',style: GSYConstant.textStyle(color: '#666666'),),
                                  ],),
                                  const SizedBox(height: 4.0,),
                                  Text('处方编号：9899008766',style: GSYConstant.textStyle(color: '#333333'),),
                                  const SizedBox(height: 4.0,),
                                  Text('最近诊断：上呼吸道感染',style: GSYConstant.textStyle(color: '#333333'),),
                                ],),),
                            const SizedBox(width: 10.0,),
                            Text(list[index],  style: GSYConstant.textStyle(color: '#DE5347'),),
                            const SizedBox(width: 16.0,),
                          ],),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(width: 1.0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)))
                        ),
                      ),
                      Container(
                        height: 42.0,
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 16.0),
                        alignment: Alignment.centerLeft,
                        color: Colors.white,
                        child: Text('2022-01-04 15:36:46',style: GSYConstant.textStyle(color: '#666666'),),
                      ),
                      const SizedBox(
                        height: 8.0,
                        width: double.infinity,
                      ),
                    ],);
                })
          ),)
        ],
      ),
    );
  }
}
