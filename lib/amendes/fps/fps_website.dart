

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../constants.dart';

class fps_website extends StatefulWidget {

  const fps_website(
      {super.key, this.androidDrawer, this.num});

  final Widget? androidDrawer;
  final String? num;


  @override
  State<fps_website> createState() => _fps_websiteState();
}

class _fps_websiteState extends State<fps_website> {

  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

//  final controller = Get.put(MyStateController());

  late var url;
  double progress = 0;
  var urlController = TextEditingController();


  var _num;
  var _url;

  @override
  Widget build(BuildContext context) {

    _num = widget.num as String;
    _url = "https://teleservices.paris.fr/rapo/jsp/site/Portal.jsp?page=rapo&view=createModifyRapoMultistepForm/$_num";


    /// sur le site  https://teleservices.paris.fr/rapo/jsp/site/Portal.jsp?page=rapo&view=createModifyRapoMultistepForm
    ///
    /// Informations à compléter
    ///
    /// numFps =
    /// dateConstat =
    /// heureConstat =
    /// dateEnvoiFps =
    ///
    ///

    return Scaffold(
        backgroundColor: color_background,
        appBar: AppBar(
          //  leading: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
          title: Text(_url,
              style: TextStyle_veryverysmall),
          //const Text('fps_website'),
          backgroundColor: color_background2,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                webViewController?.reload();
              },
            ),
          ],

        ),


        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(_url)),
                    // onWebViewCreated: ,
                    // onEnterFullscreen: ,

                  )
              ),

            ],
          ),
        )
    );
  }
}


class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const Button({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: smallTextStyle,
        ));
  }



}
