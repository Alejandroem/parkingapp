

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../constants.dart';

class antai_website extends StatefulWidget {

  const antai_website(
      {super.key, this.androidDrawer, this.num, this.cle});

  final Widget? androidDrawer;
  final String? num;
  final String? cle;

  @override
  State<antai_website> createState() => _antai_websiteState();
}

class _antai_websiteState extends State<antai_website> {

  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

//  final controller = Get.put(MyStateController());

  late var url;
  double progress = 0;
  var urlController = TextEditingController();


  var _num;
  var _cle;
  var _url;

  @override
  Widget build(BuildContext context) {

    _num = widget.num as String;
    _cle = widget.cle as String;
    _url = "https://www.amendes.gouv.fr/tai/amende/$_num/$_cle";

    return Scaffold(
        backgroundColor: color_background,
        appBar: AppBar(
          //  leading: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
          title: Text(_url,
              style: TextStyle_veryverysmall),
          //const Text('antai_website'),
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
