// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../amendes/antai/antai_webview.dart';
import '../../constants.dart';
import '../../widget/widgets.dart';
import '../../databases/databases.dart';
import '../../databases/amendes.dart';

class list_amendes extends StatefulWidget {
  static const title = 'Liste infos';
  static const androidIcon = Icon(Icons.library_books);
  static const iosIcon = Icon(CupertinoIcons.news);

  const list_amendes({super.key, this.androidDrawer});
  final Widget? androidDrawer;

  @override
  State<list_amendes> createState() => list_amendesState();
}

class list_amendesState extends State<list_amendes> {


  late final List<String> contents;

  var items = <Amendes>[];
  var _color;

  @override
  void initState() {
    initializeDateFormatting('fr-FR', '');
    getPVList();
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
                    items[index].pv_type!.substring(0, 1),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                const Padding(padding: EdgeInsets.only(left: 16)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          Text(
                               items[index].telepaiement_no! + " - " + items[index].telepaiement_cle!,
                               style: TextStyle_medium
                              ),

                          Spacer(),

                          IconButton(
                            icon: const Icon(Icons.monetization_on_outlined),
                            onPressed: () {
                                     Navigator.push(context,
                                     MaterialPageRoute(builder: (context) => antai_webview(num: items[index].telepaiement_no, cle:items[index].telepaiement_cle)));
                                    //antai_webview(num: "33364679519491", cle:"17")));
                                 },
                          ),
                        ],
                      ),

                      const Padding(padding: EdgeInsets.only(top: 8)),

                      Text(
                          (items[index].pv_type != null)
                              ? items[index].pv_type.toString() + ' du : ' + items[index].date_debut.toString()
                              : '',
                          style: TextStyle_small),
                      Text(
                          (items[index].date_fin != null)
                              ? 'A payer avant le : ' + DateFormat.yMMMEd('fr-FR').format(DateTime.parse(items[index].date_fin!.toString()))
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

  getPVList() async {
    final fromDb = await DatabaseClient().AmendesList( idType: 1);
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
          map["telepaiement_no"] = items[idKey].telepaiement_no!;
          map["date_fin"] = value.toString();
          Amendes amendes = Amendes.fromMap(map);
          DatabaseClient()
              .DocumentsUpdateDate(idKey, value.toString())
              .then((success) =>
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => list_amendes())));
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
      appBar: AppBar(
        title: const Text('Liste de vos amendes'),
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
