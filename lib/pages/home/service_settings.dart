import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/modal/ServiceSettingsBean.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceSettings extends StatefulWidget {
  const ServiceSettings({Key? key}) : super(key: key);
  @override
  _ServiceSettingsState createState() => _ServiceSettingsState();
}


class _ServiceSettingsState extends State<ServiceSettings> {
  final List<ServiceSettingsBean> list=[];
  @override
  void initState() {
    super.initState();
    list.add(ServiceSettingsBean('static/images/home/avatar.png','健康咨询','开通图文方式的咨询服务，无需处方','已开通',1));
    list.add(ServiceSettingsBean('static/images/home/avatar.png','图文问诊-复诊开药','图文方式的问诊服务','审核中',0));
    list.add(ServiceSettingsBean('static/images/home/avatar.png','视频问诊-复诊开药','患者预约后进行视频问诊服务','未开通',0));

  }
  Widget buildListTile(String icon,String title,String subTitle,String detailTitle,int status){
    return ListTile(
      leading:   CircleAvatar(
        backgroundImage:AssetImage(icon),
        backgroundColor: Colors.transparent,
      ),
      title:  Text(title,style: GSYConstant.textStyle(fontSize: 15.0,color:'#333333'),),
      subtitle: Text(subTitle,style: GSYConstant.textStyle(fontSize: 13.0,color:'#999999'),),
      tileColor: Colors.white,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin:const EdgeInsets.only(right:8.0),
            child: Text(detailTitle,style: GSYConstant.textStyle(color:status==1?'#06B48D':'FF3131'),),
          ),
          const Image(image: AssetImage('static/images/my/more.png'),width: 8.0,height: 14.0,)
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.hexStringColor('#f9f9f9'),
      body: Column(
        children: [
           CustomAppBar('服务设置',isBack: true,onBackPressed: (){
             Navigator.pop(context);
           },),
          Column(
            children:ListTile.divideTiles(
                tiles:list.map((item) =>buildListTile(item.icon, item.title, item.subTitle, item.detailTitle, item.status)),color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)
            ).toList(),
          )
        ],
      ),
    );
  }
}
