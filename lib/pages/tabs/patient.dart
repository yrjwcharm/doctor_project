import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/app_bar_utils.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Patient extends StatefulWidget {
  const Patient({Key? key}) : super(key: key);

  @override
  PatientState createState() => PatientState();
}

class PatientState extends State<Patient> {
  List list = [];
  ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数
  bool isLoading = false; //是否正在加载数据
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
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        list = List.generate(15, (i) => '哈喽,我是原始数据 $i');
      });
    });
  }

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 3), () {
      print('refresh');
      setState(() {
        list = List.generate(20, (i) => '哈喽,我是新刷新的 $i');
      });
    });
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < list.length) {
      return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Column(children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(
                  'static/images/home/avatar.png',
                ),
              ),
              contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
              trailing: const Image(
                image: AssetImage('static/images/my/more.png'),
                width: 8.0,
                height: 14.0,
              ),
              tileColor: Colors.white,
              subtitle: Text(
                '诊断：上呼吸道感染',
                style: GSYConstant.textStyle(color: '333333'),
              ),
              title: Row(
                children: [
                  Text('张灿灿',
                      style: GSYConstant.textStyle(
                          fontFamily: 'PingFangSC-Medium PingFang SC',
                          color: '#333333')),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    '女',
                    style: GSYConstant.textStyle(color: '#666666'),
                  ),
                  Text(
                    '｜',
                    style: GSYConstant.textStyle(color: '#666666'),
                  ),
                  Text(
                    '39岁',
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
                  Expanded(
                      child: Text('图文问诊',
                          style: GSYConstant.textStyle(color: '#666666'))),
                  Text('2022-01-04 15:36:46',
                      style: GSYConstant.textStyle(color: '#666666')),
                ]))
          ]));
    }
    return _getMoreWidget();
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
          children: const <Widget>[
            Text(
              '加载中...',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }
  /**
   * 上拉加载更多
   */
  Future _getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 1), () {
        print('加载更多');
        setState(() {
          list.addAll(List.generate(5, (i) => '第$_page次上拉来的数据'));
          _page++;
          isLoading = false;
        });
      });
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
      body: Column(
        children: [
          AppBarUtil.customAppBar(context, '我的患者'),
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
