import 'package:doctor_project/pages/login/login.dart';
import 'package:doctor_project/pages/tabs/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/local/local_storage.dart';

class SplashScreen extends StatefulWidget {
   SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginState();
  }

  getLoginState() async {
    String? token = await LocalStorage.get('tokenValue');
    WidgetsBinding.instance?.addPostFrameCallback((_){
      // Your Code Here
      if (token != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Main()));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
