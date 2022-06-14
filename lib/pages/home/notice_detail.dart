import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoticeDetail extends StatefulWidget {
  final String titleStr;
  final String contentStr;
  final String utstampStr;
  const NoticeDetail({Key? key, required this.titleStr,required this.contentStr,required this.utstampStr}) : super(key: key);

  @override
  _NoticeDetailState createState() => _NoticeDetailState(titleStr,contentStr,utstampStr);
}

class _NoticeDetailState extends State<NoticeDetail> {
  String titleStr;
  String contentStr;
  String utstampStr;
  _NoticeDetailState(this.titleStr,this.contentStr,this.utstampStr);

  @override
  void initState() {
    super.initState();
    print('titleStr-------'+titleStr);
    print('contentStr-------'+contentStr);
    print('utstampStr-------'+utstampStr);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CustomAppBar('详情'),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 19.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(titleStr,style: GSYConstant.textStyle(fontSize: 18.0,color: '#333333'),),
                SizedBox(height: 6.0,),
                Text(utstampStr,style: GSYConstant.textStyle(color: '#888888'),)
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top:13.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height:0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3),),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(contentStr,textAlign:TextAlign.justify,style: GSYConstant.textStyle(lineHeight:24/14,color: '#333333'),),
          ),
          Container(
            padding: const EdgeInsets.only(right: 13.0),
            margin: const EdgeInsets.only(top: 104.0),
            alignment: Alignment.centerRight,
            child: Column(
              children: <Widget>[
                Text(utstampStr,style: GSYConstant.textStyle(color: '#333333'),),
                SizedBox(height: 5.0,),
                Text('',style: GSYConstant.textStyle(color: '#333333'),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
