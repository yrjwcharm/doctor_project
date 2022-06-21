import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/health_consult_service.dart';
import 'package:doctor_project/pages/home/picture_service.dart';
import 'package:doctor_project/pages/home/video_service.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';
import '../../utils/toast_util.dart';

import '../../model/ServiceSettingsBean.dart';

class ServiceSettings extends StatefulWidget {
  const ServiceSettings({Key? key}) : super(key: key);
  @override
  _ServiceSettingsState createState() => _ServiceSettingsState();
}


class _ServiceSettingsState extends State<ServiceSettings> {
  final List<ServiceSettingsBean> list=[];
  List dataList = [];
  List settinglist = [];
  // int treatType;
  // int state;
  // String  stateStr = '';

  @override
  void initState() {
    super.initState();

    settinglist = [
      {
        'treatId' : '',
        'icon': 'assets/images/home/picture.png',
        'title': '图文问诊-复诊开药',
        'subtitle': '图文方式的问诊服务',
        'state': 0,
        'fee':'0',
        'patientCount':'0',
        'treatType':0
      },
      {
        'treatId' : '',
        'icon': 'assets/images/home/consult.png',
        'title': '健康咨询',
        'subtitle': '开通图文方式的咨询服务，无需处方',
        'state': 0,
        'fee':'0',
        'patientCount':'0',
        'treatType':1
      },
      {
        'treatId' : '',
        'icon': 'assets/images/home/video.png',
        'title': '视频问诊',
        'subtitle': '患者预约后进行视频问诊服务',
        'state': 0,
        'fee':'0',
        'patientCount':'0',
        'treatType':2
      }
    ];
    getData();

  }

  Future getData() async {
    var request = HttpRequest.getInstance();
    var res = await request.get(
        Api.serviceByDocIdAndState, {});
    if (res['code'] == 200) {
        setState(() {
        dataList = res['data'];
        print('dataList22222 ===='+dataList.toString());
//        if(dataList.length == 0){

//        }else {
          for (int i = 0;i<dataList.length;i++){
            if (dataList[i]['treatType']== 0){
              settinglist[0]['state'] = dataList[i]['state']??'';
              print('settinglist State ===='+settinglist[i]['state'].toString());

              settinglist[0]['fee'] = dataList[i]['fee']??'';
              settinglist[0]['patientCount'] = dataList[i]['patientCount']??'';
              settinglist[0]['treatId'] = dataList[i]['treatId']??'';

            }else if (dataList[i]['treatType']== 1) {
              settinglist[1]['state'] = dataList[i]['state']??'';
              settinglist[1]['fee'] = dataList[i]['fee']??'';
              settinglist[1]['patientCount'] = dataList[i]['patientCount']??'';
              settinglist[1]['treatId'] = dataList[i]['treatId']??'';

            }else if(dataList[i]['treatType']== 2) {
              settinglist[2]['state'] = dataList[i]['state']??'';
              settinglist[2]['fee'] = dataList[i]['fee']??'';
              settinglist[2]['patientCount'] = dataList[i]['patientCount']??'';
              settinglist[2]['treatId'] = dataList[i]['treatId']??'';

            }
          }
          if(list.isEmpty){
            for(int i = 0;i<3;i++){
              list.add(ServiceSettingsBean(settinglist[i]['icon'],settinglist[i]['title'],settinglist[i]['subtitle'],settinglist[i]['state']==1 ?'已开通':'未开通',settinglist[i]['state'],settinglist[i]['treatType'],''));
            }
          }else {
            list.clear();
            for(int i = 0;i<3;i++){
              list.add(ServiceSettingsBean(settinglist[i]['icon'],settinglist[i]['title'],settinglist[i]['subtitle'],settinglist[i]['state']==1 ?'已开通':'未开通',settinglist[i]['state'],settinglist[i]['treatType'],''));
            }
          }

//        print('settinglist ===='+settinglist.toString());
      });
    } else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  Widget buildListTile(String icon,String title,String subTitle,String detailTitle,int status,{ required VoidCallback callback}){
    return ListTile(
      leading:   CircleAvatar(
        backgroundImage:AssetImage(icon),
        backgroundColor: Colors.transparent,
      ),
      onTap: callback,
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
          const Image(image: AssetImage('assets/images/my/more.png'),width: 8.0,height: 14.0,)
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
                tiles:list.asMap().keys.map((index) =>buildListTile(list[index].icon, list[index].title, list[index].subTitle, list[index].detailTitle, list[index].status,callback: () {
                  if (settinglist[index]['treatType']== 0){
                    Navigator.push(context,MaterialPageRoute(settings: RouteSettings(name:"ServiceSettings"),builder: (context)=>PictureService(treatId:settinglist[index]['treatId'].toString(),fee:settinglist[index]['fee'].toString(),patientCount:settinglist[index]['patientCount'].toString(),state:settinglist[index]['state']))).then((value) {

                        setState(() {
                          getData();


                        });
                    });
                  }else if (settinglist[index]['treatType']== 1) {
                    Navigator.push(context,MaterialPageRoute(settings: RouteSettings(name:"ServiceSettings"),builder: (context)=>HealthConsultService(treatId:settinglist[index]['treatId'].toString(),fee:settinglist[index]['fee'].toString(),patientCount:settinglist[index]['patientCount'].toString(),state:settinglist[index]['state']))).then((value) {

                        setState(() {
                          getData();

                        });
                    });
                  }else if (settinglist[index]['treatType']== 2) {
                    Navigator.push(context,MaterialPageRoute(settings: RouteSettings(name:"ServiceSettings"),builder: (context)=>VideoService(treatId:settinglist[index]['treatId'].toString(),fee:settinglist[index]['fee'].toString(),patientCount:settinglist[index]['patientCount'].toString(),state:settinglist[index]['state']))).then((value) {
                        setState(() {
                          getData();

                        });

                    });
                  }
                },
                )),color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)
            ).toList(),
          )
        ],
      ),
    );
  }
}
