// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs


import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports


void main() => runApp(const MaterialApp(home: webview()));


class webview extends StatefulWidget {
  const webview(
      {super.key, this.androidDrawer, this.url, this.title});

  final Widget? androidDrawer;
  final String? url;
  final String? title;


  @override
  State<webview> createState() => _webviewState();
}

class _webviewState extends State<webview> {
  late final WebViewController _controller;


  String? _url;
  String? _title;

  @override
  void initState() {
    super.initState();

    _url = widget.url ?? "";
    _title = widget.title ?? "";


    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url)  async {
            debugPrint('Page finished loading: $url');
            var result = await _controller.runJavaScriptReturningResult('document.documentElement.innerHTML');
            print("++++++++++++++++++!!!!!!!!!!!result!!!!!!!!!!!!!!!!!+++++++++++++++");
            print (result);
            print("++++++++++++++++++!!!!!!!!!!!!!result!!!!!!!!!!!!!!!+++++++++++++++");


           },

          onWebResourceError: (WebResourceError error) {
            debugPrint('''
          Page resource error:
            code: ${error.errorCode}
            description: ${error.description}
            errorType: ${error.errorType}
            isForMainFrame: ${error.isForMainFrame}
                    ''');
                    },

          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(_url!));


    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  void readJS() async{
   // var html = await controller.evaluateJavascript(source: "window.document.getElementsByTagName('html')[0].outerHTML;");
    print("++++++++++++++++++!!!!!!!!!!!HTML!!!!!!!!!!!!!!!!!+++++++++++++++");
   // print();
    // print('Page finished loading: $url');
    // if (url.contains(url) {

    var result = await _controller.runJavaScriptReturningResult('document.documentElement.outerHTML');
    print("++++++++++++++++++!!!!!!!!!!!result!!!!!!!!!!!!!!!!!+++++++++++++++");
    print (result);
    print("++++++++++++++++++!!!!!!!!!!!!!result!!!!!!!!!!!!!!!+++++++++++++++");
    // String html = await controller.evaluateJavascript("window.document.getElementsByTagName('html')[0].outerHTML;");
    // print(html);
    // }
  }



  @override
  Widget build(BuildContext context) {
    var page_toShow = WebViewWidget(controller: _controller);
    print ('***********************');

      return Scaffold(
      backgroundColor: Colors.green,

      appBar: AppBar(
        title: Text(_title.toString()),
      ),
      body: page_toShow, // WebViewWidget(controller: _controller),
      floatingActionButton: favoriteButton(),
    );
  }

  Widget favoriteButton() {
    return FloatingActionButton(
      onPressed: ()  => _controller.loadRequest(Uri.parse(_url!)),
      child: const Icon(Icons.check),
    );
  }

}



