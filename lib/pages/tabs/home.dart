import 'dart:ffi';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/add-drug.dart';
import 'package:doctor_project/pages/home/make_prescription.dart';
import 'package:doctor_project/pages/home/open_service.dart';
import 'package:doctor_project/pages/home/order_detail.dart';
import 'package:doctor_project/pages/home/patient-consult.dart';
import 'package:doctor_project/pages/home/prescription_detail.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/common_utils.dart';
import 'package:doctor_project/utils/platform_utils.dart';
import 'package:doctor_project/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../tools/wechat_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool tab1Active = true;
  bool tab2Active = false;
  List list = [];
  final ScrollController _scrollController = ScrollController(); //listview的控制器
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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderDetail()));
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
                  margin: const EdgeInsets.symmetric(horizontal: 7.0),
                  child: RichText(
                    // textScaleFactor: 5,
                    // overflow: TextOverflow.fade,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    text: TextSpan(children: [
                      TextSpan(
                        text: '病情描述：',
                        style: GSYConstant.textStyle(
                            fontFamily: 'Medium',
                            fontSize: 13.0,
                            color: '#333333'),
                      ),
                      TextSpan(
                        text: '最近一个月总是头晕、头痛、疲劳、心悸等，有时还会出现注意力不集中，记忆力减退等现象。',
                        style: GSYConstant.textStyle(
                            fontSize: 13.0, color: '#666666'),
                      )
                    ]),
                  )),
              const SizedBox(
                height: 9.0,
              ),
              Divider(
                height: 1,
                color: ColorsUtil.hexStringColor('#cccccc', alpha: 0.3),
              ),
              Container(
                height: 47,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '2分钟前',
                      style: GSYConstant.textStyle(color: '#888888'),
                    ),
                    Container(
                      // width: 77,
                      height: 28,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: ColorsUtil.shallowColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0))),
                        onPressed: () {},
                        child: Text(
                          '继续交流',
                          style: GSYConstant.textStyle(fontSize: 13.0),
                        ),
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
    Widget buildColumn(String title, String subTitle) {
      return Expanded(
        child: Column(children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Medium',
                  fontWeight: FontWeight.w500,
                  color: ColorsUtil.hexStringColor('#333333'))),
          const SizedBox(height: 1),
          Text(
            subTitle,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ColorsUtil.hexStringColor("#666666"),
                fontFamily: 'PingFangSC-Regular, PingFang SC'),
          )
        ]),
      );
    }

    Widget buildButtonColumn(String assetName, String label,GestureTapCallback onTap) {
      Color color = ColorsUtil.hexStringColor('#333333');

      return Expanded(
          child: GestureDetector(onTap: onTap, child:Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(assetName),
                fit: BoxFit.cover,
              ),
              Container(
                margin: const EdgeInsets.only(top: 7.0),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'PingFangSC-Regular, PingFang SC',
                    fontWeight: FontWeight.w400,
                    color: color,
                  ),
                ),
              ),
            ],
          ),)

      );
    }

    Widget buildBg = Container(
      height: 183.0,
      decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/home/background.png')),
      ),
      child: Container(
        height: 126.0,
        padding: const EdgeInsets.all(16.0),
        margin: EdgeInsets.only(
            top: PlatformUtils.isIPhoneX(context) ? 66 : 42,
            right: 16.0,
            bottom: 0,
            left: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        transform: Matrix4.translationValues(0, 9, 0),
        child: Column(
          children: [
            Expanded(
              child: Row(children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: const Image(
                    image: AssetImage('assets/images/home/avatar.png'),
                    width: 43,
                    height: 43,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text('王建国',
                                style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        ColorsUtil.hexStringColor('#333333'))),
                            const SizedBox(width: 7),
                            Container(
                                padding: const EdgeInsets.only(
                                    left: 7.0,
                                    right: 8.0,
                                    top: 1.0,
                                    bottom: 1.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: ColorsUtil.hexStringColor(
                                            '#06B48D')),
                                    borderRadius: BorderRadius.circular(9.0)),
                                child: Text('主任医师',
                                    style: TextStyle(
                                        color: ColorsUtil.hexStringColor(
                                            '#06B48D'),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'PingFangSC-Regular, PingFang SC')))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 9),
                        child: Row(children: const <Widget>[
                          Text('北京朝阳医院'),
                          SizedBox(
                            width: 8,
                          ),
                          Text('呼吸内科')
                        ]),
                      )
                    ],
                  ),
                )
              ]),
            ),
            const SizedBox(height: 12),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildColumn('26', '今日已接诊'),
                Container(
                  width: 1,
                  height: 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorsUtil.hexStringColor('#cccccc'),
                          width: 1,
                          style: BorderStyle.solid)),
                ),
                buildColumn('26', '今日待接诊'),
                Container(
                  width: 1,
                  height: 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorsUtil.hexStringColor('#cccccc'),
                          width: 1,
                          style: BorderStyle.solid)),
                ),
                buildColumn('26', '视频预约'),
              ],
            ),
          ],
        ),
      ),
    );
    void _goToHealthHutModular() async {
      const platform = const MethodChannel("flutterPrimordialBrige");
      bool result = false;
      try {
        result = await platform.invokeMethod("jumpToCallVideo"); //分析2
      } on PlatformException catch (e) {
        print(e.toString());
      }
    }
    Widget buttonSection = Container(
      margin: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 8.0, top: 17.0),
      height: 96,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        children: [
          buildButtonColumn('assets/images/home/consult1.png', '患者咨询',(){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> const PatientConsult(type: '1',)));
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> const MakePrescription()));
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddDrug()));
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const PrescriptDetail()));
          }),
          buildButtonColumn('assets/images/home/picture1.png', '图文问诊',(){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const PatientConsult(type: '2',)));
          }),
          buildButtonColumn('assets/images/home/video1.png', '视频问诊',(){
            _goToHealthHutModular();
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> const PatientConsult(type: '3',)));
          }),
        ],
      ),
    );
    Widget noticeSection = Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Expanded(
              child: Row(children: [
            Image.asset('assets/images/home/notice.png', fit: BoxFit.cover),
            Container(
              margin: const EdgeInsets.only(left: 6.0),
              child: Text(
                '北京市区委领导来我区考察、交流…',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorsUtil.hexStringColor('#333333'),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ])),
          Text(
            '今天',
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'PingFangSC-Regular, PingFang SC',
              fontWeight: FontWeight.w400,
              color: ColorsUtil.hexStringColor('#999999'),
            ),
          )
        ],
      ),
    );
    Widget buildTextRow(String label, String value, double fontSize,
        String labelColor, String valueColor) {
      return Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                fontFamily: 'PingFangSC-Regular, PingFang SC',
                color: ColorsUtil.hexStringColor(labelColor),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                fontFamily: 'PingFangSC-Regular, PingFang SC',
                color: ColorsUtil.hexStringColor(valueColor),
              ),
            )
          ],
        ),
      );
    }

    _submitVerify() {
      Fluttertoast.showToast(msg: '资质未通过');
    }

    Widget inPassSection = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin:
              const EdgeInsets.only(top: 0, right: 0, bottom: 13.0, left: 0),
          child: const Image(
            image: AssetImage('assets/images/home/avatar.png'),
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
        ),
        buildTextRow('您的资质申请', '未通过', 14.0, '#666666', '#FF0020'),
        buildTextRow('驳回原因：', '执业医师证书无效', 12.0, '#999999', '#FF3131'),
        Container(
            margin: const EdgeInsets.only(top: 63.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: ColorsUtil.hexStringColor('#06B48D'),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: ColorsUtil.hexStringColor('#06B48D'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
              onPressed: () {
                _submitVerify();
              },
              child: Text(
                '重新提交资质认证',
                style: GSYConstant.textStyle(fontSize: 16.0),
              ),
            ))
      ],
    );
    Widget inOpenSection = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/home/status.png',
          fit: BoxFit.cover,
          width: 134,
          height: 134,
        ),
        Container(
          margin: const EdgeInsets.only(top: 37.0),
          child: Text(
            '您尚未开通问诊服务',
            style: GSYConstant.textStyle(color: '#666666'),
          ),
        ),
        Container(
          height: 44,
          width: 214,
          margin: const EdgeInsets.only(top: 39.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: ColorsUtil.hexStringColor('#06B48D'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0))),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const OpenService()));
            },
            child: Text(
              '立即开通',
              style: GSYConstant.textStyle(fontSize: 16.0),
            ),
          ),
        )
      ],
    );
    Widget adultSection = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/home/status.png',
          fit: BoxFit.cover,
          width: 134,
          height: 134,
        ),
        Container(
          margin: const EdgeInsets.only(top: 37.0),
          child: Text(
            '资质审核中，请您耐心等待…',
            style: GSYConstant.textStyle(color: '#666666'),
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      body:SingleChildScrollView(
        child:IntrinsicHeight(child: Column(
        children: [
          buildBg,
          buttonSection,
          noticeSection,
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
          // Expanded(
          //   child: RefreshIndicator(
          //     onRefresh: _onRefresh,
          //     child: ListView.builder(
          //       itemBuilder: _renderRow,
          //       itemCount: list.length,
          //       controller: _scrollController,
          //     ),
          //   ),
          // )
          // Expanded(
          //   child: inPassSection,
          // ),
          Expanded(child: inOpenSection),
          // Expanded(child: adultSection)
        ],
      ),))
    );
  }
}
