// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/widgets.dart';

class screenparam extends StatefulWidget {
  static const title = 'Paramètres';
  static const androidIcon = Icon(Icons.settings);
  static const iosIcon = Icon(CupertinoIcons.gear);

  const screenparam({super.key});

  @override
  State<screenparam> createState() => _screenparam();
}

class _screenparam extends State<screenparam> {


 // String _savedData = '';

 // final SharedPreferences prefs = await SharedPreferences.getInstance();

  bool switch1 = false;
  bool switch2 = false;
  bool switch3 = false;
  bool switch4 = false;
  bool switch5 = false;
  bool switch6 = false;
  bool switch7 = false;


  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switch1 = prefs.getBool('switch1') ?? false;
      switch2 = prefs.getBool('switch2') ?? false;
      switch3 = prefs.getBool('switch3') ?? false;
      switch4 = prefs.getBool('switch4') ?? false;
      switch5 = prefs.getBool('switch5') ?? false;
      switch6 = prefs.getBool('switch6') ?? false;
      switch7 = prefs.getBool('switch7') ?? false;
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switch1', switch1);
    await prefs.setBool('switch2', switch2);
    await prefs.setBool('switch3', switch3);
    await prefs.setBool('switch4', switch4);
    await prefs.setBool('switch5', switch5);
    await prefs.setBool('switch6', switch6);
    await prefs.setBool('switch7', switch7);
    _loadSavedData(); // Refresh the displayed data
  }


  Widget _buildList() {
    return ListView(
      children: [
        const Padding(padding: EdgeInsets.only(top: 24)),
        ListTile(
          title: const Text('Alertes Paiement stationnement'),
          // The Material switch has a platform adaptive constructor.
          trailing: Switch.adaptive(
            value: switch1,
            onChanged: (value) => setState(() => switch1 = value),
          ),
        ),
        ListTile(
          title: const Text('Conserver historique stationnement'),
          trailing: Switch.adaptive(
            value: switch2,
            onChanged: (value) => setState(() => switch2 = value),
          ),
        ),
        ListTile(
          title: const Text('Alertes Vitesse'),
          trailing: Switch.adaptive(
            value: switch3,
            onChanged: (value) => setState(() => switch3 = value),
          ),
        ),
        ListTile(
          title: const Text('Alertes Radars'),
          trailing: Switch.adaptive(
            value: switch4,
            onChanged: (value) => setState(() => switch4 = value),
          ),
        ),
        ListTile(
          title: const Text('Rappel FPS'),
          trailing: Switch.adaptive(
            value: switch5,
            onChanged: (value) => setState(() => switch5 = value),
          ),
        ),
        ListTile(
          title: const Text('Rappel paiements'),
          trailing: Switch.adaptive(
            value: switch6,
            onChanged: (value) => setState(() => switch6 = value),
          ),
        ),
        ListTile(
          title: const Text('Rappels cartes'),
          trailing: Switch.adaptive(
            value: switch7,
            onChanged: (value) => setState(() => switch7 = value),
          ),
        ),
        TextButton(onPressed: _saveData, child: Text("Sauvegarder")),
      ],
    );
  }

  // ===========================================================================
  // Non-shared code below because this tab uses different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(screenparam.title),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _buildList(),
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
