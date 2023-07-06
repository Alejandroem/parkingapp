// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../widget/widgets.dart';
import '../text_FR.dart';
import '../databases/DatabaseClient.dart';
import '../databases/documents.dart';

class screen4_check_list extends StatefulWidget {
  static const title = 'Liste infos';
  static const androidIcon = Icon(Icons.library_books);
  static const iosIcon = Icon(CupertinoIcons.news);

  const screen4_check_list({super.key, this.androidDrawer});
  final Widget? androidDrawer;

  @override
  State<screen4_check_list> createState() => screen4_check_listState();
}

class screen4_check_listState extends State<screen4_check_list> {


  late final List<String> contents;

  var items = <Documents>[];
  var _color;

  @override
  void initState() {
    initializeDateFormatting('fr-FR', '');
    getDocuments();
    contents =[texte_cl_00,texte_cl_01,texte_cl_02,texte_cl_03,texte_cl_04,texte_cl_05,texte_cl_05,texte_cl_05,texte_cl_05,texte_cl_05];
    super.initState();
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
                  backgroundColor:
                  (items[index].date_fin != null)
                      ? Colors.green
                      : Colors.red,
                  child: Text(
                    items[index].nom!.substring(0, 1),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),


                const Padding(padding: EdgeInsets.only(left: 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              items[index].nom!,
                              style: TextStyle_medium
                          ),

                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                          (items[index].date_fin != null)
                              ? 'Validité : ' + DateFormat.yMMMEd('fr-FR').format(DateTime.parse(items[index].date_fin!.toString()))
                              : 'Aucune information enregistrée',
                          style: TextStyle_small),
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
    final fromDb = await DatabaseClient().DocumentsList2();
    setState(() {
      items = fromDb;
    });
  }


  getDate(BuildContext context, int idKey) {
    // if (items[index].id != 2) {
    // idKey = idKey-1;
    DateTime initialDate = DateTime.now();
    showDatePicker(
      context: context,
      //locale : const Locale("fr","FR"),
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    ).then((value) =>
    {
      if (value != null) {
        setState(() {
          print(value);
          print(idKey);
          Map<String, dynamic> map = {'documents': idKey};
          map["id"] = idKey!;
          map["nom"] = items[idKey].nom!;
          map["date_fin"] = value.toString();
          Documents documents = Documents.fromMap(map);
          print(
              '******************************************************************');
          print(idKey);
          print(value.toString());
          print(
              '******************************************************************');
          DatabaseClient()
              .DocumentsUpdateDate(idKey, value.toString())
              .then((success) =>
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => screen4_check_list())));
        })
      }
    });
  }

  ColorDetermination(String _date) {
    Color ColorToShow;
    var _date1 = DateTime.parse(_date);
    var _date0 = DateTime.parse(DateTime.now().toString());
    Duration diff = _date1.difference(_date0);
    if (diff.inDays > 30) {
      ColorToShow = Colors.green;
    } else if (diff.inDays < 30 && diff.inDays > 0) {
      ColorToShow = Colors.red;
    } else {
      ColorToShow = Colors.red;
    }
    return ColorToShow;
  }



  // ===========================================================================
  // Non-shared code below because this tab uses different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
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
