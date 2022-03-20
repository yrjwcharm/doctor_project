import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors_utils.dart';
import '../../utils/svg_utils.dart';

class AddDrugList extends StatefulWidget {
  const AddDrugList({Key? key}) : super(key: key);

  @override
  _AddDrugListState createState() => _AddDrugListState();
}

class _AddDrugListState extends State<AddDrugList> {
  final TextEditingController _editingController = TextEditingController();

  bool tab1Active = false;
  bool tab2Active = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar(
        '添加药品',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 11.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tab1Active = true;
                        tab2Active = false;
                      });
                    },
                    child: Stack(
                      children: [
                        Image.asset(
                          tab1Active
                              ? 'assets/images/self_mention.png'
                              : 'assets/images/self_mention1.png',
                          fit: BoxFit.contain,
                        ),
                        Positioned(
                            width: tab1Active ? 206 : 169,
                            height: 44,
                            child: Center(
                                child: Text(
                              '医保内',
                              style: GSYConstant.textStyle(
                                  fontSize: 17.0,
                                  color: tab1Active ? '#06B48D' : '#333333'),
                            ))),
                      ],
                    ),
                  ),
                  Flexible(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tab2Active = true;
                        tab1Active = false;
                      });
                    },
                    child: Stack(
                      children: [
                        Image.asset(
                          tab2Active
                              ? 'assets/images/express_delivery1.png'
                              : 'assets/images/express_delivery.png',
                          fit: BoxFit.contain,
                        ),
                        Positioned(
                            width: tab2Active ? 206 : 169,
                            height: 44,
                            child: Center(
                              child: Text(
                                '医保外',
                                style: GSYConstant.textStyle(
                                    fontSize: 16.0,
                                    color: tab2Active ? '#06B48D' : '#333333'),
                              ),
                            )),
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              padding:
                  const EdgeInsets.only(top: 11.0,bottom: 15.0, left: 17.0, right: 16.0),
              child: Row(children: <Widget>[
                Expanded(
                  child: Container(
                    height: 32.0,
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          width: 1.0,
                          color: ColorsUtil.hexStringColor(
                            '#999999',
                          )),
                      borderRadius: BorderRadius.circular(19.0),
                    ),
                    child: TextField(
                      controller: _editingController,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(20) //限制长度
                      ],
                      onChanged: (value) =>
                          {print(_editingController.text.isNotEmpty)},
                      style: GSYConstant.textStyle(color: '#666666'),
                      cursorColor: ColorsUtil.hexStringColor('#666666'),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIconConstraints: const BoxConstraints(),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 31.0),
                        // isDense: true,
                        isCollapsed: true,
                        prefixIcon: SvgUtil.svg('search.svg'),

                        suffixIcon: _editingController.text.isNotEmpty
                            ? SvgUtil.svg('delete.svg')
                            : null,
                        hintStyle: GSYConstant.textStyle(color: '#888888'),
                        hintText: '搜索ICD名称、拼音码',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Text(
                  '取消',
                  style: GSYConstant.textStyle(color: '#333333'),
                )
              ]),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('常用药',style: GSYConstant.textStyle(fontSize: 15.0,color: '#333333'),),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
              return Container(
                 height: 68.0,
                 padding: const EdgeInsets.only(left: 16.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                   Text('[阿莫灵]阿莫西林胶囊 0.25*24粒/盒',style: GSYConstant.textStyle(color: '#333333'),),
                     Text('口服：一次3粒，4次/天',style: GSYConstant.textStyle(fontSize: 13.0,color: '#888888'),)
                   ],),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   border: Border(bottom: BorderSide(width: 1.0,color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3)))
                 ),
              );
            })
          ],
        ),
      ),
    );
  }
}
