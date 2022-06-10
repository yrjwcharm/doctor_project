import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitSuccess extends StatelessWidget {
  const SubmitSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        CustomAppBar(
          '提交结果',
          isBack: true,
          
        ),
        Container(
          margin: const EdgeInsets.only(top:74.0),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/home/failure.png',
                width: 54,
                height: 54,
              ),
              const SizedBox(
                height: 17,
              ),
              Text(
                '提交成功',
                style: GSYConstant.textStyle(color: '#333333', fontSize: 16.0),
              ),
              const SizedBox(height: 6),
              Text('请耐心等待审核', style: GSYConstant.textStyle(color: '#888888')),
            ],
          ),
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SafeArea(
                child: Row(
              children: [
                TextButton(
                    style: ButtonStyle(
                        padding:
                            ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(
                                const EdgeInsets.all(0.0))),
                    onPressed: backHome,
                    child: Container(
                      width: 125,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: ColorsUtil.hexStringColor('#06B48D'))),
                      child: Text(
                        '返回首页',
                        style: GSYConstant.textStyle(
                            fontSize: 15.0, color: '#666666'),
                      ),
                    )),
                Expanded(
                    child: TextButton(
                        style: ButtonStyle(
                            padding:
                                ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(
                                    const EdgeInsets.all(0.0),
                                )),

                        onPressed: keepOpen,
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorsUtil.hexStringColor('#06B48D')),
                          child: Text(
                            '继续开通',
                            style: GSYConstant.textStyle(
                                fontSize: 15.0, color: '#ffffff'),
                          ),
                        )))
              ],
            ))
          ],
        ))
      ]),
    );
  }

  void backHome() {}

  void keepOpen() {

  }
}
