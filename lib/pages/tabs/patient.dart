import 'dart:io';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../http/api.dart';
import '../../http/http_request.dart';
import '../../utils/toast_util.dart';

class Patient extends StatefulWidget {
  const Patient({Key? key}) : super(key: key);

  @override
  PatientState createState() => PatientState();
}

class PatientState extends State<Patient> {
  List list = [];
  bool tab1Active = true;
  bool tab2Active = false;
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数
  bool isMore = true; //是否正在加载数
  String timeSort = 'desc';
  String ageSort = 'desc';
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
    String url = tab1Active
        ? Api.getMyPatientListApi + '?timeSort=$timeSort&page=$_page&size=10'
        : Api.getMyPatientListApi + '?ageSort=$ageSort&page=$_page&size=10';
    var res = await request.get(url, {});
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

  Widget _renderRow(BuildContext context, int index) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Column(children: [
          ListTile(
            leading: Container(
              height: 40.0,
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              width: 40.0,
              child: list[index]['photo'] != null
                  ? Image.network(
                      list[index]['photo'] ?? '',
                      fit: BoxFit.cover,
                    )
                  : list[index]['sex_dictText'] == '男'
                      ? Image.asset('assets/images/boy.png')
                      : Image.asset('assets/images/girl.png'),
            ),
            contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
            trailing: SvgUtil.svg('keyboard_arrow_right.svg'),
            tileColor: Colors.white,
            subtitle: Row(
              children: <Widget>[
                Text(
                  '最近诊断：${list[index]['diagnosis'] ?? ''}',
                  style: GSYConstant.textStyle(color: '#333333'),
                )
              ],
            ),
            title: Row(
              children: [
                Text(list[index]['name'] ?? '',
                    style: GSYConstant.textStyle(
                        fontFamily: 'Medium', color: '#333333')),
                const SizedBox(
                  width: 16.0,
                ),
                Text(
                  list[index]['sex_dictText'] ?? '',
                  style: GSYConstant.textStyle(color: '#666666'),
                ),
                Text(
                  '｜',
                  style: GSYConstant.textStyle(color: '#666666'),
                ),
                Text(
                  '${list[index]['age']}岁',
                  style: GSYConstant.textStyle(color: '#666666'),
                )
              ],
            ),
          ),
          Divider(
              height: 1,
              color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3)),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 43.0,
              child: Row(children: [
                Text('最近：',style: GSYConstant.textStyle(color: '#06b48d'),),
                Text(list[index]['examDate']??'',
                    style: GSYConstant.textStyle(color: '#666666')),
              ]))
        ]));
  }

  Future _getMore() async {
    if (isMore) {
      _page += 1;
      var request = HttpRequest.getInstance();
      String url = tab1Active
          ? Api.getMyPatientListApi + '?timeSort=asc&page=$_page&size=10'
          : Api.getMyPatientListApi + '?ageSort=asc&page=$_page&size=10';
      var res = await request.get(url, {});
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
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        '我的患者',
        isBack: false,
      ),
      body: Column(
        children: [
          Container(
            height: 44.0,
            margin:const EdgeInsets.only(bottom: 8.0),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                  onTap: () {

                    setState(() {
                      tab1Active = true;
                      tab2Active = false;
                      timeSort = timeSort=='desc'?'asc':'desc';
                      _page = 1;
                      list = [];
                    });
                    getData();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '时间',
                        style: GSYConstant.textStyle(
                            color: tab1Active ? '#06b48d' : '#666666'),
                      ),
                      const SizedBox(
                        width: 6.0,
                      ),
                      SvgUtil.svg(
                          tab1Active ? 'selected.svg' : 'un_selected.svg')
                    ],
                  ),
                )),
                SvgUtil.svg('line.svg'),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      ageSort = ageSort=='desc'?'asc':'desc';
                      tab1Active = false;
                      tab2Active = true;
                      _page = 1;
                      list = [];
                    });
                    getData();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '年龄',
                        style: GSYConstant.textStyle(
                            color: tab2Active ? '#06b48d' : '#666666'),
                      ),
                      const SizedBox(
                        width: 6.0,
                      ),
                      SvgUtil.svg(
                          tab2Active ? 'selected.svg' : 'un_selected.svg')
                    ],
                  ),
                ))
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemBuilder: _renderRow,
                itemCount: list.length,
                controller: _scrollController,
              ),
            ),
          )
        ],
      ),
    );
  }
}
