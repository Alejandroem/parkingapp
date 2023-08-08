import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ParkingBrowser extends StatefulWidget {
  const ParkingBrowser({super.key});

  @override
  State<ParkingBrowser> createState() => _ParkingBrowserState();
}

class _ParkingBrowserState extends State<ParkingBrowser> {
  String paybyphoneContent = "";

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  InAppWebViewSettings settings = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log("floatingActionButton onPressed");
          webViewController?.evaluateJavascript(source: """                
                var element = document.querySelector('[data-testid="activeParkingSession"]');
                if (element && element.innerHTML.includes("stop-button")) {
                    window.flutter_inappwebview.callHandler('receiveDataFromWeb', element.innerHTML.replace( /(<([^>]+)>)/ig, ''));
                  }    
              """);
        },
        child: const Icon(Icons.refresh),
      ),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(
          url: WebUri("https://m2.paybyphone.fr/"),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
          log("onWebViewCreated");
          controller.addJavaScriptHandler(
              handlerName: 'receiveDataFromWeb',
              callback: (args) {
                log("received data from web: $args");
                //Show snackbar
                setState(() {
                  paybyphoneContent = args[0];
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(args[0]),
                  ),
                );
                return {
                  'message': 'success',
                };
              });
        },
        onLoadStop: (controller, url) {
          log("onLoadStop $url");
          if (url.toString().contains("parking")) {
            log("parking page let's evaluate the js code");
            controller.evaluateJavascript(source: """
                console.log("evaluateJavascript");          
                var observer = new MutationObserver(function(mutationsList, observer) {
                var element = document.querySelector('[data-testid="activeParkingSession"]');
                if (element && element.innerHTML.includes("stop-button")) {
                    window.flutter_inappwebview.callHandler('receiveDataFromWeb', element.innerHTML.replace( /(<([^>]+)>)/ig, ''));
                    observer.disconnect();
                  }
                });
      
                observer.observe(document, { childList: true, subtree: true });
              """);
          }
        },
      ),
    );
  }
}
