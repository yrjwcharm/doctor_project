import 'dart:convert';

import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/model/diagnosis_data_modal.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:record/record.dart';

import '../../common/style/gsy_style.dart';
import '../../http/api.dart';
import '../../utils/svg_util.dart';
import '../../widget/custom_safeArea_button.dart';

class ChooseDiagnosis extends StatefulWidget {
  const ChooseDiagnosis({Key? key}) : super(key: key);

  @override
  _ChooseDiagnosisState createState() => _ChooseDiagnosisState();
}

class _ChooseDiagnosisState extends State<ChooseDiagnosis> {
  final TextEditingController _editingController = TextEditingController();
  String keywords = '';
  int _page = 1; //加载的页数
  bool isMore = true; //是否正在加载数据
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  List<Records> list = [];
  List<Records> filterList = [];

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
    var response = await HttpRequest.getInstance().get(
        Api.getDiagnosisList + '?keyword=$keywords&type=&page=$_page&size=10',
        {});
    var res = DiagnosisDataModal.fromJson(response);
    if (res.code == 200) {
      setState(() {
        list = (res.data?.records)!;
        isMore = true;
      });
    } else {
      // ToastUtil.showToast(msg: res['msg']);
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
      var response = await HttpRequest.getInstance().get(
          Api.getDiagnosisList + '?keyword=$keywords&type=&page=$_page&size=10',
          {});
      var res = DiagnosisDataModal.fromJson(response);

      if (res.code == 200) {
        var total = (res.data?.total)!;
        var size = (res.data?.size)!;
        int totalPage = (total / size).ceil();
        if (_page <= totalPage) {
          setState(() {
            list.addAll((res.data?.records)!);
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

  Widget _renderRow(BuildContext context, int index) {
    String dianame = list[index].dianame!;
    bool isSelected = list[index].isSelected!;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3)))),
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 12.0, bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              dianame,
              style: GSYConstant.textStyle(fontSize: 14.0, color: '#333333'),
            ),
          ),
          CustomIconButton(
            icon: isSelected
                ? SvgUtil.svg('add_zd_symbol.svg')
                : SvgUtil.svg('add_zhenduan.svg'),
            onPressed: () {
              if (!isSelected) {
                list.forEach((item) => {
                      if (item.id == list[index].id) {item.isSelected = true}
                    });
                filterList.add(list[index]);
                setState(() {
                  list = list;
                  filterList=filterList;
                });
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar('添加诊断'),
        backgroundColor: ColorsUtil.bgColor,
        body: Column(children: <Widget>[
          // const SizedBox(height: 10.0,),
          Container(
            color: Colors.white,
            height: 43.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 32.0,
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorsUtil.bgColor,
                      borderRadius: BorderRadius.circular(19.0),
                    ),
                    child: TextField(
                      controller: _editingController,
                      // focusNode: _contentFocusNode,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(20) //限制长度
                      ],
                      onChanged: (value) => {
                        setState(() {
                          keywords = value;
                        }),
                        getData()
                      },
                      onEditingComplete: () {},
                      style: GSYConstant.textStyle(color: '#666666'),
                      cursorColor: ColorsUtil.hexStringColor('#666666'),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIconConstraints: const BoxConstraints(),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 31.0),
                        isCollapsed: true,
                        prefixIcon: SvgUtil.svg('search.svg'),
                        suffixIcon: keywords.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _editingController.clear();
                                  setState(() {
                                    keywords = '';
                                  });
                                  getData();
                                },
                                child: SvgUtil.svg('delete.svg'))
                            : const SizedBox.shrink(),
                        hintStyle: GSYConstant.textStyle(color: '#888888'),
                        hintText: '搜索ICD名称、拼音码',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(16.0),
                ),
                TextButton(
                    onPressed: () {
                      _editingController.clear();
                      setState(() {
                        keywords = '';
                      });
                      getData();
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      '取消',
                      style: GSYConstant.textStyle(color: '#333333'),
                    ))
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              displacement: 10.0,
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: _renderRow,
                itemCount: list.length,
                controller: _scrollController,
              ),
            ),
          ),
          list.isNotEmpty?CustomSafeAreaButton(
            margin: const EdgeInsets.only(bottom: 16.0),
            onPressed: () {
              if(filterList.isEmpty){
                ToastUtil.showToast(msg: '请选择诊断');
                return;
              }
              final jsonList = filterList.map((item) => jsonEncode(item)).toList();
              // using toSet - toList strategy
              final uniqueJsonList = jsonList.toSet().toList();
              //去除重复元素
              print('33333,${uniqueJsonList.toString()}');
              Records records=uniqueJsonList[0] as Records;
              records.isMaster = 1;
              Navigator.pop(context,uniqueJsonList);
            },
            title: '添加',
          ):const SizedBox.shrink()
        ]));
  }
}
