import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoticeDetail extends StatefulWidget {
  const NoticeDetail({Key? key}) : super(key: key);

  @override
  _NoticeDetailState createState() => _NoticeDetailState();
}

class _NoticeDetailState extends State<NoticeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CustomAppBar('详情',onBackPressed: (){
         Navigator.pop(context);
       },),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 19.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text('北京市区领导来我区考察、交流思想',style: GSYConstant.textStyle(fontSize: 18.0,color: '#333333'),),
                SizedBox(height: 6.0,),
                Text('2022年2月10日',style: GSYConstant.textStyle(color: '#888888'),)
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
            child: Text('北京市委教育工委委员、市教委副主任丁大伟，北京市教委扶贫支援处处长王力志，北京市教委职成处处长王东江等一行5人到我市医院就职业教育发展和东西部协作帮扶情况进行考察调研。省委教育工委副书记、'
                '省教育厅党组副书记、副厅长韩俊兰和发展规划处处长韩军，张家口市委常委、市政府副市长李春滨，市政府副秘书长宋建军、刘兵，市教育局党组副书记、副局长杜平，市教育局副局长贺志英等领导陪同调研。',textAlign:TextAlign.justify,style: GSYConstant.textStyle(lineHeight:24/14,color: '#333333'),),
          ),
          Container(
            padding: const EdgeInsets.only(right: 13.0),
            margin: const EdgeInsets.only(top: 104.0),
            alignment: Alignment.centerRight,
            child: Column(
              children: <Widget>[
                Text('2022年2月10日',style: GSYConstant.textStyle(color: '#333333'),),
                SizedBox(height: 5.0,),
                Text('通海县人民医院',style: GSYConstant.textStyle(color: '#333333'),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
