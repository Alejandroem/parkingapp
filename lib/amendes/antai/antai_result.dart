import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../amendes/antai/antai_website.dart';
import '../amendes.dart';



class antai_Result extends StatefulWidget {
  const antai_Result({super.key, this.androidDrawer, required this.recognizedtext});

  final Widget? androidDrawer;
  final String recognizedtext;

  @override
  State<antai_Result> createState() => antai_ResultState();
}

class antai_ResultState extends State<antai_Result> {

  late String TextRecognized;

  @override
  void initState() {
    TextRecognized = widget.recognizedtext;
    super.initState();
  }

  final Contravention_numero = TextEditingController();
  final Contravention_motif = TextEditingController();
  final Contravention_date = TextEditingController();
  final Contravention_points = TextEditingController();
  final Date_debut = TextEditingController();
  final Date_minore = TextEditingController();
  final Date_limite = TextEditingController();
  final Telepaiment_no = TextEditingController();
  final Telepaiment_cle = TextEditingController();

  late DateTime DateDebut, DateMinore, DateLimite;



  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    print('-------------------BEGIN Text Recognized for extraction ------------------------');
    printWrapped(TextRecognized);
    print('-------------------FINAL Text Recognized for extraction-------------------------');

    var _telepaiment_debut = TextRecognized.indexOf("FRFR",0) +4 ;

    var _telepaiment_fin = TextRecognized.indexOf("Numero",0) -1;

    var _contravention_numero = TextRecognized.indexOf("de contravention", 0) + 17;

    var _contravention_date = TextRecognized.indexOf("commise", 0)+10;

    var _contravention_motif_debut = TextRecognized.indexOf("VOUS RECONNAISSEZ",0) + 30;

    var _contravention_motif_fin = TextRecognized.indexOf("Prevue",0) -2;

    var _contravention_points = TextRecognized.indexOf("Si vous designez un autre ", 0);

    var _date_debut = TextRecognized.indexOf("commence", 0) + 12;

    var _date_minore = TextRecognized.indexOf("minore", 0) + 6;

    var _date_limite = TextRecognized.indexOf("paiement forfaitaire", 0) + 21;

    var _telepaiment = TextRecognized.substring(_telepaiment_debut, _telepaiment_fin);

    print ("----------------------_telepaiment-------------------------------");
    print(_telepaiment);

    _telepaiment = _telepaiment.replaceAll(" ", "");

    print ("----------------------_telepaiment sans espaces-------------------------------");
    print(_telepaiment);

    print ("----------------------_contravention_motif_debut et fin-------------------------------");

    print ( _telepaiment_debut);

    print ( _telepaiment_fin );

    print ( _contravention_numero );

    print ( _contravention_date);

    print ( _contravention_motif_debut );

    print ( _contravention_motif_fin);

    print ( _contravention_points );

    print ( _date_debut );

    print ( _date_minore );

    print ( _date_limite );

    print ( _telepaiment );


    Contravention_numero.text = (_contravention_numero > 0)
        ? TextRecognized.substring(_contravention_numero, _contravention_numero + 10)
        : ".";

    Contravention_date.text = (_contravention_date > 0)
        ? TextRecognized.substring(_contravention_date, _contravention_date + 20)
        : ".";

    Contravention_motif.text = (_contravention_motif_debut > 0)
        ? TextRecognized.substring(_contravention_motif_debut , _contravention_motif_fin).toUpperCase() //.toLowerCase()
        : ".";
    
    //Contravention_motif.text = (_contravention_motif > 0)
    //    ? TextRecognized.substring(_contravention_motif, _contravention_motif + 30) //.toLowerCase()
    //    : ".";

    Contravention_points.text = (_contravention_points > 0)
        ? "Cette infraction entraine un retrait de points"
        : "Aucun retrait de points liés à cette infraction";

    Date_debut.text = (_date_debut > 0)
        ? TextRecognized.substring(_date_debut, _date_debut + 10)
        : ".";

    Date_minore.text = (_date_minore > 0)
        ? TextRecognized.substring(_date_minore, _date_minore + 12).trim()
        : ".";

    Date_limite.text = (_date_limite > 0)
        ? TextRecognized.substring(_date_limite, _date_limite + 10).trim()
        : ".";

     Telepaiment_no.text = (_telepaiment != null)
        ? _telepaiment.substring(0, 14)
        : ".";

     print(Telepaiment_no.text);

    Telepaiment_cle.text = (_telepaiment != null)
        ? _telepaiment.substring(14, 16)
        : ".";
    print(Telepaiment_cle.text);

    DateDebut = DateFormat('dd/MM/yyyy').parse(Date_debut.text) ;
    DateMinore = DateDebut.add(Duration(days:30)) ;
    DateLimite = DateDebut.add(Duration(days:60)) ;


    print ("----------------------1-------------------------------");
    print(Telepaiment_no.text);
    print(Telepaiment_cle.text);
    print ("-----------------------2------------------------------");
    print(_contravention_numero);
    print(_contravention_date);
    //print(_contravention_motif);
    print(_contravention_points);
    print ("-----------------------3------------------------------");
    print(_date_debut);
    print(_date_minore);
    print(_date_limite);
    print ("------------------------4-----------------------------");
    print(_contravention_motif_debut);
    print(_contravention_motif_fin);
    print ("------------------------5-----------------------------");
    print(DateDebut);
    print(DateMinore);
    print(DateLimite);

    TextFormField inputcontravention_date = TextFormField(
      controller: Contravention_date,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Date de l\'infraction :',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputcontravention_motif = TextFormField(
      controller: Contravention_motif,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Infraction :',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputcontravention_numero = TextFormField(
      controller: Contravention_numero,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Numéro de l\'avis',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputcontravention_points = TextFormField(
      controller: Contravention_points,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Retraits de points :',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField input_date_debut = TextFormField(
      controller: Date_debut,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'date_debut',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField input_date_minore = TextFormField(
      controller: Date_minore,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'date minorée',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField input_date_limite = TextFormField(
      controller: Date_limite,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Date limite : ',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputTelepaiment_no = TextFormField(
      controller: Telepaiment_no,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Telepaiment_no',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputTelepaiment_cle = TextFormField(
      controller: Telepaiment_cle,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Telepaiment_cle',
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
              inputTelepaiment_cle,
              inputcontravention_date,
              inputcontravention_numero,
              inputcontravention_points,
              inputcontravention_motif,
              input_date_debut,
              input_date_minore,
              input_date_limite
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Merci de vérifier",
                    style: TextStyle_regular,),
                Text("les informations ci-dessous : ",
                    style: TextStyle_regular),
              ],
            ),
          ),
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
            child: SingleChildScrollView(
              child: amende_infos,
            ),
          ),
          Container(
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
                              builder: (context) => antai_website(
                                  num: Telepaiment_no.text,
                                  cle: Telepaiment_cle.text)));
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
        ],
      ),
    );
  }
}
