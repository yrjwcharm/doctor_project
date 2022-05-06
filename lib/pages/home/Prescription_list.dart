import 'package:doctor_project/http/api.dart';
import 'package:doctor_project/http/http_request.dart';
import 'package:doctor_project/pages/home/prescription_detail.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/style/gsy_style.dart';
import '../../utils/toast_util.dart';
import '../my/rp_detail.dart';

class PrescriptionList extends StatefulWidget {
  const PrescriptionList({Key? key, required this.registeredId, required this.category}) : super(key: key);
  final String registeredId ; //挂号Id
  final String category ; //处方类别（1-西药/中成药，2-中药）
  @override
  _PrescriptionListState createState() => _PrescriptionListState(this.registeredId,this.category);
}

class _PrescriptionListState extends State<PrescriptionList> {
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  String registerId;
  List list =[];
  String category;
  _PrescriptionListState(this.registerId,this.category);
  @override
  void initState() {
    super.initState();
    initData();
  }

  /**
   * 初始化list数据 加延时模仿网络请求
   */
  Future initData() async {
    var request = HttpRequest.getInstance();
    var res = await request
        .get(Api.prescriptionListUrl +"?registerId=" +registerId +"&category=" +category,{});
    if (res['code'] == 200) {
      setState(() {
        list = res['data'];
      });
    } else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  // /**
  //  * 下拉刷新方法,为list重新赋值
  //  */
  // Future<void> _onRefresh() async {
  //   setState(() {
  //     _page = 1;
  //   });
  //   getData();
  // }
  //
  // Future _getMore() async {
  //   if (isMore) {
  //     _page += 1;
  //     var request = HttpRequest.getInstance();
  //     var res = await request
  //         .get(Api.prescriptionListUrl +"?registerId=" +registerId +"&category=" +category,{});
  //     if (res['code'] == 200) {
  //       var total = res['data']['total'];
  //       var size = res['data']['size'];
  //       int totalPage = (total / size).ceil();
  //       if (_page <= totalPage) {
  //         setState(() {
  //           list.addAll(res['data']['records']);
  //           isMore = true;
  //           _page;
  //         });
  //       } else {
  //         setState(() {
  //           isMore = false;
  //         });
  //       }
  //     }
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   _scrollController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        '处方列表',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = list[index];
                      List<String> diagnosis = [];
                      (item['diagnosisVOS'] ?? []).forEach((element) {
                        diagnosis.add(element['diagnosisName']);
                      });
                      print('111111111$diagnosis');
                      String str = '';
                      diagnosis.forEach((f) {
                        if (str == '') {
                          str = "$f";
                        } else {
                          str = "$str" "," "$f";
                        }
                      });

                      return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipeDetail(rpDetailItem: item, diagnosis: str))).then((value) => initData());
                          },
                          child: Column(
                            children: [
                              Container(
                                // height: 100.0,
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    left: 16.0, top: 16.0, bottom: 13.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipOval(
                                        child: item['photo']!=null
                                            ? Image.network(
                                                item['photo'],
                                                width: 40.0,
                                                height: 40.0,
                                              )
                                            : (item['sex'] == '1'
                                                ? Image.asset(
                                                    'assets/images/boy.png')
                                                : Image.asset(
                                                    'assets/images/girl.png'))),
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
                                              Text(item['name'] ?? '',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Medium',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: ColorsUtil
                                                          .hexStringColor(
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
                                      style: GSYConstant.textStyle(
                                          color: '#DE5347'),
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
                                            width: 1.0,
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
                                  style:
                                      GSYConstant.textStyle(color: '#666666'),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                                width: double.infinity,
                              ),
                            ],
                          ));
                    })),
        ],
      ),
    );
  }
}
