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



class fourriere_paris extends StatefulWidget {
  const fourriere_paris(
      {super.key, this.androidDrawer, this.url, this.immatriculation });

  final Widget? androidDrawer;
  final String? immatriculation;
  final String? url;

  @override
  _fourriere_parisState createState() => _fourriere_parisState();

}

class _fourriere_parisState extends State<fourriere_paris> {
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

    final userScript0 = UserScript(
        groupName: "myUserScripts",
        source: "document.getElementById('etape_title_2').scrollIntoView();",
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);

    final userScript1 = UserScript(
        groupName: "myUserScripts",
        source: "document.getElementById('immatriculation').value = '$_immatriculation';",
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);

    final userScript2 = UserScript(
        groupName: "myUserScripts",
        source: "document.getElementsByClassName('button')[0].click();",
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);

    final userScript3 = UserScript(
        groupName: "myUserScripts",
        source: """
        var el1 = document.getElementsByTagName('button-text');
        var el2 = document.getElementsByClassName('button-text');
        el1[1].innerHTML = 'Recommencer';
        """,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);

    final userScript4 = UserScript(
        groupName: "myUserScripts",
     // source: "document.getElementById('etape_title_2').title = 'Recherche terminée';",
        source: """
        var el3 = document.getElementsByTagName('etape_title_2');
        var el4 = document.getElementsByClassName('etape_title_2');
        el3[0].title.innerHTML = 'Recherche terminée';
        """,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END);


    return Scaffold(
      appBar: AppBar(
        title: const Text("Fourrières de Paris"),
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
                    userScript0,
                    userScript1,
                    userScript2,
                    userScript3,
                    userScript4,
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
