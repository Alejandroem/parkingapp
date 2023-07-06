import 'package:flutter/material.dart';
import 'package:mycar/antai/antai_website.dart';

import '../constants.dart';
import 'antai.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    print('========================     SCAN TEXT PAGE RESULT====================');
    print(text);
    print('=============================FIN SCAN TEXT============================');

    var _telepaiment_no = text.indexOf("3336", 0);
    var _telepaiment_cle = text.indexOf("3336", 0)+15;
    var _contravention_ref = text.indexOf("de contravention", 0)+18;
   // var _date_infraction = text.indexOf("ommise le", 0)+10;
    var _date_debut = text.indexOf("ommence ", 0)+12;
   // var _date_minore = text.indexOf("Date limite de paiement minoré", 0)+32;
    var _infraction_debut = text.indexOf("«", 0)+2;
    var _infraction_fin = text.indexOf("»", 0)+2;
    var _date_fin = text.indexOf("forfaitaire", 0)+25;


    var contravention_ref = (_contravention_ref > 0) ? text.substring(_contravention_ref,_contravention_ref+9) : "";
    var date_infraction = (_infraction_fin > 0) ? text.substring(_infraction_fin+11,_infraction_fin+29).trim() : "";
    var date_commence = (_date_debut > 0) ? text.substring(_date_debut,_date_debut+10) : "";
    var date_limite = (_date_fin > 0) ? text.substring(_date_fin,_date_fin+11).trim() : "";
  //  var date_minore = (_date_minore > 0) ? text.substring(_date_minore,_date_minore+11).trim() : "";

    var telepaiment_no = (_telepaiment_no > 0) ? text.substring(_telepaiment_no,_telepaiment_no+15).trim() : "";
    var telepaiment_cle = (_telepaiment_cle > 0) ? text.substring(_telepaiment_cle,_telepaiment_cle+2) : "";

    var contravention_type = (_infraction_debut > 0) ? text.substring(_infraction_debut,_infraction_fin-2) : "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(30.0,30.0,5.0,5.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Text(text),
                  Text("Merci de vérifier les informations"),
                  Text("ci-dessous : "),
                  Text(" "),
                  Text("N° Contravention: "),
                  Text('"'+contravention_ref+'"',
                      style: TextStyle_regular),
                  Text(" "),
                  Text("Date de l'infraction: "),
                  Text('"'+date_infraction+'"',
                      style: TextStyle_regular),
                  Text(" "),
                  Text("Type d'infraction: "),
                  Text('"'+contravention_type+'"',
                      style: TextStyle_regular),
                  Text(" "),
                  Text("Date debut du délai: "),
                  Text('"'+date_commence+'"',
                      style: TextStyle_regular),
                  Text(" "),
                  Text("Date limite paiement minorée: "),
                 // Text(date_minore.toString(),
                 //     style: TextStyle_regular),
                  Text(" "),
                  Text("Date limite de paiement : "),
                  Text('"'+date_limite+'"',
                      style: TextStyle_regular),
                  Text(" "),
                  Text("N° telepaiement: "),
                  Text('"'+telepaiment_no+'"',
                      style: TextStyle_regular),
                  Text(" "),
                  Text("Clé telepaiement:"),
                  Text('"'+telepaiment_cle+'"',
                      style: TextStyle_regular),
                  Text(" "),
                  Text(" "),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => antai_website(num:  telepaiment_no, cle:  telepaiment_cle)));
              },
              child: const Text('Enregistrer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => antai()));
              },
              child: const Text('Recommencer'),
            ),
          ],
        ),
      ),
    );
  }


}
