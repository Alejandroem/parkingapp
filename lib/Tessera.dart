import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

void main() {
  runApp(Tessera());
}

class Tessera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OCRScreen(),
    );
  }
}

class OCRScreen extends StatefulWidget {
  @override
  _OCRScreenState createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  String ocrText = '';
  final picker = ImagePicker();

  Future<void> _performOCR(File imageFile) async {
    try {
      final text = await FlutterTesseractOcr.extractText(imageFile.path);
      setState(() {
        ocrText = text;
        print ("***********************************************");
        print (text);

      });
    } catch (e) {
      print("Erreur lors de l'OCR : $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _performOCR(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR avec Tesseract'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (ocrText.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Texte OCR :',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            if (ocrText.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  ocrText,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Sélectionner une image'),
            ),
          ],
        ),
      ),
    );
  }
}
