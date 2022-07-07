import 'dart:io';

import 'package:doctor_project/http/http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/style/gsy_style.dart';
import '../../http/api.dart';
import '../../model/department_modal.dart';
import '../../utils/colors_utils.dart';
import '../../widget/custom_app_bar.dart';

class ChoiceDepartment extends StatefulWidget {
  const ChoiceDepartment({Key? key}) : super(key: key);

  @override
  _ChoiceDepartmentState createState() => _ChoiceDepartmentState();
}

class _ChoiceDepartmentState extends State<ChoiceDepartment> {
  List<Data> list = [];
  List<Data> subList = [];

  @override
  void initState() {
    super.initState();
    getDepartmentList();
  }

  getDepartmentList() async {
    var response =
        await HttpRequest.getInstance().get(Api.getAllDepartment, {});
    var res = DepartmentModal.fromJson(response);
    if (res.code == 200) {
      list = res.data!;
      if (list.isNotEmpty) {
        list[0].checked = true;
        setState(() {
          list = list;
        });
        getSecondDepartmentList(list[0].deptId!);
      }
    }
  }

  getSecondDepartmentList(String deptId) async {
    var response = await HttpRequest.getInstance()
        .get(Api.getAllDepartment + '&deptId=$deptId', {});
    var res = DepartmentModal.fromJson(response);
    if (res.code == 200) {
      setState(() {
        subList = res.data!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: CustomAppBar('科室选择'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  child: SizedBox(
                    width: ScreenUtil().setWidth(100.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: list
                            .map<Widget>((item) => Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          list.forEach((_item) {
                                            _item.checked = false;
                                            if (item.deptId == _item.deptId) {
                                              _item.checked = true;
                                            }
                                          });
                                          getSecondDepartmentList(item.deptId!);
                                        });
                                      },
                                      child: Container(
                                        height: 44.0,
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(20.0)),
                                        color: item.checked!
                                            ? Colors.white
                                            : ColorsUtil.bgColor,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          item.deptName!,
                                          style: GSYConstant.textStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(14.0),
                                              color: item.checked!
                                                  ? '#06B48D'
                                                  : '#333333',
                                              fontFamily: item.checked!
                                                  ? 'Medium'
                                                  : 'Regular',
                                              fontWeight: item.checked!
                                                  ? FontWeight.w500
                                                  : FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        child: Container(
                                      width: item.checked! ? 3.0 : 0.0,
                                      height: 38.0,
                                      color:
                                          ColorsUtil.hexStringColor('#08B78C'),
                                    ))
                                  ],
                                ))
                            .toList()),
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 17.0, right: 9.0),
                        color: Colors.white,
                        child: Column(
                            children: subList
                                .map<Widget>((item) => GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context,item);
                                    },
                                    child: Container(
                                      height: 43.0,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      ColorsUtil.hexStringColor(
                                                          '#cccccc',
                                                          alpha: 0.3)))),
                                      child: Text(
                                        item.deptName!,
                                        style: GSYConstant.textStyle(
                                            color: '#333333'),
                                      ),
                                    )))
                                .toList()),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
