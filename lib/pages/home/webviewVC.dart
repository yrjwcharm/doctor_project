import 'dart:convert';
import 'dart:io';
import 'package:doctor_project/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:doctor_project/utils/colors_utils.dart';
import 'dart:async';

class WebviewVC extends StatefulWidget {
  String url ;
  WebviewVC({Key? key, required this.url}) : super(key: key);

  @override
  _WebviewVCState createState() => _WebviewVCState(url: this.url);
}

class _WebviewVCState extends State<WebviewVC> {

  String url ;
  _WebviewVCState({required this.url});

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

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
        appBar: CustomAppBar(
          '电子签名授权',
          isBack: true,
          onBackPressed: () {
            Navigator.of(context).pop(this);
          },
        ),
        backgroundColor: ColorsUtil.bgColor,
        body: initWebView()
      // floatingActionButton: favoriteButton(),
    );
  }

  /// 初始化webview
  initWebView() {
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      onProgress: (int progress) {
        print('WebView is loading (progress : $progress%)');
      },
      javascriptChannels:  <JavascriptChannel>{
        JavascriptChannel(
            name: 'Print',
            onMessageReceived: (JavascriptMessage message) {
              ///print("FFFFFF");
              // print(message.message);
              Map<String,dynamic> map = json.decode(message.message);
              if(map['success']){
                Navigator.pop(context);
              }
              // FocusScope.of(context).requestFocus(focusNode);
            })
      },
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('MyAPP:')) {
        // if (request.url.startsWith('https://dev-yxqv2.linksign.cn')) {
          Navigator.of(context).pop();
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },
      // onWebResourceError: ,
      gestureNavigationEnabled: true,
      backgroundColor: ColorsUtil.bgColor,
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

}
