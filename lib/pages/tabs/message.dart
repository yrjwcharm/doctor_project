import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          '消息',
          isBack: false,
          onBackPressed: () {},
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 13.0, bottom: 14.0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SvgUtil.svg('dot.svg'),
                          Text(
                            '【公告】2022年春节放假通知～',
                            style: GSYConstant.textStyle(
                                color: '#333333',
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                      Text(
                        '2022-03-14 10:23',
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
                    '根据北京市政府办公厅通知精神，现将2022年春节放假安排通知如下：1月31日至2月6日放假调休，共7天，1月29日…',
                    textAlign: TextAlign.justify,
                    style: GSYConstant.textStyle(
                        fontSize: 13.0,
                        color: '#666666',
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
