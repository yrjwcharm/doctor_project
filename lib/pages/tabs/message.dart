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
class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<Message> {
  final ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数
  bool isMore = true; //是否正在加载数据
  List<dynamic> list = [];
  @override
  void initState() {
    // TODO: implement initState
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
        Api.getMessageListApi + '?page=$_page&size=10', {});
    if (res['code'] == 200) {
      setState(() {
        list = res['data']['records'];
        isMore = true;
        print('messageList ===='+list.toString());
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
          Api.getMessageListApi + '?&page=$_page&size=10',
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
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
  Widget _renderRow(BuildContext context, int index) {
    var item = list[index];
    return  Container(
      margin:const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 13.0, bottom: 14.0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SvgUtil.svg('dot.svg'),
                  const SizedBox(width: 4.0,),
                  Text(
                    item['title']??'',
                    style: GSYConstant.textStyle(
                        color: '#333333',
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
              Text(
                item['createTime']??'',
                style: GSYConstant.textStyle(
                    color: '#999999',
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
          const SizedBox(
            height: 9.0,
          ),
          Text(
            item['content']??'',
            textAlign: TextAlign.justify,
            style: GSYConstant.textStyle(
                fontSize: 13.0,
                color: '#666666',
                fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          '消息',
          isBack: false,
          onBackPressed: () {},
        ),
        backgroundColor: ColorsUtil.bgColor,
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemBuilder: _renderRow,
                  itemCount: list.length,
                  controller: _scrollController,
                ),
              ),
            ),
          ],
        ));
  }
}
