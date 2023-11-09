import 'dart:developer';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../constants.dart';
import '../databases/databases.dart';

class PayByPhoneBrowser extends StatefulWidget {
  const PayByPhoneBrowser({super.key, this.immatriculation, this.categoriepayment});

  final String? immatriculation;
  final String? categoriepayment;

  @override
  State<PayByPhoneBrowser> createState() => _PayByPhoneBrowserState();
}

class _PayByPhoneBrowserState extends State<PayByPhoneBrowser> {

  late DateFormat dateFormat;
  late DateFormat timeFormat;

  String paybyphoneContent = "";

  var _immatriculation;
  var _categoriepayment;

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
  void initState() {
    super.initState();
    initializeDateFormatting();
    dateFormat = new DateFormat.yMMMMd('fr');
    timeFormat = new DateFormat.Hms('fr');
    _immatriculation = widget.immatriculation;
    _categoriepayment = widget.categoriepayment;
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayByPhone'),
        backgroundColor: color_background2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log("floatingActionButton onPressed");
          webViewController?.evaluateJavascript(source: """                
                var elements = document.querySelectorAll('[data-testid="activeParkingSession"]');
                if (elements && elements.length > 0) {
                  var texts = [];
                  for (var i = 0; i < elements.length; i++) {
                      texts.push(elements[i].innerHTML.replace( /(<([^>]+)>)/ig, ''));
                  }
                  window.flutter_inappwebview.callHandler('receiveDataFromWeb', texts);
                }    
              """);
          paybyphoneContentAnalyse();
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
                  paybyphoneContent = args[0].toString();
                });
                paybyphoneContentAnalyse();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(args[0].toString()),
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
                function getData(){
                  var elements = document.querySelectorAll('[data-testid="activeParkingSession"]');
                  if (elements && elements.length > 0) {
                    var texts = [];
                    for (var i = 0; i < elements.length; i++) {
                        texts.push(elements[i].innerHTML.replace( /(<([^>]+)>)/ig, ''));
                    }
                    window.flutter_inappwebview.callHandler('receiveDataFromWeb', texts);
                  }
                  setTimeout(getData, 1000);
                }
                setTimeout(getData, 1000);
              """);
          }
        },
      ),
    );
  }

  void paybyphoneContentAnalyse () async {
    String PayByphone_ExpirationTime = "";
    String PayByphone_ExpirationDate = "";
    String PayByphone_ExpirationDay = "";
    String PayByphone_ExpirationHour = "";
    String PayByphone_Immatriculation = "";
    String PayByphone_CategoriePayment = "";
    String PayByphone_CategorieVehicule = "";
    String PayByphone_CodePostal = "";
    String PayByphone_ResidentialArray = "";

    print(
        "---------------------paybyphoneContent paybyphoneContentpaybyphoneContentpaybyphoneContent---------------------");
    print(paybyphoneContent);
    print(paybyphoneContent.length);
    print("_immatriculation : $_immatriculation");
    print("_categoriepayment: $_categoriepayment");
    print(
        "---------------------paybyphoneContent paybyphoneContentpaybyphoneContentpaybyphoneContent---------------------");


    String _DateTime_payment_resident = "";
    String _DateTime_payment_visiteur = "";
    String _DateTime_payment_handi = "";
    String _DateTime_payment_other = "";

    int _lengthglobal = paybyphoneContent.length;
    int _lengthbloc = paybyphoneContent.length;
    ;

    if (paybyphoneContent.length == 0) {

      print ("Vous n'avez aucun paiement en cours !");

      /// to do  create alert to user for payement
      ///
      ///
      ElegantNotification.info(
          title:  Text("ATTENTION"),
          description:  Text("Vous n'avez aucun stationnement en cours")
      ).show(context);

    } else {

    while (paybyphoneContent.length > 0) {
      print(paybyphoneContent);
      print(paybyphoneContent.length);

      int _plate = 0;

      int Delimit_1 = paybyphoneContent.indexOf("Restant", 0) + 7;
      int Delimit_2 = paybyphoneContent.indexOf("Expirera", 0) + 8;
      int Delimit_3 = paybyphoneContent.indexOf(",", 0) + 1;
      int Delimit_4 = paybyphoneContent.indexOf(";", 0) + 1;
      int Delimit_5 = paybyphoneContent.indexOf("-", 0) + 1;
      int Delimit_6 = paybyphoneContent.indexOf("Résident", 0) + 8;
      int Delimit_7 = paybyphoneContent.indexOf("Interrompre", 0);

      print("Delimit_1: $Delimit_1");
      print("Delimit_2: $Delimit_2");
      print("Delimit_3: $Delimit_3");
      print("Delimit_4: $Delimit_4");
      print("Delimit_5: $Delimit_5");
      print("Delimit_6: $Delimit_6");
      print("Delimit_7: $Delimit_7");


      PayByphone_ExpirationTime    = paybyphoneContent.substring(Delimit_1, Delimit_2 - 8);
      PayByphone_ExpirationDate    = paybyphoneContent.substring(Delimit_2, Delimit_3 + 6);
      PayByphone_ExpirationDay     = paybyphoneContent.substring(Delimit_2, Delimit_3 -1);
      PayByphone_ExpirationHour    = paybyphoneContent.substring(Delimit_3 + 1, Delimit_3 + 6);
      PayByphone_CodePostal        = paybyphoneContent.substring(Delimit_3 + 7, Delimit_3 + 12);
      PayByphone_Immatriculation   = paybyphoneContent.substring(Delimit_4, Delimit_4 + 7);
      PayByphone_CategorieVehicule = paybyphoneContent.substring(Delimit_4 + 7, Delimit_5 - 1);
      PayByphone_CategoriePayment  = paybyphoneContent.substring(Delimit_5 + 1, Delimit_5 + 9);
      PayByphone_ResidentialArray  = paybyphoneContent.substring(Delimit_5 + 9, Delimit_6);

      print( PayByphone_ExpirationTime );
      print(PayByphone_ExpirationDate);
      print( PayByphone_ExpirationDay );
      print( PayByphone_ExpirationHour );
      print(PayByphone_CodePostal);
      print(PayByphone_Immatriculation);
      print(PayByphone_CategorieVehicule);
      print(PayByphone_CategoriePayment);
      print(PayByphone_ResidentialArray);


      int _length = PayByphone_ExpirationDate.length;
      print ("PayByphone_ExpirationDate.length : $_length");

      String PayByphone_ExpDay = PayByphone_ExpirationDate.substring(0 , 2).trim();

      (PayByphone_ExpDay.length == 1)
        ? PayByphone_ExpDay = "0"+ PayByphone_ExpDay
        : PayByphone_ExpDay = PayByphone_ExpDay;

      String PayByphone_ExpMonth = PayByphone_ExpirationDate.substring(2, _length - 12).trim();




      var PayByphone_ExpMonthBegin = PayByphone_ExpMonth.substring(0,4);

      var PayByphone_ExpMonthNb = "";

      switch (PayByphone_ExpMonthBegin) {
        case 'janv' :
          PayByphone_ExpMonthNb = "01";
          break;
        case 'fevr' :
          PayByphone_ExpMonthNb = "02";
          break;
        case 'mars' :
          PayByphone_ExpMonthNb = "03";
          break;
        case 'avri' :
          PayByphone_ExpMonthNb = "04";
          break;
        case 'mai' :
          PayByphone_ExpMonthNb = "05";
          break;
        case 'juin' :
          PayByphone_ExpMonthNb = "06";
          break;
        case 'juil' :
          PayByphone_ExpMonthNb = "07";
          break;
        case 'aout' :
          PayByphone_ExpMonthNb = "08";
          break;
        case 'sept' :
          PayByphone_ExpMonthNb = "09";
          break;
        case 'oct' :
          PayByphone_ExpMonthNb = "10";
          break;
        case 'nov' :
          PayByphone_ExpMonthNb = "11";
          break;
        case 'dec.' :
          PayByphone_ExpMonthNb = "12";
          break;

      }

      String PayByphone_ExpYear = PayByphone_ExpirationDate.substring( _length - 12 , _length - 7).trim();

      String PayByPhone_DateTime = PayByphone_ExpDay.trim() + "/" + PayByphone_ExpMonthNb + "/" + PayByphone_ExpYear + ", " + PayByphone_ExpirationHour;

      print ("PayByphone_ExpDay : $PayByphone_ExpDay");
      print ("PayByphone_ExpMonth : $PayByphone_ExpMonth");
      print ("PayByphone_ExpMonthNb : $PayByphone_ExpMonthNb");
      print ("PayByphone_ExpYear : $PayByphone_ExpYear");
      print ("PayByPhone_DateTime = $PayByPhone_DateTime");

      String Date_Expiration = DateFormat('dd/MM/yyyy, HH:mm', 'fr-FR').parse(   PayByPhone_DateTime).toString();

      print('PayByphone_Plate : $PayByphone_Immatriculation');
      print('_immatriculation : $_immatriculation');
      print('Date_Expiration : $Date_Expiration');

      (PayByphone_Immatriculation == _immatriculation)

          ? {
            _plate = 1,
            print("_plate : $_plate"),
            print("PayByphone_CategoriePayment : $PayByphone_CategoriePayment"),
            (PayByphone_CategoriePayment == "Résident")
                ? _DateTime_payment_resident = Date_Expiration
                : (PayByphone_CategoriePayment == "Visiteur")
                ? _DateTime_payment_visiteur = Date_Expiration
                : (PayByphone_CategoriePayment == "Handi")
                ? _DateTime_payment_handi = Date_Expiration
                : _DateTime_payment_other = Date_Expiration
             }

          : {
             print("mauvaise plaque d'immatriculation : $PayByphone_Immatriculation / $_immatriculation"),
            };


      print("_lengthglobal : $_lengthglobal");
      print("Delimit_7 : $Delimit_7");
      paybyphoneContent = paybyphoneContent.substring(Delimit_7 + 12, _lengthglobal);
      _lengthglobal = paybyphoneContent.length;
      print("_New lengthglobal2 : $_lengthglobal");


    };

  }

    print( "_DateTime_payment_resident : $_DateTime_payment_resident");
    print( "_DateTime_payment_visitor : $_DateTime_payment_visiteur");
    print( "_DateTime_payment_handicap : $_DateTime_payment_handi");
    print( "_DateTime_payment_other : $_DateTime_payment_other");


    /// save the info of payment in the database
    ///
    ///

    await DatabaseClient().VehiculeUpdatePayments(
        idKey: 2, payment_resident: _DateTime_payment_resident , payment_visiteur: _DateTime_payment_visiteur, payment_handi: _DateTime_payment_handi);


  }

}
