import 'package:doctor_project/utils/ColorsUtil.dart';
import 'package:doctor_project/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Widget buildColumn(String title, String subTitle) {
      return Expanded(
        child: Column(children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'PingFangSC-Medium, PingFang SC',
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

    Widget buildButtonColumn(String assetName, String label) {
      Color color = ColorsUtil.hexStringColor('#333333');

      return Expanded(
        child: Column(
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
        ),
      );
    }

    Widget buildBg = Container(
      height: 183.0,
      decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('static/images/home/background.png')),
      ),
      child: Container(
        height: 126.0,
        padding: const EdgeInsets.all(16.0),
        margin: EdgeInsets.only(
            top: CommonUtils.isIPhoneX(context) ? 66 : 42,
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
                    image: AssetImage('static/images/home/avatar.png'),
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
                                    fontFamily:
                                        'PingFangSC-Medium, PingFang SC',
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
    Widget buttonSection = Container(
      margin: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 8.0, top: 17.0),
      height: 96,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        children: [
          buildButtonColumn('static/images/home/consult.png', '患者咨询'),
          buildButtonColumn('static/images/home/pictures.png', '图文问诊'),
          buildButtonColumn('static/images/home/video.png', '视频问诊'),
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
              child:Row(
              children: [
              Image.asset('static/home/images/notice.png', fit: BoxFit.cover),
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
            ],
          )
          ),
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
    return Scaffold(
      backgroundColor: ColorsUtil.hexStringColor('#f9f9f9'),
      body: Column(
        children: [
          buildBg,
          buttonSection,
          noticeSection,
        ],
      ),
    );
  }
}
