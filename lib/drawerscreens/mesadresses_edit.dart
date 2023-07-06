// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../databases/contacts.dart';
import '../constants.dart';
import '../databases/DatabaseClient.dart';
import '../databases/permis.dart';
import '../text_FR.dart';
import '../utils.dart';
import '../services/webview.dart';
import '../services/location_service.dart';

class mesadresses_edit extends StatefulWidget {
  const mesadresses_edit({super.key, this.androidDrawer, this.idKey});

  final Widget? androidDrawer;
  final int? idKey;

  @override
  State<mesadresses_edit> createState() => mesadresses_editState();
}

class mesadresses_editState extends State<mesadresses_edit> {
  var items = <Contacts>[];
  var url;
  var _idKey;

  final _formKey = GlobalKey<FormState>();
  final _libelle = TextEditingController();
  final _societe = TextEditingController();
  final _poste = TextEditingController();
  final _sexe = TextEditingController();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _email = TextEditingController();
  final _tel = TextEditingController();
  final _tel2 = TextEditingController();
  final _adresse1 = TextEditingController();
  final _adresse2 = TextEditingController();
  final _code_postal = TextEditingController();
  final _ville = TextEditingController();

  Future<bool> GetContact(idKey) async {
    final fromDb = await DatabaseClient().GetContactInfo(idKey);
    if (fromDb != null) {
      setState(() {
        items = fromDb;
        _libelle.text = items[0].libelle ?? "";
        _societe.text = items[0].societe ?? "";
        _poste.text = items[0].poste ?? "";
        _sexe.text = items[0].sexe ?? "";
        _firstname.text = items[0].firstname ?? "";
        _lastname.text = items[0].lastname ?? "";
        _email.text = items[0].email ?? "";
        _tel.text = items[0].tel ?? "";
        _tel2.text = items[0].tel2 ?? "";
        _adresse1.text = items[0].adresse1 ?? "";
        _adresse2.text = items[0].adresse2 ?? "";
        _code_postal.text = items[0].code_postal ?? "";
        _ville.text = items[0].ville ?? "";
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    _idKey = widget.idKey;
    GetContact(_idKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;

    TextFormField inputLibelle = TextFormField(
      controller: _libelle,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Libellé',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputSociete = TextFormField(
      controller: _societe,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Société',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputPoste = TextFormField(
      controller: _poste,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Poste',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputSexe = TextFormField(
      controller: _sexe,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Sexe',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputFirstName = TextFormField(
      controller: _firstname,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Prénom',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputLastName = TextFormField(
      controller: _lastname,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Nom',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );
/*
    MaskedTextField inputPhoneNumber = new MaskedTextField(
      maskedTextFieldController: _cPhoneNumber,
      mask: "(xxx) xxxxx.xxxx",
      maxLength: 16,
      keyboardType: TextInputType.phone,
      inputDecoration: new InputDecoration(
        labelText: "Telefone",
        icon: Icon(Icons.phone),
      ),
    );
*/
    TextFormField inputTel = TextFormField(
      controller: _tel,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Téléphone fixe',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputTel2 = TextFormField(
      controller: _tel2,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Tél Portable',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputEmail = TextFormField(
      controller: _email,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'E-mail',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputAdresse1 = TextFormField(
      controller: _adresse1,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Adresse',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputAdresse2 = TextFormField(
      controller: _adresse2,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Adresse (complément)',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputCodePostal = TextFormField(
      controller: _code_postal,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Code postal',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    TextFormField inputVille = TextFormField(
      controller: _ville,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Ville',
        icon: Icon(Icons.check_box_outline_blank),
      ),
    );

    ListView body = ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        SizedBox(height: 20),
        // picture,
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              inputSociete,
              inputPoste,
              inputSexe,
              inputFirstName,
              inputLastName,
              inputTel,
              inputTel2,
              inputEmail,
              inputAdresse1,
              inputAdresse2,
              inputCodePostal,
              inputVille
            ],
          ),
        )
      ],
    );

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Fiche de ' + items[0].libelle!),
          backgroundColor: color_background2,
          actions: <Widget>[
            Container(
              width: 80,
              child: IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    setState(() {
                      Map<String, dynamic> map = {'contact': _idKey};
                      map["id"] = _idKey!;
                      map["libelle"] = _libelle.text;
                      map["societe"] = _societe.text;
                      map["poste"] = _poste.text;
                      map["sexe"] = _sexe.text;
                      map["firstname"] = _firstname.text;
                      map["lastname"] = _lastname.text;
                      map["email"] = _email.text;
                      map["tel"] = _tel.text;
                      map["tel2"] = _tel2.text;
                      map["adresse1"] = _adresse1.text;
                      map["adresse2"] = _adresse2.text;
                      map["codepostal"] = _code_postal.text;
                      map["ville"] = _ville.text;

                      Contacts contact = Contacts.fromMap(map);
                      DatabaseClient()
                          .ContactUpdate(
                               _idKey,
                               _societe.text,
                               _poste.text,
                               _sexe.text,
                               _firstname.text,
                               _lastname.text,
                               _email.text,
                               _tel.text,
                               _tel2.text,
                               _adresse1.text,
                               _adresse2.text,
                               _code_postal.text,
                               _ville.text,
                              )
                          .then((success) => Navigator.of(context).pop());
                    });
                  }),
            )
          ],
        ),
        body: body);
  }
}
