import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoctorQualification extends StatefulWidget {
  const DoctorQualification({Key? key}) : super(key: key);

  @override
  _DoctorQualificationState createState() => _DoctorQualificationState();
}

class _DoctorQualificationState extends State<DoctorQualification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('医师资质认证'),
      backgroundColor: ColorsUtil.bgColor,
      body:(Column(
          children: <Widget>[
            Expanded(child:SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 32.0,
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        color: ColorsUtil.hexStringColor('#CE8E55', alpha: 0.12)),
                    child: Row(
                      children: <Widget>[
                        SvgUtil.svg('qualification.svg'),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          '为了您顺利通过认证，请务必填写真实信息',
                          style:
                          GSYConstant.textStyle(fontSize: 13.0, color: '#C78C4C'),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    height: 44.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                color: ColorsUtil.hexStringColor('#cccccc',
                                    alpha: 0.3)))),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '执业证书编号',
                          style:
                          GSYConstant.textStyle(fontSize: 14.0, color: '#333333'),
                        ),
                        Expanded(
                            child: TextField(
                              inputFormatters: [],
                              textAlign: TextAlign.end,
                              style:
                              GSYConstant.textStyle(fontSize: 14.0, color: '#666666'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  hintStyle: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#999999'),
                                  hintText: '请输入执业证书编号'),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 44.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                color: ColorsUtil.hexStringColor('#cccccc',
                                    alpha: 0.3)))),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '职称资格证编号',
                          style:
                          GSYConstant.textStyle(fontSize: 14.0, color: '#333333'),
                        ),
                        Expanded(
                            child: TextField(
                              inputFormatters: [],
                              textAlign: TextAlign.end,
                              style:
                              GSYConstant.textStyle(fontSize: 14.0, color: '#666666'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  hintStyle: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#999999'),
                                  hintText: '请输入职称资格证编号'),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 44.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                color: ColorsUtil.hexStringColor('#cccccc',
                                    alpha: 0.3)))),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '执业类别',
                          style:
                          GSYConstant.textStyle(fontSize: 14.0, color: '#333333'),
                        ),
                        Expanded(
                            child: TextField(
                              inputFormatters: [],
                              enabled: false,
                              textAlign: TextAlign.end,
                              style:
                              GSYConstant.textStyle(fontSize: 14.0, color: '#666666'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  hintStyle: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#999999'),
                                  hintText: '请选择'),
                            )),
                        const SizedBox(
                          width: 10.0,
                        ),
                        SvgUtil.svg('arrow__.svg')
                      ],
                    ),
                  ),
                  Container(
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '执业范围',
                          style:
                          GSYConstant.textStyle(fontSize: 14.0, color: '#333333'),
                        ),
                        Expanded(
                            child: TextField(
                              inputFormatters: [],
                              enabled: false,
                              textAlign: TextAlign.end,
                              style:
                              GSYConstant.textStyle(fontSize: 14.0, color: '#666666'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  hintStyle: GSYConstant.textStyle(
                                      fontSize: 14.0, color: '#999999'),
                                  hintText: '请选择'),
                            )),
                        const SizedBox(
                          width: 10.0,
                        ),
                        SvgUtil.svg('arrow__.svg')
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.only(top: 16.0),
                      decoration: BoxDecoration(color: Colors.white),
                      child: GridView(
                          shrinkWrap: true,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 18, //横轴三个子widget
                              childAspectRatio: 1.5 //宽高比为1时，子widget
                          ),
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SvgUtil.svg('behind.svg'),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  '点击上传身份证人像面',
                                  style: GSYConstant.textStyle(
                                      fontSize: 12.0, color: '#666666'),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                SvgUtil.svg('front.svg'),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  '点击上传身份证国徽面',
                                  style: GSYConstant.textStyle(
                                      fontSize: 12.0, color: '#666666'),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                SvgUtil.svg('behind.svg'),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  '点击上传身份证人像面',
                                  style: GSYConstant.textStyle(
                                      fontSize: 12.0, color: '#666666'),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                SvgUtil.svg('front.svg'),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  '点击上传身份证国徽面',
                                  style: GSYConstant.textStyle(
                                      fontSize: 12.0, color: '#666666'),
                                )
                              ],
                            ),
                          ])),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 21.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 4.0,),
                        Row(
                          children: <Widget>[
                            SvgUtil.svg('tip.svg'),
                            const SizedBox(
                              width: 3.0,
                            ),
                            Text(
                              '温馨提示',
                              style: GSYConstant.textStyle(
                                  fontSize: 12.0, color: '#06B48D'),
                            )
                          ],
                        ),
                        Text('1. 您可以根据驳回原因描述问题重新修改后提交；',style: GSYConstant.textStyle(fontSize:12.0 ,color: '#999999'),),
                        Text('2. 提交资料必须真实，如果连续3次驳回后，系统将会自动加入黑名单，请您谨慎提交；',style: GSYConstant.textStyle(fontSize:12.0 ,color: '#999999')),
                        Text('3.请确保上传证件清晰可识别，否则会影响认证结果，每张图片大小不超过1M。',style: GSYConstant.textStyle(fontSize:12.0 ,color: '#999999')),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child:SafeArea(
                child: CustomElevatedButton(
                  primary: '#999999',
                  borderRadius: BorderRadius.circular(0.0),
                  onPressed: () { 
                  
                }, title: '提交审核',

                ),
              ),
            )
          ],)
      ),
    );
  }
}
