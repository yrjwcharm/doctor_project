import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/desensitization_utils.dart';
import 'package:doctor_project/utils/image_network_err.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key, required this.map}) : super(key: key);
  final Map<String, dynamic> map;

  @override
  _OrderDetailState createState() => _OrderDetailState(this.map);
}

class _OrderDetailState extends State<OrderDetail> {
  late Map<String, dynamic> _map;

  _OrderDetailState(map) {
    _map = map;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('$_map');
    // {orderType: 0, sex_dictText: 未知字典, sex: 10, photo: , type_dictText: 图文问诊, type: 0, diseaseTime_dictText: 未知字典, orderType_dictText: 复诊拿药, times: 61966, diseaseTime: , diseaseData: [], name: 病人姓名, id: 432413381564170241, age: 22, diseaseDesc: }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '订单详情',
        isBack: true,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 11),
            height: 73,
            child: ListTile(
              onTap: () {},
              title: Row(
                children: <Widget>[
                  Text(
                    _map['name'],
                    style: GSYConstant.textStyle(
                        fontFamily: 'Medium',
                        fontWeight: FontWeight.w500,
                        color: '#333333'),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    _map['sex_dictText'],
                    style: GSYConstant.textStyle(color: '#333333'),
                  ),
                  Text(
                    '｜',
                    style: GSYConstant.textStyle(color: '#333333'),
                  ),
                  Text(
                    _map['age'].toString() + '岁',
                    style: GSYConstant.textStyle(color: '#333333'),
                  ),
                ],
              ),
              tileColor: Colors.white,
              subtitle: Text(
                  DesensitizationUtil.desensitizationMobile('18311410379')),
              // leading:_map['photo'].isEmpty?Image.network(_map['photo']):Image.asset('assets/images/home/avatar.png'),
              leading: SizedBox(
                  height: 40, width: 40, child:NetWorkImageUtil.buildImg(_map['photo'])),
              trailing: Image.asset(
                'assets/images/my/more.png',
                fit: BoxFit.cover,
                width: 8,
                height: 14,
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text(
              '问诊类型',
              style: GSYConstant.textStyle(color: '#333333'),
            ),
            trailing: Text(
              _map['type_dictText'],
              style: GSYConstant.textStyle(color: '#666666'),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            height: 266,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 17.0, bottom: 20.0),
            margin: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '咨询内容',
                  style: GSYConstant.textStyle(
                      fontWeight: FontWeight.w500,
                      color: '#333333',
                      fontFamily: 'Medium'),
                ),
                const SizedBox(
                  height: 14.0,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 84.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '患者名字',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                    ),
                    Text(
                      _map['name'],
                      style: GSYConstant.textStyle(color: '#666666'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 84.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '患病时间：',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                    ),
                    Text(
                      _map['diseaseTime_dictText'] ?? '',
                      style: GSYConstant.textStyle(color: '#666666'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 84.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '是否就诊过：',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                    ),
                    Text(
                      _map['isRepeat_dictText'],
                      style: GSYConstant.textStyle(color: '#666666'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 84.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '病情描述：',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                    ),
                    Flexible(
                        child: Text(
                      _map['diseaseDesc'],
                      style: GSYConstant.textStyle(color: '#666666'),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Container(
                      width: 84.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '上传资料：',
                        style: GSYConstant.textStyle(color: '#333333'),
                      ),
                    ),
                    Flexible(
                      child: Wrap(
                          spacing: 10.0,
                          children: _map['diseaseData']
                              .map<Widget>((item) => Image.network(
                                    item,
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
                                  ))
                              .toList()),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                alignment: Alignment.bottomLeft,
                child: SafeArea(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  contentPadding: const EdgeInsets.all(0),
                                  titlePadding: const EdgeInsets.only(
                                      top: 14.0,
                                      left: 16.0,
                                      right: 16.0,
                                      bottom: 13.0),
                                  title: Text(
                                    '拒诊原因',
                                    style: GSYConstant.textStyle(
                                        fontSize: 15.0, color: '#333333'),
                                  ),
                                  children: <Widget>[
                                    SimpleDialogOption(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            border: Border.all(
                                                width: 1,
                                                color:
                                                    ColorsUtil.hexStringColor(
                                                        '#cccccc'))),
                                        height: 88,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: '',
                                            border: InputBorder.none,
                                            hintStyle: GSYConstant.textStyle(
                                                color: '#999999'),
                                          ),
                                          style: GSYConstant.textStyle(
                                              color: '#666666'),
                                          cursorColor:
                                              ColorsUtil.hexStringColor(
                                                  '#666666'),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    SimpleDialogOption(
                                      padding: const EdgeInsets.only(
                                          top: 31.0, left: 0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: CustomElevatedButton(
                                            title: '确认',
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            height: 48,
                                            textStyle: GSYConstant.textStyle(
                                              fontSize: 15.0,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(4.0)),
                                          )),
                                          Expanded(
                                              child: CustomOutlineButton(
                                            height: 48.0,
                                            title: '取消',
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            primary: '#ffffff',
                                            textStyle: GSYConstant.textStyle(
                                                fontSize: 15.0,
                                                color: '#666666'),
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    const Radius.circular(4.0)),
                                            borderColor:
                                                ColorsUtil.hexStringColor(
                                                    '#cccccc'),
                                          ))
                                        ],
                                      ),
                                      // onPressed: () {
                                      //   Navigator.of(context).pop();
                                      // },
                                    ),
                                  ],
                                );
                              },
                            ).then((val) {});
                          },
                          child: Text(
                            '拒诊',
                            style: GSYConstant.textStyle(shadows: [
                              const Shadow(
                                  offset: Offset(0, -1.0),
                                  blurRadius: 4.0,
                                  // text-shadow: 0px -1px 4px rgba(225, 225, 225, 0.5);
                                  color: Color.fromRGBO(225, 225, 225, 0.5))
                            ], fontSize: 15.0, color: '#666666'),
                          ),
                        ),
                      )),
                      Expanded(
                          child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ColorsUtil.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage() ));
                          },
                          child: Text(
                            '接诊',
                            style: GSYConstant.textStyle(shadows: [
                              const Shadow(
                                  offset: Offset(0, -1.0),
                                  blurRadius: 4.0,
                                  // text-shadow: 0px -1px 4px rgba(225, 225, 225, 0.5);
                                  color: Color.fromRGBO(225, 225, 225, 0.5))
                            ], fontSize: 15.0, color: '#ffffff'),
                          ),
                        ),
                      ))
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
