import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'order_detail.dart';
import 'package:flutter/services.dart';

class PatientConsult extends StatefulWidget {
   const PatientConsult({Key? key, required this.type}) : super(key: key);
   final String type;
  @override
  _PatientConsultState createState() => _PatientConsultState(type);
}

class _PatientConsultState extends State<PatientConsult> {
  bool tab1Active = true;
  bool tab2Active = false;
  List list = [];
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数
  bool isLoading = false;
  String type;
  _PatientConsultState(this.type);

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

  Widget _renderRow(BuildContext context, int index) {
    if (index < list.length) {
      return Container(
          margin: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
          child: Column(
            children: [
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const OrderDetail()));
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                subtitle: Text(
                  '健康咨询',
                  style:
                  GSYConstant.textStyle(fontSize: 13.0, color: '#666666'),
                ),
                title: Row(mainAxisSize: MainAxisSize.max, children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          '张可可',
                          style: GSYConstant.textStyle(
                              color: '#333333', fontSize: 15.0),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          '男',
                          style: GSYConstant.textStyle(
                              fontSize: 13.0, color: '#666666'),
                        ),
                        Text(
                          '｜',
                          style: GSYConstant.textStyle(
                              fontSize: 13.0, color: '#666666'),
                        ),
                        Text(
                          '43岁',
                          style: GSYConstant.textStyle(
                              fontSize: 13.0, color: '#666666'),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/home/photograph.png',
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        '接诊中',
                        style: GSYConstant.textStyle(color: '#F94C26'),
                      )
                    ],
                  )
                ]),
                leading: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/home/avatar1.png'),
                ),
              ),
              Container(
                  margin:const EdgeInsets.symmetric(horizontal: 7.0),
                  child:RichText(
                    // textScaleFactor: 5,
                    // overflow: TextOverflow.fade,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    text:   TextSpan(
                        children: [
                          TextSpan(
                            text: '病情描述：',
                            style: GSYConstant.textStyle(fontFamily:'Medium',fontSize: 13.0,color:'#333333'),
                          ),
                          TextSpan(
                            text: '最近一个月总是头晕、头痛、疲劳、心悸等，有时还会出现注意力不集中，记忆力减退等现象。',
                            style: GSYConstant.textStyle(fontSize: 13.0,color:'#666666'),
                          )
                        ]
                    ),

                  )
              ),
              const SizedBox(
                height: 9.0,
              ),
              Divider(
                height: 1,
                color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
              ),
              Container(
                height: 47,
                margin:const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2分钟前',style: GSYConstant.textStyle(color: '#888888'),),
                    SizedBox(
                      // width: 77,
                      height: 28,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: ColorsUtil.shallowColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0))
                        ), onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage()));
                      }, child: Text('继续交流',style: GSYConstant.textStyle(fontSize: 13.0),),
                      ),
                    )
                  ],
                ),
              )
            ],
          ));
    }
    return _getMoreWidget();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: [
          CustomAppBar(type=='1'?'患者咨询':type=='2'?'图文问诊':'视频问诊',onBackPressed: (){
            Navigator.pop(context);
          },),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          tab1Active = true;
                          tab2Active = false;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            '接诊中',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          tab1Active
                              ? Container(
                            height: 2,
                            width: 69,
                            decoration: BoxDecoration(
                                color: ColorsUtil.shallowColor,
                                borderRadius: BorderRadius.circular(2.0)),
                          )
                              : const SizedBox()
                        ],
                      ),
                    )),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          tab2Active = true;
                          tab1Active = false;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            '接诊中',
                            style: GSYConstant.textStyle(color: '#333333'),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          tab2Active
                              ? Container(
                            height: 2,
                            width: 69,
                            decoration: BoxDecoration(
                                color: ColorsUtil.shallowColor,
                                borderRadius: BorderRadius.circular(2.0)),
                          )
                              : const SizedBox()
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
