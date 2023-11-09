import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      kDebugMode &&
      defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
  runApp(const MaterialApp());
}



class fourriere_nice extends StatefulWidget {
  const fourriere_nice(
      {super.key, this.androidDrawer, this.url, this.immatriculation });

  final Widget? androidDrawer;
  final String? immatriculation;
  final String? url;

  @override
  _fourriere_niceState createState() => _fourriere_niceState();

}

class _fourriere_niceState extends State<fourriere_nice> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  String? _immatriculation;
  String? _url;

  @override
  void initState() {
    super.initState();
    _immatriculation = widget.immatriculation;
    _url = widget.url;

  }

  @override
  Widget build(BuildContext context) {


    final userScript1 = UserScript(
        groupName: "myUserScripts",
        source: "document.getElementById('search_immat').value = '$_immatriculation';",
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);

    final userScript2 = UserScript(
        groupName: "myUserScripts",
        source: "document.getElementsByClassName('button_immat')[0].click();",
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);



    return Scaffold(
      appBar: AppBar(
        title: const Text("Fourrière de Nice"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                webViewController?.reload();
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(url: WebUri(_url!)),
                  initialUserScripts: UnmodifiableListView<UserScript>([
                    userScript1,
                    userScript2,
                  ]),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
