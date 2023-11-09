// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import '../databases/databases.dart';
import '../databases/contacts.dart';
import 'mesadresses_edit.dart';



class mesadresses extends StatefulWidget {
  const mesadresses({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<mesadresses> createState() => mesadressesState();
}

class mesadressesState extends State<mesadresses> {
  static const _itemsLength = 6;

  // recupération des informations sur les contacts

  var items = <Contacts>[];
  var url;

  Future<bool> getContactsInfo() async {
    final fromDb = await DatabaseClient().ContactsList();
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
  void initState() {
    getContactsInfo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes adresses'),
        backgroundColor: color_background2,
      ),
      body: Container(
      //  height: size.height,
      //  width: size.width,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child:   Column (
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            InkWell(
              onLongPress: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => mesadresses_edit(idKey:2)));
              },
              child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(5),
                  height: 200,
                  // width: _width,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(items[1].libelle.toString(),
                                  style: TextStyle_large),
                              Text( items[1].societe.toString()  ,
                                  style: TextStyle_regular),
                              Text( items[1].sexe.toString() + " " + items[1].firstname.toString() + " " + items[1].lastname.toString(),
                                  style: TextStyle_regular),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap: () {
                                            send_phonecall(items[1].tel2.toString());
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              FaIcon(FontAwesomeIcons.phone,
                                                  color: Colors.white), // <-- Icon
                                              // <-- Text
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap: () {send_whatsapp(items[1].tel2.toString(), "Bonjour");},
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              FaIcon(FontAwesomeIcons.whatsapp, // <-- Icon
                                                  color: Colors.white,
                                                  size: 36),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap:  () {send_sms(items[1].tel2.toString(),"Bonjour");},
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.sms,
                                                  color: Colors.white,
                                                  size: 36),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap: () {send_email(items[1].email.toString(),"Demande de RDV $items[1].firstname.toString() $items[1].lastname.toString()","Bonjour");},
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.email,
                                                  color: Colors.white,
                                                  size: 36),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )

                                ],

                              ),
                            ]
                        ),
                      ),

                    ],
                  )
              ),
            ),


            InkWell(
              onLongPress: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => mesadresses_edit(idKey:3)));
              },
              child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(5),
                  height: 200,
                  // width: _width,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(items[2].libelle.toString(),
                                  style: TextStyle_large),
                              Text( items[2].societe.toString()  ,
                                  style: TextStyle_regular),
                              Text( items[2].adresse1.toString() + " " + items[2].code_postal.toString() + " " + items[2].ville.toString() ,
                                  style: TextStyle_regular),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap: () {
                                            send_phonecall(items[2].tel2.toString());
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              FaIcon(FontAwesomeIcons.phone,
                                                  color: Colors.white), // <-- Icon
                                              // <-- Text
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap: () {send_whatsapp(items[2].tel2.toString(), "Bonjour");},
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              FaIcon(FontAwesomeIcons.whatsapp, // <-- Icon
                                                  color: Colors.white,
                                                  size: 36),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap:  () {send_sms(items[2].tel2.toString(),"Bonjour");},
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.sms,
                                                  color: Colors.white,
                                                  size: 36),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap: () {send_email(items[2].email.toString(),"Demande de RDV $items[1].firstname.toString() $items[1].lastname.toString()","Bonjour");},
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.email,
                                                  color: Colors.white,
                                                  size: 36),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )

                                ],

                              ),
                            ]
                        ),
                      ),
                    ],
                  )
              ),
            ),


            InkWell(
              onLongPress: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => mesadresses_edit(idKey:4)));
              },
              child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(5),
                  height: 200,
                  // width: _width,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(items[3].libelle.toString(),
                                  style: TextStyle_large),
                              Text( items[3].societe.toString(),
                                  style: TextStyle_regular),
                              Text( items[3].sexe.toString() + " " + items[3].firstname.toString() + " " + items[3].lastname.toString(),
                                  style: TextStyle_regular),

                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap: () {
                                            send_phonecall(items[3].tel2.toString());
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              FaIcon(FontAwesomeIcons.phone,
                                                  color: Colors.white), // <-- Icon
                                              // <-- Text
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap: () {send_whatsapp(items[3].tel2.toString(), "Bonjour");},
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              FaIcon(FontAwesomeIcons.whatsapp, // <-- Icon
                                                  color: Colors.white,
                                                  size: 36),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap:  () {send_sms(items[3].tel2.toString(),"Bonjour");},
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.sms,
                                                  color: Colors.white,
                                                  size: 36),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox.fromSize(
                                    size: Size(60, 60),
                                    child: ClipOval(
                                      child: Material(
                                        color: color_background2,
                                        child: InkWell(
                                          splashColor: Colors.green,
                                          onTap: () {
                                            send_email(items[3].email.toString(),'Demande de RDV $items[1].firstname.toString() $items[1].lastname.toString()','Bonjour');},
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.email,
                                                  color: Colors.white,
                                                  size: 36),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )

                                ],

                              ),
                            ]
                        ),
                      ),

                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Future<void> send_phonecall(String _phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: _phoneNumber,
    );
    await launchUrl(launchUri);
  }


  Future<void> send_sms(String _phoneNumber, String _body) async {
    final Uri launchUri = Uri(
      scheme: 'smsto',
      path: _phoneNumber,
      queryParameters: <String, String>{'body': Uri.encodeComponent(_body)}
      );

    await launchUrl(launchUri);
     }


  Future<void> send_whatsapp(String _phoneNumber, String _body) async {
    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$_phoneNumber&text=$_body");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp semble ne pas être installé"),
        ),
      );
    }
  }


  Future<void> send_email(String _adresse, String _subject, String _body) async {
    String email = Uri.encodeComponent(_adresse);
    String subject = Uri.encodeComponent(_subject);
    String body = Uri.encodeComponent(_body);
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (await launchUrl(mail)) {
      //email app opened
    }else{
      //email app is not opened
    }
  }





}
