import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:doctor_project/pages/home/video_topic.dart';
import 'package:doctor_project/pages/home/webviewVC.dart';
import 'package:doctor_project/pages/photoview_page.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'package:doctor_project/utils/desensitization_utils.dart';
import 'package:doctor_project/utils/event_bus_util.dart';
import 'package:doctor_project/utils/image_network_catch.dart';
import 'package:doctor_project/utils/svg_util.dart';
import 'package:doctor_project/utils/toast_util.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:doctor_project/widget/custom_elevated_button.dart';
import 'package:doctor_project/widget/custom_input_widget.dart';
import 'package:doctor_project/widget/custom_outline_button.dart';
import 'package:doctor_project/widget/custom_webview.dart';
import '../../utils/desensitization_utils.dart';
import 'package:doctor_project/pages/my/write_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:doctor_project/pages/my/rp_detail.dart';
import 'package:flutter/material.dart';
import '../../http/http_request.dart';
import '../../http/api.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class RecipesTemplate extends StatefulWidget {
  RecipesTemplate({Key? key, required this.isRadio}) : super(key: key);
  bool isRadio;

  @override
  _RecipesTemplateState createState() => _RecipesTemplateState(this.isRadio);
}

class _RecipesTemplateState extends State<RecipesTemplate> {
  bool _isRadio;
  bool tab1Active = true;
  bool tab2Active = false;
  int _page = 1; //加载的页数
  bool isMore = true; //是否正在加载数
  List list = [];
  int _radioGroup = 0;
  final ScrollController _scrollController = ScrollController(); //listview的控制器

  _RecipesTemplateState(this._isRadio);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
      }
    });
  }

  Future deleData(String id) async{
    var request = HttpRequest.getInstance();
    var res = await request.get(Api.deleteTemplate, {
      "id":id,
    });
    if(res['code']==200){

    }else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }

  /**
   * 初始化list数据 加延时模仿网络请求
   */
  Future getData() async {
    var request = HttpRequest.getInstance();
    String url = tab1Active
        ? Api.getRecipes + '?type=1'
        : Api.getRecipes + '?type=2';
    var res = await request.get(url, {});
    print("------res"+res.toString());
    if (res['code'] == 200) {
      list = res['data'];
      setState(() {

      });
    } else {
      ToastUtil.showToast(msg: res['msg']);
    }
  }
  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<void> _onRefresh() async {
    getData();
  }


  Widget _renderRow(BuildContext context, int index) {
    var item = list[index];
    return Slidable(
        endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) async {
              setState(() {
                deleData(item['id']);
                list.remove(item);
              });
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
          ),
        ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Column(children: [
          ListTile(
            onTap:(){
            },

            contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
            trailing: SvgUtil.svg('keyboard_arrow_right.svg'),
            tileColor: Colors.white,
            subtitle:ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: list[index]['medicines'].length,
                itemBuilder: (BuildContext context, int i) {
                  var item = list[index]['medicines'][i];
                  return Column(
                    children: [
                      Container(
                          height:50.0,
                          child:ListTile(
                            title: Text(item['medicineName']+item['specification']+"/"+item['packageUnit'],style: GSYConstant.textStyle(color: '#333333'),),
                            subtitle: Text(item['useType']+":"+item['freq'],style: GSYConstant.textStyle(color: '#888888',fontSize: 13.0)),
                      )),
                    ],
                  );
                }),
            title: Row(
              children: [
                Text(list[index]['name'],style: GSYConstant.textStyle(color: '#333333'),),
                const SizedBox(
                  width: 6.0,
                ),
                Visibility(
                    visible: list[index]['deptName'].isNotEmpty,
                    child: CustomOutlineButton(
                        height: 18.0,
                        padding:const EdgeInsets.only(left: 7.0,right:8.0),
                        // width: 66.0,
                        textStyle: GSYConstant.textStyle(
                            fontSize: 13.0, color: '#06B48D'),
                        title: list[index]['deptName'],
                        onPressed: () {},
                        borderRadius:
                        BorderRadius.circular(9.0),
                        borderColor:
                        ColorsUtil.hexStringColor(
                            '#06B48D')))
              ],
            ),
          ),
        ])));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: CustomAppBar(
        '常用处方',
        isBack: true,
      ),
    body: Column(
      children: [
        Container(
          height: 44.0,
          margin:const EdgeInsets.only(bottom: 8.0),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tab1Active = true;
                        tab2Active = false;
                        list = [];
                      });
                      getData();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '西药/中成药',
                          style: GSYConstant.textStyle(
                              color: tab1Active ? '#06B48D' : '#666666'),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tab1Active = false;
                        tab2Active = true;
                        list = [];
                      });
                      getData();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '中药',
                          style: GSYConstant.textStyle(
                              color: tab2Active ? '#06B48D' : '#666666'),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemBuilder: _renderRow,
              itemCount: list.length,
              controller: _scrollController,
            ),
          ),
        ),
        Container(
            height: 44.0,
            margin:const EdgeInsets.only(top: 8.0),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: <Widget>[
                Text("*",style:GSYConstant.textStyle(
                  color:'#FE5A6B' ,)),
                Text("*操作提示：左滑删除常用处方",style:GSYConstant.textStyle(color:'#666666')),
              ],
        ))
      ],
    )
    );
  }


}