import 'dart:io';

import 'package:doctor_project/common/style/gsy_style.dart';
import 'package:flutter/material.dart';
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
  final FocusNode focusNode = new FocusNode();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: new AppBar(
      //   title: _renderTitle(),
      // ),
      body:SafeArea(child: new Stack(
        children: <Widget>[
          TextField(
            focusNode: focusNode,
          ),
          WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (_) {
                setState(() {
                  isLoading = false;
                });
              },
              javascriptChannels: Set.from([
                JavascriptChannel(
                    name: 'Print',
                    onMessageReceived: (JavascriptMessage message) {
                      ///print("FFFFFF");
                      print(message.message);
                      FocusScope.of(context).requestFocus(focusNode);
                    })
              ])),
          if (isLoading)
            new Center(
              child: new Container(
                width: 200.0,
                height: 200.0,
                padding: new EdgeInsets.all(4.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new SpinKitDoubleBounce(
                        color: Theme.of(context).primaryColor),
                    new Container(width: 10.0),
                    new Container(
                        child: new Text('loading...',style: TextStyle(
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
