// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../databases/documents.dart';
import '../model/takepicture.dart';
import '../drawerscreens/documents_show.dart';
import '../widget/widgets.dart';
import '../databases/databases.dart';



class mespapiers extends StatefulWidget {

  const mespapiers({super.key, this.androidDrawer});
  final Widget? androidDrawer;

  @override
  mespapiersState createState() => mespapiersState();
}

class mespapiersState extends State<mespapiers> {

  var items = <Documents>[];
  late final List<Color> colors;
  var imgString;

  @override
  void initState() {
    colors = [Colors.teal,Colors.teal,Colors.teal,Colors.teal,Colors.grey,Colors.grey,Colors.grey];
    getDocuments();
    super.initState();
  }

  Widget _listBuilder(BuildContext context, int index) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Card(
        elevation: 1.5,
        margin: const EdgeInsets.fromLTRB(6, 12, 6, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),

        child: InkWell(

            onTap: () {
              (items[index].image == null)
                  ? {Navigator.push(context,MaterialPageRoute(builder: (context) =>  Takepicture(IdKey: items[index].id as int,IdNom: items[index].nom as String)))}
                  : {Navigator.push(context,MaterialPageRoute(builder: (context) =>  DocumentsShow()))};
              },

            onLongPress: () =>
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Vous souhaitez'),
                        content: Text('refaire la photo de ce document ?'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) =>  Takepicture(IdKey: items[index].id as int,IdNom: items[index].nom as String))),
                              child: Text('OK')),
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Non')),
                        ],
                      );
                    }
                    ),
        child: Padding(padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              <Widget>[
                (items[index].image == null)
                    ? CircleAvatar(backgroundColor: colors[index], radius: 27)
                    : CircleAvatar(backgroundColor: Colors.white, radius: 27,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(60.0),
                              child: Image.file(
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  File(items[index].image.toString())))),

                const Padding(padding: EdgeInsets.only(left: 16)),

                Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            items[index].nom!,
                            style: const TextStyle(
                                fontSize: 22,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),

                          Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                child:
                                  IconButton(
                                   onPressed: (){
                                     showDialog(
                                         context: context,
                                         builder: (context) {
                                           return AlertDialog(
                                             title: Text('Votre ' +  items[index].nom!),
                                             content: Text(' a t il une date de validité ?'),
                                             actions: <Widget>[
                                               TextButton(
                                                   onPressed: (() => getDate(context, items[index].id!)),
                                                   child: Text('Oui')),
                                               TextButton(
                                                   onPressed: () => Navigator.of(context).pop(),
                                                   child: Text('Non')),
                                             ],
                                           );
                                         }
                                     );
                                   },
                                   icon: Icon(Icons.edit, size:20, color: color_background2))),

                              )
                      ],
                      ),

                      const Padding(padding: EdgeInsets.only(top: 8)),

                      (items[index].image == null)
                      ? Text(
                        ( items[index].date_fin != null ) ?'date fin : ' + items[index].date_fin!.toString() : '***' ,
                        //"Cliquez sur le cercle de couleur pour prendre en photo votre document" ,
                          style: const TextStyle(
                            fontSize: 8,
                            color: Colors.black,
                          ),
                      )
                      : Text(
                        ( items[index].date_fin != null ) ?'date fin : ' + items[index].date_fin!.toString() : '***' ,
                        //"Cliquez de manière prolongée pour reprendre en photo votre document" ,
                          style: const TextStyle(
                          fontSize: 8,
                          color: Colors.black,
                          ),
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


  getDocuments() async {
    final fromDb = await DatabaseClient().DocumentsList1();
    setState(() {
    items = fromDb;
    });
  }

getDate(BuildContext context, int idKey)  {
 // if (items[index].id != 2) {
 // idKey = idKey-1;
  DateTime initialDate = DateTime.now();
  showDatePicker(
  context: context,
  //locale : const Locale("fr","FR"),
  initialDate: initialDate,
  firstDate: DateTime(2020),
  lastDate: DateTime(2050),
  ).then((value) => {
    if (value != null) {
      setState(() {
        print(value);
        print(idKey);
        Map<String, dynamic> map = {'documents': idKey};
        map["id"]  = idKey!;
        map["nom"] = items[idKey].nom!;
        map["date_fin"] = value.toString();
        Documents documents = Documents.fromMap(map);
        DatabaseClient()
            .DocumentsUpdateDate(idKey, value.toString())
            .then((success) => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>mespapiers())));
      })

    }
  });

}


  // ===========================================================================
  // Non-shared code below because this tab uses different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Documents'),
        backgroundColor: color_background2,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: _listBuilder,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: _listBuilder,
      ),
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}


