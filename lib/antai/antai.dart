import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycar/antai/antai_result.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';

final TextRecognizer textRecognizer = TextRecognizer();

class antai extends StatefulWidget {
  @override
  State<antai> createState() => _antaiState();
}

class _antaiState extends State<antai> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  late final Future<void> _future;
  late File? _image;
  bool _isImageLoaded = false;

  String scanText = '';

  // Add this controller to be able to control de camera
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.removeObserver(this);
    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (BuildContext context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Scan Amende'),
                backgroundColor: color_background2,
              ),
              body:
               Column(children: [

              if (_isImageLoaded && _image != null)
                Expanded(
                  child: Center(
                    child: Image.file(_image!),
                  ),
                ),


              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (!_isImageLoaded)
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Conseils prise de vue",
                                  style: TextStyle_regular),
                              Text("Positionnez votre document",
                                  style: TextStyle_regular),
                              Text("sur un fond non blanc",
                                  style: TextStyle_regular),
                              ElevatedButton(
                                onPressed:  _captureImage,
                                child: Text("Prendre une photo ",
                                    style: TextStyle_verysmall),)
                            ]
                        ),
                      ],
                    ),
                  ),
                ],
              ),


              if (_isImageLoaded && _image != null)


                Container(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Center(
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: _captureImage,
                          child: const Text('Recommencer'),
                        ),
                        ElevatedButton(
                          onPressed: _scanImage,
                          child: const Text('Enregistrer'),
                        ),
                      ],
                    ),
                  ),
                ),


            ]
               ),
          );
        }

    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _captureImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _isImageLoaded = true;
      });
    }
  }

  Future<void> _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
    await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _isImageLoaded = true;
      });
    }
  }

  Future<void> _scanImage() async {

    if (_image == null) return;

    final navigator = Navigator.of(context);

    try {
      final inputImage = InputImage.fromFile(_image!);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
     /*
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            setState(() {
              scanText = scanText + '  ' + element.text;
            //  debugPrint(scanText);

            });
          }

          scanText = scanText + '\n';
        }
     //  break;
      }
   */
     // suppression sauts de lignes
      scanText = recognizedText.text.replaceAll(RegExp(r'\r'), '');
      scanText = recognizedText.text.replaceAll(RegExp(r'\n'), '');
      scanText = recognizedText.text.replaceAll(RegExp(r'\r\n'), '');

  //    scanText = recognizedText.text.replaceAll(RegExp(r'CRLF'), '<br>');
      // suppression des doubles espaces
      scanText = recognizedText.text.replaceAll(RegExp(' {2,}'), ' ');

      print('======================================================================');
      print('=================     SCANTEXT   page  1      ========================');
      print(scanText);
      print('=============================FIN SCANTEXT ============================');


      print('=======================================================================');
      print('========================     TEXTE RECONNU    =========================');
      print('=======================================================================');
      print(recognizedText.text);
      print('=======================================================================');

      print('=========================nombre de blocs===============================');
      print(recognizedText.blocks.length);
      print('=======================================================================');

      await navigator.push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
           //   ResultScreen(text: scanText),
          ResultScreen(text: recognizedText.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }


}
