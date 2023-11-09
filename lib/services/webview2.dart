// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs


import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';



void main() => runApp(const MaterialApp(home: webview2()));


class webview2 extends StatefulWidget {
  const webview2(
      {super.key, this.androidDrawer, this.url, this.title});

  final Widget? androidDrawer;
  final String? url;
  final String? title;


  @override
  State<webview2> createState() => _webviewState2();
}

class _webviewState2 extends State<webview2> {
 // late final WebViewController _controller;

  String? _url;
  String? _title;

  Future<void> _launchUniversalLinkIos(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  InAppWebViewController? webViewController;

  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
   // mediaPlaybackRequiresUserGesture: false,
   // allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true,
      javaScriptCanOpenWindowsAutomatically: true,

  );

  PullToRefreshController? pullToRefreshController;

  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _url = widget.url ?? "";
    _title = widget.title ?? "";
   }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green,


      appBar: AppBar(
        title: Text(_title.toString()),
      ),

      body: InAppWebView(

            initialUrlRequest: URLRequest(url: WebUri(_url!)),
            initialSettings: settings,

            pullToRefreshController: pullToRefreshController,

        onWebViewCreated: (controller) async {
            webViewController = controller;
        },

        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT);
        },


        shouldOverrideUrlLoading:
            (controller, navigationAction) async {
          var uri = navigationAction.request.url!;

          if (![
            "http",
            "https",
            "file",
            "chrome",
            "data",
            "javascript",
            "about"
          ].contains(uri.scheme)) {
            if (await canLaunchUrl(uri)) {
              // Launch the App
              await launchUrl(
                uri,
              );
              // and cancel the request
              return NavigationActionPolicy.CANCEL;
            }
          }
          return NavigationActionPolicy.ALLOW;
        },

        onLoadStart: (controller, url) async {
          setState(() {
            this.url = url.toString();
            urlController.text = this.url;
          });
        },

        // onEnterFullscreen:
        // onFindResultReceived
        // onWebContentProcessDidTerminate
        // onLoadResourceWithCustomScheme



        onLoadStop: (controller, url) async {
          webViewController = controller;
          pullToRefreshController?.endRefreshing();
          setState(() {
            this.url = url.toString();
            urlController.text = this.url;
          });
          var html = await controller.evaluateJavascript(source: "window.document.body.innerText");
          print('---------------------1----------------------');
          print(html);
          },

        onRenderProcessGone: (controller, url) async {
          webViewController = controller;
          pullToRefreshController?.endRefreshing();
          setState(() {
            this.url = url.toString();
            urlController.text = this.url;
          });
          var html = await controller.evaluateJavascript(source: "window.document.body.innerText");
          print('---------------------00----------------------');
          print(html);
          },

        onLoadResourceWithCustomScheme: (controller, url) async {
          webViewController = controller;
          pullToRefreshController?.endRefreshing();
          setState(() {
            this.url = url.toString();
            urlController.text = this.url;
          });
          var html = await controller.evaluateJavascript(source: "window.document.body.innerText");
          print('---------------------01----------------------');
          print(html);
        },

        onPageCommitVisible: (controller, url) async {
            webViewController = controller;
            pullToRefreshController?.endRefreshing();
            setState(() {
            this.url = url.toString();
            urlController.text = this.url;
            });
            var html = await controller.evaluateJavascript(source: "window.document.body.innerText");
            print('---------------------2----------------------');
            print(html);
            },


         onTitleChanged:(controller, url) async {
              pullToRefreshController?.endRefreshing();
              controller.evaluateJavascript(source: "window.document.body.innerText").then((html) {

              ( html.contains("Stationnement") )
                ? {

              print('---------------------3----------------------'),
              print(html)
                 }
                :
                print("-----------------------/ onTitleChanged /-----------------");
               // var source = "window.top.document.body.innerHTML" ;
                //print(source);
              });
           },


        onProgressChanged: (controller, url) {
          if (progress == 100) {
            pullToRefreshController?.endRefreshing();
            controller.evaluateJavascript(source: "window.document.body.innerText").then((html) {
              print("-----------------------onProgressChanged-------------------");
              print(html);
            });
          }
          setState(() {
            this.progress = progress / 100;
            urlController.text = this.url;
          });

        },

      onReceivedError: (controller, request, error) {
          pullToRefreshController?.endRefreshing();
          print('------------error------------------');
          print(error);
        },

      ),

      floatingActionButton: favoriteButton(),
    );
  }


  Widget favoriteButton() {
    return FloatingActionButton(
      onPressed: ()  { webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(_url!)));},
      child: const Icon(Icons.check)
    );
  }

}



