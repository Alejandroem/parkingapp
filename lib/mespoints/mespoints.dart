// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mycar/mespoints/mespoints_webview.dart';
import '../constants.dart';
import '../databases/databases.dart';
import '../databases/permis.dart';
import '../services/webview.dart';

class mespoints extends StatefulWidget {
  const mespoints({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<mespoints> createState() => mespointsState();
}

class mespointsState extends State<mespoints> {

  @override
  void initState() {
    getPermisInfo();
    super.initState();
  }

  // recupération des informations sur le véhicule
  var items = <Permis>[];

  var _code1;
  var _code2;
  var _code3;
  var _code_consultation;

  Future<bool> getPermisInfo() async {
    final fromDb = await DatabaseClient().PermisInfo(idKey: 0);
    if (fromDb != null) {
      setState(() {
        items = fromDb;
      });
      return true;
    } else {
      return false;
    }

  }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;

    var base_url   = "https://tele7.interieur.gouv.fr/tlp/";
    var _url   = base_url ;

    if (items?[0].code1 != null) {
      _code1 = items?[0].code1.toString();
    } else {_code1 = "";}


    if (items?[0].code2 != null) {
      _code2 = items?[0].code2.toString();
    } else {_code1 = "";}

    if (items?[0].code3 != null) {
      _code3 = items?[0].code3.toString();
    } else {_code1 = "";}


    if (items?[0].code_consultation != null) {
      _code_consultation = items?[0].code_consultation;
    } else {_code1 = "";}


    return Scaffold(
        appBar: AppBar(
          title: const Text('Consulter mes points'),
          backgroundColor: color_background2,
        ),
        body: Center(
          child: Column(
            children: [

              Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(25),
                  height: 490,
                  decoration: BoxDecoration(
                    color: color_background,
                    border: Border.all(color: color_border),
                    borderRadius: BorderRadius.circular(border_radius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),

                  child: Center(
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text("Vous allez pouvoir consulter le solde de vos points sur le site officiel 'Télépoints'. Vérifiez ou saisissez vos codes de consultation",
                                  style: TextStyle_small),
                            ),
                          ],
                        ),


                        TextFormField(
                          initialValue: _code1,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Case 1',
                          ),
                        ),

                        TextFormField(
                          initialValue: _code2,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Case 2',
                          ),
                        ),

                        TextFormField(
                          initialValue: _code3,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Case 3',
                          ),
                        ),

                        TextFormField(
                          initialValue: _code_consultation,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Votre code Telepoint',
                          ),
                        ),

                        Divider(),

                        Text( 'Sur la page suivante cliquez sur ',
                          style: TextStyle_small ),

                        Divider(),

                        Container(
                         // margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          height: 33,
                          decoration: BoxDecoration(
                            color: color_background,
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(border_radius),
                          ),
                          child:
                          Text( ' Se connecter avec son code confidentiel Télépoints',
                              style: TextStyle_small_red),
                        ),

                        Divider(),

                        Container(
                          height: 40,
                          width: size.width-75,
                          decoration: BoxDecoration(
                              color: color_background2,
                              border: Border.all(
                                color: color_background2,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: TextButton(
                            child: Text("Cliquez ici pour consulter vos points",
                                style: TextStyle_verysmall_white),
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => mespoints_webview(code1: _code1,code2: _code2,code3: _code3,code_consultation: _code_consultation)));
                            },
                          ),
                        ),
                      ],
                    ),
                  )
              ),

              Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(25),
                  height: 190,
                  decoration: BoxDecoration(
                    color: color_background,
                    border: Border.all(color: color_border),
                    borderRadius: BorderRadius.circular(border_radius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),

                  child: Center(
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text("Cliquez-sur les des 2 boutons ci-dessous si vous avez besoin d'aide",
                                  style: TextStyle_small),
                            ),
                          ],
                        ),

                        Container(
                          height: 40,
                          width: size.width-75,
                          decoration: BoxDecoration(
                              color: color_background,
                              border: Border.all(
                                color: color_background2,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: TextButton(
                            child: Text("Vous avez un permis 3 volets",
                                style: TextStyle_verysmall),
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => webview(url: "https://permisdeconduire.ants.gouv.fr/tout-savoir-sur-le-permis/le-numero-de-dossier-sur-un-ancien-permis",title:"Permis 3 volets")));
                            },
                          ),
                        ),
                        Container(
                          height: 40,
                          width: size.width-75,
                          decoration: BoxDecoration(
                              color: color_background,
                              border: Border.all(
                                color: color_background2,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: TextButton(
                            child: Text("Vous avez un permis format carte de crédit",
                                style: TextStyle_verysmall),
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => webview(url: "https://permisdeconduire.ants.gouv.fr/tout-savoir-sur-le-permis/le-numero-de-dossier-sur-un-permis-au-format-carte-bancaire",title:"Permis Carte de crédit")));
                            },
                          ),
                        ),
                      ],
                    ),

                  )
              ),


            ],
          ),
        )
    );
  }

}
