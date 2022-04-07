import 'dart:io';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/prescription_detail.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/svg_utils.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddDrug extends StatefulWidget {
  const AddDrug({Key? key}) : super(key: key);

  @override
  _AddDrugState createState() => _AddDrugState();
}

class _AddDrugState extends State<AddDrug> {
  final _controller = TextEditingController();
  bool tab1Active = false;
  bool tab2Active = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar:  CustomAppBar(
        '添加药品',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10.0),
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
                          width: tab1Active?206:169,
                          height: 44,
                          child: Center(
                              child: Text(
                            '医保内',
                            style: GSYConstant.textStyle(
                                fontSize: 16.0, color: '#555555'),
                          ))),
                    ],
                  ),
                ),
                Flexible(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tab2Active =true;
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
                          width:tab2Active?206:169,
                          height: 44,
                          child: Center(
                            child: Text(
                              '医保外',
                              style: GSYConstant.textStyle(
                                  fontSize: 16.0, color: '#06B48D'),
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child:Row(
              children: <Widget>[
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
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
                ),
                Text('取消',style: GSYConstant.textStyle(fontSize: 14.0,color: '#333333'),)
              ],
            ) ,
          ),
          Slidable(
            // key: Key(index.toString()),
            endActionPane:  ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  // flex: 2,
                  onPressed: _deleteRow,
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: '删除',
                ),
                // SlidableAction(
                //   onPressed: doNothing,
                //   backgroundColor: Color(0xFF0392CF),
                //   foregroundColor: Colors.white,
                //   icon: Icons.save,
                //   label: 'Save',
                // ),
              ],
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const PrescriptDetail()));
                  },
                  contentPadding: const EdgeInsets.only(top:10.0,left: 16.0,right: 16.0,bottom: 14.0),
                  tileColor: Colors.white,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      Text('红蚂蚁',style: GSYConstant.textStyle(fontSize: 15.0,color: '#333333'),),
                      Text('(g)',style: GSYConstant.textStyle(fontSize: 15.0,color: '#888888'),),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('规格：1000g',style: GSYConstant.textStyle(fontSize: 13.0,color: '#888888'),),
                      const SizedBox(height: 4.0,),
                      Text('北京市生物制药有限公司',style: GSYConstant.textStyle(fontSize: 13.0,color: '#888888'),)
                    ],
                  ),
                  trailing: Column(
                    children: <Widget>[
                      Container(
                        width:80,
                        height: 20,
                        margin: const EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            border: Border.all(width:1.0,color: ColorsUtil.hexStringColor('#cccccc'))
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width:26,
                              decoration: BoxDecoration(
                                  border: Border(right: BorderSide(width:1.0,color: ColorsUtil.hexStringColor('#cccccc')))
                              ),
                              child: SvgUtil.svg('minus.svg'),
                            ),
                            Container(
                              width: 26.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                  border: Border(right: BorderSide(width:1.0,color: ColorsUtil.hexStringColor('#cccccc')))
                              ),
                              child: TextField(
                                style:GSYConstant.textStyle(fontSize: 12.0,color: '#333333'),
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),//数字包括小数
                                ],
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    hintText:'2',
                                    hintStyle: TextStyle(fontFamily: 'Medium', fontSize:12.0,fontWeight:FontWeight.w500,color: ColorsUtil.hexStringColor('#333333')),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width:26,
                              child: SvgUtil.svg('increment_add.svg'),
                            ),
                          ],
                        ),
                      ),
                      Text('库存: 5000',style: GSYConstant.textStyle(color: '#888888',fontSize: 13.0),)
                    ],
                  ),
                ),
                Divider(height: 0,  color: ColorsUtil.hexStringColor('#cccccc',alpha: 0.3,),),
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: const BoxDecoration(
                      color: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('共6件',style: GSYConstant.textStyle(fontSize: 13.0,color: '#999999'),),
                      Row(
                        children: <Widget>[
                          Text('合计:',style: GSYConstant.textStyle(fontSize: 13.0,color: '#333333'),),
                          Text('190.30',style: GSYConstant.textStyle(fontFamily:'Medium',color: '#06B48D',fontSize: 16.0),)
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            
          ),
        ],
      ),
    );
  }

  void _deleteRow(BuildContext context) {


  }
}
class SlideAction extends StatelessWidget {
  const SlideAction({
    Key? key,
    required this.color,
    required this.icon,
    this.flex = 1,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      flex: flex,
      backgroundColor: color,
      foregroundColor: Colors.white,
      onPressed: (_) {
        print(icon);
      },
      icon: icon,
      label: 'hello',
    );
  }
}