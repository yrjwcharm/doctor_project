import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/service_settings.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpenService extends StatefulWidget {
  const OpenService({Key? key}) : super(key: key);

  @override
  _OpenServiceState createState() => _OpenServiceState();
}

class _OpenServiceState extends State<OpenService> {
  @override
  void initState() {
    super.initState();
  }

  applyOpen() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => const ServiceSettings()
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget buildServiceIntr(String title, String subTitle,
        {double? lineHeight}) {
      return Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 9.0, left: 16.0),
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.5),
                  color: ColorsUtil.hexStringColor('#18BA96'),
                ),
              ),
              Text(
                title,
                style: GSYConstant.textStyle(color: '#333333'),
              )
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 32.0, top: 6.0),
            child: Text(
              subTitle,
              style: GSYConstant.textStyle(
                  color: '#888888', lineHeight: lineHeight, fontSize: 13.0),
            ),
          )
        ],
      );
    }

    return MaterialApp(
      title: '开通服务',
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              CustomAppBar(
                '开通服务',
                isBack: true,
                onBackPressed: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                alignment: Alignment.center,
                child: Text(
                  '服务介绍',
                  style: GSYConstant.textStyle(fontSize: 16, color: '#333333'),
                ),
              ),
              buildServiceIntr(
                  '服务定位', '根据医生的擅长、专业为对症患者提供病情咨询、诊疗建议、用药指导等服务，利用空余时间帮助更多的患者。',
                  lineHeight: 20 / 13),
              const SizedBox(
                height: 11.0,
              ),
              buildServiceIntr('服务定价', '医生自行设置每天接诊的数量及患者问诊价格。',
                  lineHeight: 33 / 13),
              const SizedBox(
                height: 7.0,
              ),
              buildServiceIntr('开通要求', '一级以上公立医院有执业证医师可以申请开通。',
                  lineHeight: 33 / 13),
              const SizedBox(
                height: 9.0,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 9.0, left: 16.0),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.5),
                          color: ColorsUtil.hexStringColor('#18BA96'),
                        ),
                      ),
                      Text(
                        '服务规则',
                        style: GSYConstant.textStyle(color: '#333333'),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 32.0, right: 17.0),
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '(1）问诊审核',
                          style: GSYConstant.textStyle(
                              color: '#888888',
                              fontSize: 13.0,
                              lineHeight: 22 / 13),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            '患者下单后、您可在24小时内决定是否接诊，若患者咨询病情不对症，您可以选择退诊，超过24小时未接诊，将自动退款',
                            style: GSYConstant.textStyle(
                                color: '#888888',
                                fontSize: 13.0,
                                lineHeight: 22 / 13),
                          ),
                        ),
                        Text(
                          '(2）问诊开始',
                          style: GSYConstant.textStyle(
                              color: '#888888', fontSize: 13.0),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                              '接诊后，您可以在24小时内通过图文、视频等沟通方式为患者在线诊疗；超过24小时未回复，将自动退款。',
                              style: GSYConstant.textStyle(
                                  color: '#888888',
                                  fontSize: 13.0,
                                  lineHeight: 22 / 13)),
                        ),
                        Text(
                          '(3）问诊完成',
                          style: GSYConstant.textStyle(
                              color: '#888888',
                              fontSize: 13.0,
                              lineHeight: 22 / 13),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              '如患者已得到满意答复，您与患者均可点击结束问诊主动结束问诊。',
                              style: GSYConstant.textStyle(
                                  color: '#888888',
                                  fontSize: 13.0,
                                  lineHeight: 22 / 13),
                            )),
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                  child: Container(
                      alignment: Alignment.bottomLeft,
                      child: SafeArea(
                          child: TextButton(
                              onPressed: applyOpen,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                alignment: Alignment.center,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: ColorsUtil.hexStringColor('#06B48D'),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  '申请开通',
                                  style: GSYConstant.textStyle(fontSize: 16.0),
                                ),
                              )))))
            ],
          )),
    );
  }
}
