import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/add_multi_diagnosis.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widget/custom_elevated_button.dart';

class Diagnosis extends StatefulWidget {
  const Diagnosis({Key? key}) : super(key: key);

  @override
  _DiagnosisState createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  List list = [];
  List commonList =[{'title':'风寒感冒'},{'title':'糖尿病'},{'title':'腰肌劳损'},{'title':'痛风'}];
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数
  bool isLoading = false;
  final TextEditingController _editingController = TextEditingController();
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
            trailing: TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddMultiDiagnosis()));
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
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(20)//限制长度
                    ],
                    onChanged: (value)=>{
                      print(_editingController.text.isNotEmpty)
                    },
                    style:GSYConstant.textStyle(color: '#666666'),
                    cursorColor: ColorsUtil.hexStringColor('#666666'),
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
                const SizedBox(width: 16.0,),
                Text('取消',style: GSYConstant.textStyle(color: '#333333'),)
              ]
          ),),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left:16.0,top: 24.0,bottom: 16.0),
            child: Text('常用诊断',style: GSYConstant.textStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: '#333333'),),
          ),
          Wrap(
            runSpacing: 8.0,
            spacing: 8.0,
            children:commonList.map((item) =>CustomElevatedButton(elevation:0,title: item['title'], onPressed: (){
            },height: 29.0,primary: '#F7F7F7',textStyle: GSYConstant.textStyle(color: '#666666'), borderRadius: BorderRadius.circular(15.0),),
            ).toList()
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
