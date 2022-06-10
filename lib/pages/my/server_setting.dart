import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';


class MyServeSetting extends StatefulWidget {
  const MyServeSetting({Key? key}) : super(key: key);

  @override
  _MyServeSettingState createState() => _MyServeSettingState();
}

class _MyServeSettingState extends State<MyServeSetting> {

    @override
    initState() {
     super.initState();
    }
    @override
    Widget build(BuildContext context) {
        return ListView(
            children: <Widget>[
                ListTile(
                title: Text("健康咨询"),
                subtitle: Text("开通图文方式的咨询服务，无需处方"),
                ),
                ListTile(
                title: Text("图文问诊-复诊开药"),
                subtitle: Text("图文方式的问诊服务"),
                ),
                ListTile(
                title: Text("视频问诊-复诊开药"),
                subtitle: Text("患者预约后进行视频问诊服务"),
                )
            ],
        );
    }
}   
