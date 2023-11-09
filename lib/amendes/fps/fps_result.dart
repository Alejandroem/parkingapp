import 'package:flutter/material.dart';

import '../../constants.dart';

class fps_Result extends StatelessWidget {
  fps_Result({Key? key, required this.text}) : super(key: key);

  final String text;
  final _formKey = GlobalKey<FormState>();
  final Avis_de_paiement_no = TextEditingController();
  final Stationnement_date = TextEditingController();
  final Stationnement_heure = TextEditingController();
  final Date_envoi =  TextEditingController();
  final Date_minore = TextEditingController();
  final Date_limite = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    print(
        '========================     SCAN FPS PAGE RESULT====================');
    print(text);
    print(
        '=============================FIN SCAN FPS TEXT============================');

    var _avis_de_paiement_no = text.indexOf("21750001600019", 0) + 0;

    var _stationnement_date = text.indexOf("a stationne le", 0)+15;
  //var _stationnement_heure = text.indexOf("a stationne le", 0)+15;

    var _date_envoi = text.indexOf("Date d'envoi de", 0) + 35;

    print ("----------------------_avis_de_paiement_no------------------------------");
    print(_avis_de_paiement_no);

    print ("-----------------------_stationnement_date-----------------------------");
    print(_stationnement_date);

    print ("-----------------------date d'envoi------------------------------");
    print(_date_envoi);
    print ("------------------------4-----------------------------");


    Avis_de_paiement_no.text = (_avis_de_paiement_no > 0)
        ? text.substring(_avis_de_paiement_no, _avis_de_paiement_no + 31)
        : ".";

    Stationnement_date.text = (_stationnement_date > 0)
        ? text.substring(_stationnement_date, _stationnement_date + 10)
        : ".";

    Date_envoi.text = (_date_envoi > 0)
        ? text.substring(_date_envoi, _date_envoi + 10)
        : ".";

    Date_minore.text = (_date_envoi > 0)
        ? text.substring(_date_envoi, _date_envoi + 10)
        : ".";

    Date_limite.text = (_date_envoi > 0)
        ? text.substring(_date_envoi, _date_envoi + 10)
        : ".";

    print ("----------------------_avis_de_paiement_no------------------------------");
    print(Avis_de_paiement_no.text);

    print ("-----------------------_stationnement_date-----------------------------");
    print(Stationnement_date.text);

    print ("-----------------------dates------------------------------");
    print(Date_envoi.text);
    print(_date_envoi);
    print ("------------------------4-----------------------------");


    TextFormField inputcontravention_date = TextFormField(
      controller: Stationnement_date,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Date de la constatation :',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputcontravention_heure = TextFormField(
      controller: Stationnement_heure,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Heure de la constatation :',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField input_date_envoi = TextFormField(
      controller: Date_envoi,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Date de départ',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField input_date_minore = TextFormField(
      controller: Date_minore,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Date limite paiement minorée',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField input_date_limite = TextFormField(
      controller: Date_limite,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Date limite de paiement',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputTelepaiment_no = TextFormField(
      controller: Avis_de_paiement_no,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Telepaiment_no',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );


    ListView amende_infos = ListView(
      padding: EdgeInsets.all(20),
      shrinkWrap: true,
      children: <Widget>[
        // SizedBox(height: 20),
        // picture,
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              inputTelepaiment_no,
              inputcontravention_date,
              inputcontravention_heure,
              input_date_envoi,
              input_date_minore,
              input_date_limite,
            ],
          ),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color_background,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child:  Text('Forfait de Poststationnement',
            style: TextStyle_regular)
          ),
        Container(
        height: 500,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color_background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),

        child:    amende_infos,
    ),

          Container(
            height: 60,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color_background,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                        Text("Merci de vérifier",
                  style: TextStyle_regular,),
                Text("les informations ci-dessus : ",
                    style: TextStyle_regular),
              ],
            ),
          ),
          /*
          Container(
            height: MediaQuery.of(context).size.height - 231,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color_background,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child:  Container(
            height: 50,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color_background,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 38,
                  width: 120,
                  decoration: BoxDecoration(
                      color: color_background,
                      border: Border.all(
                        color: color_background,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextButton(
                    child: Text("Confimation",
                        style: TextStyle_verysmall),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => fps_website(
                                  num: Avis_de_paiement_no.text),
                          ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 38,
                  width: 120,
                  decoration: BoxDecoration(
                      color: color_background,
                      border: Border.all(
                        color: color_background,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextButton(
                    child: Text("Annulation",
                        style: TextStyle_verysmall),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => amendes()));
                    },
                  ),
                ),
              ],
            ),
            ),
          ),
          */
      ],
      ),
    );
  }
}
