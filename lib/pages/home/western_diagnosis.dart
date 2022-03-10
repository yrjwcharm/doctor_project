import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WesternDiagnosis extends StatefulWidget {
  const WesternDiagnosis({Key key}) : super(key: key);

  @override
  _DiagnosisState createState() => _DiagnosisState();
}

class _DiagnosisState extends State<WesternDiagnosis> {
  List list = [];
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数
  bool isLoading = false;
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
  //获取列表数据
  Widget _renderRow(BuildContext context, int index) {
    if (index < list.length) {
      return Column(
        children: [
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('内科', style: GSYConstant.textStyle(color: '#888888'),),
                const SizedBox(width: 10.0,),
                Text(
                  'P92.500', style: GSYConstant.textStyle(color: '#333333'),),
                const SizedBox(width: 10.0,),
                Text('风寒感冒', style: GSYConstant.textStyle(color: '#333330'),)
              ],
            ),
            trailing: Image.asset(
              'assets/images/my/more.png', fit: BoxFit.cover,
              width: 16.0,
              height: 16.0,),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 16.0),
                width: 298,
                child: TextField(
                  onChanged: (text) {},
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 16.0,right:16.0,top:6.0,bottom:6.0),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(19.0),
                          borderSide: BorderSide.none),
                      hintText: '搜索ICD名称、拼音码',
                      hintStyle: GSYConstant.textStyle(color: '#999999'),
                      fillColor: ColorsUtil.hexStringColor('#f9f9f9'),
                      isCollapsed: true),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child:Text(
                  '取消',
                  style: GSYConstant.textStyle(color: '#333333'),
                ),
              ),
            ],
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
