import 'dart:convert';
import 'dart:io';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';
/**
 * webview版本
 * Created by guoshuyu
 * on 2018/7/27.
 */

class GSYWebView extends StatefulWidget {
  final String url;
  final String? title;

  GSYWebView(this.url, {this.title});

  @override
  _GSYWebViewState createState() => _GSYWebViewState();
}

class _GSYWebViewState extends State<GSYWebView> {
  final FocusNode focusNode =  FocusNode();

  bool isLoading = true;
  late WebViewController _webViewController;
  String filePath ='assets/resource/index.html';
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }
  _loadHtmlFromAssets() async{
    String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,mimeType: 'text/html',encoding: Encoding.getByName('utf-8')).toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:  AppBar(
      //   title: _renderTitle(),
      // ),
      body:SafeArea(child:  Stack(
        children: <Widget>[
          TextField(
            focusNode: focusNode,
          ),
          WebView(
              initialUrl: widget.url,
              // onWebViewCreated: (WebViewController webViewController){
              //   _webViewController = webViewController;
              //   _loadHtmlFromAssets();
              // },
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (_) {
                setState(() {
                  isLoading = false;
                });
              },
              javascriptChannels: {
                JavascriptChannel(
                    name: 'Print',
                    onMessageReceived: (JavascriptMessage message) {
                      ///print("FFFFFF");
                      print('2222,${message.message}');
                      Map<String,dynamic> map = json.decode(message.message);
                      if(map['success']){
                        Navigator.pop(context);
                      }
                      // FocusScope.of(context).requestFocus(focusNode);
                    })
              }),
          if (isLoading)
             Center(
              child:  Container(
                width: 200.0,
                height: 200.0,
                padding:  const EdgeInsets.all(4.0),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                     SpinKitDoubleBounce(
                        color: Theme.of(context).primaryColor),
                     Container(width: 10.0),
                     const SizedBox(
                        child:  Text('加载中...',style: TextStyle(
                          color:  Color(0xFF121917),
                          fontSize: 16.0
                        ),
                            // style: GSYConstant.middleText
                        )),
                  ],
                ),
              ),
            )
        ],
      ),),
    );
  }
}

///测试 html 代码，不管
final testhtml = "<!DOCTYPE html>"
    "<html>"
    "<head>"
    "<meta charset=\"utf-8\">"
    "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no\" />"
    "<title>Local Title</title>"
    "<script>"
    "function callJS(){"
    "alert(\"Android调用了web js\");"
    "}"
    "function callInterface(){"
    "JSCallBackInterface.callback(\"我是web的js哟\");"
    "}"
    "function callInterface2(){"
    "document.location = \"js://Authority?pra1=111&pra2=222\";"
    "}"
    "function clickPrompt(){"
    "Print.postMessage('Hello');"
    "}"
    "</script>"
    "</head>"
    "<body>"
    "<button type=\"button\" id=\"buttonxx\" onclick=\"callInterface()\">点我调用原生android方法</button>"
    "<button type=\"button\" id=\"buttonxx2\" onclick=\"callInterface2()\">点我调用原生android方法2</button>"
    "<button type=\"button\" id=\"buttonxx3\" onclick=\"clickPrompt()\">点我调用原生android方法3</button>"
    "<input></input>"
    "</body>"
    "</html>";
