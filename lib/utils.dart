// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dart_date/dart_date.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

const _myListOfRandomColors = [
  Colors.red,
  Colors.blue,
  Colors.teal,
  Colors.yellow,
  Colors.amber,
  Colors.deepOrange,
  Colors.green,
  Colors.indigo,
  Colors.lime,
  Colors.pink,
  Colors.orange,
];


String capitalize(String word) {
  return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
}

String capitalizePair(WordPair pair) {
  return '${capitalize(pair.first)} ${capitalize(pair.second)}';
}


ColorConditionalText(DateTime date, int delai) {
  DateTime today = DateTime.now();
  Color color;
  if(date > today.addMonths(delai)) { color = Colors.white; }
  else { if(date > today) { color = Colors.orange; }
  else { color = Colors.red; }
  }
 return color;

}

String dayFromInt(int day) {
  switch (day) {
    case 1: return "Lundi";
    case 2: return "Mardi";
    case 3: return "Mercredi";
    case 4: return "Jeudi";
    case 5: return "Vendredi";
    case 6: return "Samedi";
    default: return "Dimanche";
  }
}





/* prendre une photo :

  import 'package:image_picker/image_picker.dart';

  IconButton(onPressed: (() => takePicture(ImageSource.camera)), icon: const Icon(Icons.camera_alt)),
  IconButton(onPressed: (() => takePicture(ImageSource.gallery)), icon: const Icon(Icons.photo_library_outlined)),

  takePicture(ImageSource source) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);
    if (xFile == null) return;
    setState(() {
      imagePath = xFile!.path;
    });
  }

*/