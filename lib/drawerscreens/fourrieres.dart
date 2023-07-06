// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chaleno/chaleno.dart';
import '../utils.dart';
import '../widget/widgets.dart';
import '../text_FR.dart';
import '../constants.dart';

class fourrieres extends StatefulWidget {
  static const title = 'Liste infos';
  static const androidIcon = Icon(Icons.library_books);
  static const iosIcon = Icon(CupertinoIcons.news);

  const fourrieres({super.key, this.androidDrawer});
  final Widget? androidDrawer;

  @override
  State<fourrieres> createState() => fourrieresState();
}

class fourrieresState extends State<fourrieres> {
  static const _itemsLength = 5;
  String? title;

  late final List<int> villesCnt;
  late final List<String> villesName;
  late final List<String> villesUrl;
  late final List<String> villesReponse;

  String plaqueImmat = 'ED-558-DY';


  @override
  void initState() {
    villesName = ['Paris', 'Lille', 'Lyon', 'Marseille', 'Nice'];
    villesUrl = [
      'https://teleservices.paris.fr/fourrieres/',
      'https://www.lille-fourriere.fr/recherche?field_numberplate=',
      'https://www.lyon-fourriere.fr/recherche?field_numberplate=',
      'https://www.marseille-fourriere.fr/recherche?field_numberplate=',
      'https://fourriere.nice.fr/#'
    ];
    villesReponse = [
      'recherche non aboutie',
      'recherche non aboutie',
      'recherche non aboutie',
      'recherche non aboutie',
      'recherche non aboutie'
    ];

    super.initState();
  }

  Future<String> scrapData() async {
    for (var i = 1; i < 4; i++) {
      final baseUrl = villesUrl[i] + plaqueImmat;
      var response = await Chaleno().load('$baseUrl');
      print(baseUrl);

      switch (i) {
        case 0:
          title = response
              ?.getElementsByClassName(
              'MuiBox-root jss18')
               // 'field field--name-node-title field--type-ds field--label-hidden field__item')
              .first
              .text;
          break;
        case 1:
          title = response
              ?.getElementsByClassName(
              'field field--name-node-title field--type-ds field--label-hidden field__item')
              .first
              .text;
          break;
        case 2:
          title = response
              ?.getElementsByClassName(
              'field field--name-node-title field--type-ds field--label-hidden field__item')
              .first
              .text;
          break;
        case 3:
          title = response
              ?.getElementsByClassName(
              'field field--name-node-title field--type-ds field--label-hidden field__item')
              .first
              .text;
          break;
        case 4:
          title = response
              ?.getElementsByClassName(
              'id="fancy-title-8" class="mk-fancy-title align-center  simple-style title_slide color-single')
              .first
              .text;
      }
      villesReponse[i] = title!;
      print (villesReponse[i]);
    }

   // setState(() {});

    return (villesReponse[0]);
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: scrapData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('=============== Snapshot no data ==========');
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Fourrières'),
                ),
                body: Center(
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text("Patientez",
                            style: TextStyle_large,
                          ),

                          Text("Nous interrogeons les fourrières suivantes :",
                            style: TextStyle_regular,
                          ),

                          Text("Paris, Lille, Lyon, Marseille et Nice",
                            style: TextStyle_regular,
                          ),

                          Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              height: 200,
                              width: 200,
                              child: CircularProgressIndicator()
                          ),

                          Text(". . .",
                              style: TextStyle_regular,
                              ),
                        ],
                      )
                ),
              );
          }

          return  Scaffold(
            appBar: AppBar(
              title: const Text('Fourrières'),
            ),
            body: Stack(
                children: [
                  /*
                  Text("Voici le résultat de nos recherches ",
                  style: TextStyle_regular),
                  */

                  ListView.builder(
                    itemCount: _itemsLength,
                    itemBuilder: _listBuilder,
                  ),
                ]
            ),

          );
        });
  }

  Widget _listBuilder(BuildContext context, int index) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Card(
        elevation: 1.5,
        margin: const EdgeInsets.fromLTRB(6, 12, 6, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          // Make it splash on Android. It would happen automatically if this
          // was a real card but this is just a demo. Skip the splash on iOS.
          onTap: defaultTargetPlatform == TargetPlatform.iOS ? null : () {},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: color_background2,
                  child: Text(
                    villesName[index].substring(0, 1),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        villesName[index],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                        villesReponse[index],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
