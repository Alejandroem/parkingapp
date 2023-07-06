import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


//var PermisNb1 = "800978200032";
//var PermisNb2 = "";
//var PermisNb3 = "";
//var CodeConsultation = "PZ5XQZC7"; //"1234"; // ;


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      kDebugMode &&
      defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
  runApp(const MaterialApp());
}




class mespoints_webview extends StatefulWidget {
  const mespoints_webview(
  {super.key, this.androidDrawer, this.code1, this.code2, this.code3, this.code_consultation });

  final Widget? androidDrawer;
  final String? code1;
  final String? code2;
  final String? code3;
  final String? code_consultation;

  @override
  _mespoints_webviewState createState() => _mespoints_webviewState();

}

class _mespoints_webviewState extends State<mespoints_webview> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  String? _code1;
  String? _code2;
  String? _code3;
  String? _code_consultation;
  String? _url;

  @override
  void initState() {
    super.initState();
    _code1 = widget.code1;
    _code2 = widget.code2;
    _code3 = widget.code3;
    _code_consultation = widget.code_consultation;
   }

  @override
  Widget build(BuildContext context) {
    var MyUrl = 'https://tele7.interieur.gouv.fr/tlp/';

    final userScript0 = UserScript(
        groupName: "myUserScripts",
        source:
        "document.getElementById('btn-connect-code').click();",
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);

    final userScript1 = UserScript(
        groupName: "myUserScripts",
        source: """
    window.addEventListener('load', function(event) {
    document.body.style.backgroundColor = 'purple';
    document.body.style.padding = '20px';});""",
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START);

    final userScript2 = UserScript(
        groupName: "myUserScripts",
        source: "document.getElementById('input_numero_permis_1').value = '$_code1';",
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);

    final userScript3 = UserScript(
        groupName: "myUserScripts",
        source: "document.getElementById('input_numero_permis_2').value = '$_code2';",
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);

    final userScript4 = UserScript(
        groupName: "myUserScripts",
        source: "document.getElementById('input_numero_permis_3').value = '$_code3';",
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);

    final userScript5 = UserScript(
        groupName: "myUserScripts",
        source:    "document.getElementById('input_numero_confidentiel').value = '$_code_consultation';",
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Télépoints"),
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
                  initialUrlRequest: URLRequest(url: WebUri(MyUrl)),
                  initialUserScripts: UnmodifiableListView<UserScript>([
                   // userScript0,
                   // userScript1,
                    userScript2,
                    userScript3,
                    userScript4,
                    userScript5
                  ]),
                //  onLoadStop: (controller, url) async {
                //  var result = await controller.evaluateJavascript(source: "foo + bar");
                //  print(result);
                //  },
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
