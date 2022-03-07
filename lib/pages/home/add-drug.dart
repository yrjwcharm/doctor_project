import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddDrug extends StatefulWidget {
  const AddDrug({Key? key}) : super(key: key);

  @override
  _AddDrugState createState() => _AddDrugState();
}

class _AddDrugState extends State<AddDrug> {
  var _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      body: Column(
        children: <Widget>[
          CustomAppBar(
            '添加药品',
            onBackPressed: () {
              Navigator.pop(context);
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[

              ],
            ),
          ),

          Container(
            width: 299,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (text) {},
              controller: _controller,
              decoration: InputDecoration(
                  hintText: '搜索药品名称、拼音码',
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 15.0,
                  ),
                  contentPadding:const EdgeInsets.symmetric(vertical: 6.0),
                  fillColor: Colors.white,
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                    //如果文本长度不为空则显示清除按钮
                      onPressed: () {
                        _controller.clear();
                      },
                      icon: const Icon(Icons.cancel, color: Colors.grey))
                      : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19.0),
                      borderSide: BorderSide(
                          color: ColorsUtil.hexStringColor('#999999'),
                          width: 1.0)),
                  hintStyle: GSYConstant.textStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: '#999999')),
            ),
          )
        ],
      ),
    );
  }
}
