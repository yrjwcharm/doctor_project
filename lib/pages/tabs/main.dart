import 'package:doctor_project/pages/tabs/home.dart';
import 'package:doctor_project/pages/tabs/message.dart';
import 'package:doctor_project/pages/tabs/my.dart';
import 'package:doctor_project/pages/tabs/patient.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:flutter/material.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  // Create a tab controller
  int current = 0; //记录当前选择的是哪一个
  final List<Widget> pages = const <Widget>[
    //装在页面
    Home(),
    Patient(),
    Message(),
    My()
  ];
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
        label: '首页',
        icon: Image.asset('static/images/home.png'),
        activeIcon: Image.asset('static/images/home-active.png')),
    BottomNavigationBarItem(
      label: '我的患者',
      icon: Image.asset('static/images/patient.png'),
      activeIcon: Image.asset('static/images/patient_active.png'),
    ),
    BottomNavigationBarItem(
      label: '消息',
      icon: Image.asset('static/images/news.png'),
      activeIcon: Image.asset('static/images/news-active.png'),
    ),
    BottomNavigationBarItem(
      label: '我的',
      icon: Image.asset('static/images/my.png'),
      activeIcon: Image.asset('static/images/my-active.png'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[current],
        // Set the bottom navigation bar
        bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) {//点击事件
             setState(() {
               current = index;
               print('test,$current');
             });

            },
            currentIndex: current,
            selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.red,
                fontFamily: 'PingFangSC-Regular, PingFang SC'),
            unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                color:  Colors.grey,
                fontFamily: 'PingFangSC-Regular, PingFang SC'),
             selectedFontSize: 11,
            selectedItemColor: ColorsUtil.hexStringColor('#06B48D'),
            unselectedItemColor: ColorsUtil.hexStringColor('#999999'),
            unselectedFontSize: 11,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            items:bottomTabs
        ));
  }
}
