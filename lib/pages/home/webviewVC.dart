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
      // "https://dev-yxqv2.linksign.cn/h5/accreditLogin/accreditLogin.html?transactionId=z01i9e4d6tb64z0g",
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      onProgress: (int progress) {
        print('WebView is loading (progress : $progress%)');
      },
      javascriptChannels: <JavascriptChannel>{
        // _toasterJavascriptChannel(context),
      },
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to $request}');
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

}
