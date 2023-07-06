import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../constants.dart';
import '../text_FR.dart';
import '../drawerscreens/controle_technique.dart';

class ApiFrenchControleTechnique extends StatefulWidget {
  const ApiFrenchControleTechnique({Key? key}) : super(key: key);

  @override
  State<ApiFrenchControleTechnique> createState() => _ApiFrenchControleTechniqueState();
}

final _countDownController = CountDownController();

class _ApiFrenchControleTechniqueState extends State<ApiFrenchControleTechnique> {

  static const List<String> list_vehicule = <String>['Voiture Particulière', '4 x 4', 'Camionnette', 'Camping-car (moins de 3,5 tonnes)', 'Voiture de collection', 'Poids Lourd'];
  String dropdownValue_vehicule = list_vehicule.first;

  static const List<String> list_carburant = <String>['Diesel', 'Essence', 'Electrique', 'Hybride', 'Gaz'];
  String dropdownValue_carburant = list_carburant.first;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: color_background,
      appBar: AppBar(
        title: const Text('Centres de Controle Technique'),
        backgroundColor: color_background2,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          height: 500,
          width: 350,
          decoration: BoxDecoration(
            color: color_background,
            border: Border.all(color: color_border),
            borderRadius: BorderRadius.circular(border_radius),
          ),
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 20),

              Text('Précisez votre recherche',
                  style: TextStyle_large),

              SizedBox(height: 30),

              Text('Choisissez le type de véhicule',
                  style: TextStyle_regular),

              SizedBox(height: 20),

              DropdownButton<String>(
                value: dropdownValue_vehicule,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue_vehicule = value!;
                  });
                },
                items: list_vehicule.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: TextStyle_regular),
                  );
                }).toList(),
              ),

              SizedBox(height: 30),

              Text('Choisissez le type de carburant',
                  style: TextStyle_regular),

              SizedBox(height: 20),

              DropdownButton<String>(
                value: dropdownValue_carburant,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue_carburant = value!;
                  });
                },
                items: list_carburant.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: TextStyle_regular),
                  );
                }).toList(),
              ),

              SizedBox(height: 30),

              SizedBox(
                height:50,
                width:200,
                child:
                TextButton(
                  style: TextButton.styleFrom(
                    elevation: 12,
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => controletechnique()));
                  },

                  child: Text ('Rechercher', style: TextStyle(fontSize: 24)),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),

        ),
      ),

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

/*

facet : 'cat_vehicule_libelle'
0 : Voiture Particulière
1 : 4 x 4
2 : Camionnette
3 : Camping-car (moins de 3,5 tonnes)
4 : Voiture de collection
5 : Poids Lourd

facet : 'cat_energie_libelle'
0 : Diesel
1 : Essence
2 : Electrique
3 : Hybride
4 : Gaz
 */
