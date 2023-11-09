import 'dart:async';
import 'dart:io';
import 'package:diacritic/diacritic.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';
import '../../amendes/antai/antai_result.dart';
import '../../amendes/fps/fps_result.dart';
import '../constants.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

class AmendesScanner extends StatefulWidget {
  const AmendesScanner({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  AmendesScannerState createState() => AmendesScannerState();
}

class AmendesScannerState extends State<AmendesScanner> {
  bool _isPermissionGranted = false;
  late final Future<void> _future;
  late File? _image;
  bool _isImageLoaded = false;

  String _imagePath = "";
  String _imagePath1 = "";
  String _imagePath2 = "";
  String _imageName = "";
  String _imageName1 = "";
  String _imageName2 = "";
  String _imageCompleteName1 = "";
  String _imageCompleteName2 = "";
  String scanText = "";
  String reconText = "";
  String reconText1 = "";
  String reconText2 = "";
  String reconText3 = "";
  String reconText4 = "";
  String NewText = "";
  String Amende = "";
  String _textRecognized1 = "";
  String _textRecognized2 = "";
  String _textRecognized2Pages = "";
  String ElementBloc = "";

  int NbBloc = 0;

  String Element = "";
  String Ligne = "";

  List<String> ListElements = [];

  String ocrText = '';
  final picker = ImagePicker();

  // final TextRecognizer textRecognizer = TextRecognizer();

  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  var _cameraLensDirection = CameraLensDirection.back;

  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traitement Amendes ou FPS'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  height: (size.height / 2),
                  width: size.width,
                  decoration: BoxDecoration(
                    color: color_background,
                    borderRadius: BorderRadius.circular(20),
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
                            Text(
                              "Conseils prise de vue\n\n)",
                              style: TextStyle_regular,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Positionnez votre document\nsur un fond non blanc\n détectez les bords du document\puis prenez la photo\nSi elle vous convient cliquez sur le symbole #\n\ncontrolez la puis cliquez sur le symboe V en haut de votre écran pour valider\nNotre logiciel reconnaitra automatiquement s'il s'agit d'un FPS ou d'une amende et si'il s'agit d'une amande vous demandera de prendre une photo de la page  Notice de Paiement (fond orange)",
                              style: TextStyle_small,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 80,
                width: 300,
                decoration: BoxDecoration(
                    color: color_background2,
                    border: Border.all(
                      color: color_background,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextButton(
                  child: Text(
                    "Cliquez ici pour\nprendre votre document en photo",
                    style: TextStyle_verysmall_white,
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    // Generate filepath for saving

                    _imageName = (DateTime.now().millisecondsSinceEpoch / 1000)
                        .round()
                        .toString();

                    // take picture of first page and text recognize it

                    _imageCompleteName1 = join(
                        (await getApplicationSupportDirectory()).path,
                        _imageName + "_1.jpeg");
                    _imageName1 = (await getImageFromCamera(
                        imageCompleteName: _imageCompleteName1))!;

                    if (_imageName1 == null) {
                      /// todo
                      ///
                    } else {
                      _textRecognized1 = (await scanImage(
                          ImagePath: _imageCompleteName1.toString(),
                          ImagePage: 1))!;

                      // test if the recognized document is a 'FPS' or an 'AVIS DE CONTRAVENTION'
                      if (_textRecognized1!.indexOf("FPS", 0) > 0) {
                        // as it is a 'FPS' we need only the first document page and nothing else
                        Amende = 'FPS';
                        print(
                            '******************************************************************');
                        print(
                            '*****************************$Amende******************************');
                        print(
                            '******************************************************************');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => fps_Result(
                                    text: _textRecognized1.toString())));
                      } else {
                        // as it is a 'Contravention' so we have to take picture of the second page also
                        Amende = 'Contravention';
                        _imageCompleteName2 = join(
                            (await getApplicationSupportDirectory()).path,
                            _imageName + "_2.jpeg");
                        _imageName2 = (await getImageFromCamera(
                            imageCompleteName: _imageCompleteName2))!;
                        if (_imageName1 != null) {
                          _textRecognized2 = (await scanImage(
                              ImagePath: _imageCompleteName2.toString(),
                              ImagePage: 2))!;
                        } else {
                          /// todo
                        }

                        print(
                            '======================================================================================');
                        await File(_imageCompleteName1).exists()
                            ? print("le fichier $_imageCompleteName1 existe")
                            : print(
                                "le fichier $_imageCompleteName1 n'existe plus");
                        print(
                            '======================================================================================');
                        await File(_imageCompleteName2).exists()
                            ? print("le fichier $_imageCompleteName2 existe")
                            : print(
                                "le fichier $_imageCompleteName2 n'existe plus");
                        print(
                            '======================================================================================');
                        print(
                            '======================================================================================');
                        await File('/data/user/0/dev.flutter.mycar/files/1691548611.jpeg')
                                .exists()
                            ? print(
                                "le fichier /data/user/0/dev.flutter.mycar/files/1691548611.jpeg existe")
                            : print(
                                "le fichier /data/user/0/dev.flutter.mycar/files/1691548611.jpeg n'existe plus");
                        print(
                            '======================================================================================');

                        print(
                            '======================================================================================');
                        await File('/data/user/0/dev.flutter.mycar/files/1691418543_1.jpeg.jpeg')
                                .exists()
                            ? print(
                                "le fichier /data/user/0/dev.flutter.mycar/files/1691418543_1_1.jpeg existe")
                            : print(
                                "le fichier /data/user/0/dev.flutter.mycar/files/1691418543_1_1.jpeg n'existe plus");
                        print(
                            '======================================================================================');
                        await File('/data/user/0/dev.flutter.mycar/files/1691418543_2.jpeg.jpeg')
                                .exists()
                            ? print(
                                "le fichier /data/user/0/dev.flutter.mycar/files/1691418543_2.jpeg existe")
                            : print(
                                "le fichier /data/user/0/dev.flutter.mycar/files/1691418543_2.jpeg n'existe plus");
                        print(
                            '======================================================================================');
                        print(
                            '======================================================================================');
                        await File('/data/user/0/dev.flutter.mycar/files/1691348611.jpeg')
                                .exists()
                            ? print(
                                "le fichier /data/user/0/dev.flutter.mycar/files/1691348611.jpeg existe")
                            : print(
                                "le fichier /data/user/0/dev.flutter.mycar/files/1691348611.jpeg n'existe plus");
                        print(
                            '======================================================================================');

                        print(
                            '--------------------- _imagePath--------------------');
                        print(_imagePath);
                        print(
                            '--------------------- _imageCompleteName1--------------------');
                        print(_imageCompleteName1);
                        print(
                            '--------------------------------------------------------');
                        print(
                            '--------------------- _imageCompleteName2--------------------');
                        print(_imageCompleteName2);
                        print(
                            '--------------------------------------------------------');

                        _textRecognized2Pages = _textRecognized1 + _textRecognized2;


                        Navigator.push(context, MaterialPageRoute(builder: (context) => antai_Result(recognizedtext: _textRecognized2Pages.toString())));
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }





  Future<String?> getImageFromCamera(
      {required String imageCompleteName}) async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return ('');
    }


    try {
      //Make sure to await the call to detectEdge.
      bool success = await EdgeDetection.detectEdge(
        imageCompleteName,
        canUseGallery: true,
        androidScanTitle: 'Scanning',
        // use custom localizations for android
        androidCropTitle: 'Ajuster les limites de votre prise de vue',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );

      print(
          "**********************-----------1---------------------------------------");
      print("success scan? : $success");
      print(
          "**********************-----------2---------------------------------------");
      print("imagePath: $imageCompleteName");
      print(
          "**********************-----------3---------------------------------------");

      return (imageCompleteName);
    } catch (e) {
      print(e);
      return ('');
    }

  }

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

  Future<String?> scanImage(
      {required String ImagePath, required int ImagePage}) async {
    if (ImagePath == null) return ('0');

    //  final navigator = Navigator.of(context as BuildContext);

    try {

      reconText = "";
      reconText2 = "";

      var inputImage = await InputImage.fromFilePath(ImagePath);

    RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

     // final RecognizedText recognizedText = (await FlutterTesseractOcr.extractText(ImagePath)) as RecognizedText;

  print('////////////////////////////////// ImagePath ImagePage////////////////////////////////////////////');
      print(ImagePath);
      print(ImagePage);
      print(recognizedText.text);
      print('///////////////////////////////////String text = recognizedText.text;///////////////////////////////////////////');

      for (TextBlock block in recognizedText.blocks) {
        final Rect rect = block.boundingBox;
        // final List<Point<int>> cornerPoints = block.cornerPoints;
        final String text = block.text;
        final List<String> languages = block.recognizedLanguages;
        for (TextLine line in block.lines) {


          for (TextElement element in line.elements) {
            // print('**************');
            // print(element.text);
            // Same getters as TextBlock
          }
        }

        NbBloc++;

       ElementBloc = block.text;
        //  print('$NbBloc : $ElementBloc');

       ElementBloc = removeDiacritics(ElementBloc);

        //  print('$NbBloc : $ElementBloc');

       // ElementBloc = ElementBloc.replaceAll('n°', 'numero ');
       // ElementBloc = ElementBloc.replaceAll('km/h', 'km h ');
       // ElementBloc = ElementBloc.replaceAll(':', ' ');

        //  ListElements.add(ElementBloc);

        //print(ListElements[NbBloc]);

        reconText = reconText + " " + ElementBloc;

       // if (NbBloc > 130) {
       //   reconText3 = reconText3 + " " + ElementBloc;
       //   print('reconText3 : $reconText3');
       // }

        print('$NbBloc : $ElementBloc');
        //  print('texte = $reconText2');
      }


      /// BEGIN : correction most of errors text recognition

      NewText = reconText;

      print(
          '=========================NewText avant corrections===============================');
      print(NewText);
      print(
          '=======================================================================');

      final result = reconText.replaceAll(RegExp("[^A-Za-z0-9 '/]"), " ");

           print(
          '=========================result2===============================');
      print(result);
      print(
          '=======================================================================');

      NewText = result;

      // suppression sauts de lignes
      // NewText = NewText.replaceAll(RegExp(r'\r'), '');
      // NewText = NewText.replaceAll(RegExp(r'\n'), '');
      // NewText = NewText.replaceAll(RegExp(r'\r\n'), '');

      //    NewText = NewText.replaceAll(RegExp(r'CRLF'), '<br>');

      NewText = NewText.replaceAll('FR FR ', 'FRFR ');
      NewText = NewText.replaceAll('FRER ', 'FRFR ');

      NewText = NewText.replaceAll('lamende', 'l\'amende ');
      NewText = NewText.replaceAll('anende', 'anende ');
      NewText = NewText.replaceAll('l\'a mende', 'l\'amende ');
      NewText = NewText.replaceAll('de \'amende', 'de l\'amende ');
      NewText = NewText.replaceAll('de l\'emende', 'de l\'amende ');

      NewText = NewText.replaceAll('corespondant', 'correspondant ');

      NewText = NewText.replaceAll('contes tation', 'contestation ');
      NewText = NewText.replaceAll('contesta tion', 'contestation ');
      NewText = NewText.replaceAll('contestalion', 'contestation ');

      NewText = NewText.replaceAll('Commise', 'commise ');
      NewText = NewText.replaceAll('COmmise', 'commise ');
      NewText = NewText.replaceAll('cormmise', 'commise ');
      NewText = NewText.replaceAll('Commise e', 'commise le ');
      NewText = NewText.replaceAll('commlse le', 'commise le ');

      NewText = NewText.replaceAll('Commence', 'commence ');
      NewText = NewText.replaceAll('COmmence', 'commence ');
      NewText = NewText.replaceAll('commence le:', 'commence le ');

      NewText = NewText.replaceAll('délaupplélLsmentaice', 'délai supplémentaice ');
      NewText = NewText.replaceAll('supplementaie', 'supplémentaire ');
      NewText = NewText.replaceAll('supplómentaire', 'supplémentaire ');

      NewText = NewText.replaceAll('entrane', 'entraine ');
      NewText = NewText.replaceAll('erntraine', 'entraine ');
      NewText = NewText.replaceAll('entra îne', 'entraîne ');

      NewText = NewText.replaceAll('correspondanta', 'correspondant à ');

      NewText = NewText.replaceAll('Qu ', 'ou ');

      NewText = NewText.replaceAll('do ', 'de ');
      NewText = NewText.replaceAll('do ', 'de ');

      NewText = NewText.replaceAll('cotte ', 'cette ');

      NewText = NewText.replaceAll('forfaltaice', 'forfaitaire ');
      NewText = NewText.replaceAll('forfaltaire', 'forfaitaire ');
      NewText = NewText.replaceAll('forfaitaire', 'forfaitaire ');
      NewText = NewText.replaceAll('forfaitaire:', 'forfaitaire ');
      NewText = NewText.replaceAll('fortaitaire:', 'forfaitaire ');

      NewText = NewText.replaceAll('à infraction', 'à l\'infraction ');
      NewText = NewText.replaceAll('l\'infracion', 'l\'infraction ');
      NewText = NewText.replaceAll('linfraction', 'l\'infraction ');
      NewText = NewText.replaceAll('Tinfraction', 'l\'infraction ');
      NewText = NewText.replaceAll('Iinfraction', 'l\'infraction ');
      NewText = NewText.replaceAll('rinfraction', 'infraction ');
      NewText = NewText.replaceAll('à \'infraction', 'à l\'infraction ');

      NewText = NewText.replaceAll('reconnaíssance', 'reconnaissance ');

      NewText = NewText.replaceAll('retrat', 'retrait ');

      NewText = NewText.replaceAll('peyez', 'payez ');

      NewText = NewText.replaceAll('pes ', 'pas ');

      NewText = NewText.replaceAll('dennant', 'donnant ');

      NewText = NewText.replaceAll('droità', 'droit à ');

      NewText = NewText.replaceAll('undélai', 'un délai ');
      NewText = NewText.replaceAll('délal', 'délai ');

      NewText = NewText.replaceAll('DEPAIEMENT', ' DE PAIEMENT');

      NewText = NewText.replaceAll('paie ment', 'paiement ');
      NewText = NewText.replaceAll('pa ie ment', 'paiement ');
      NewText = NewText.replaceAll('palement', 'paiement ');
      NewText = NewText.replaceAll('paement', 'paiement ');
      NewText = NewText.replaceAll('pajement', 'paiement ');
      NewText = NewText.replaceAll('paioment', 'paiement ');
      NewText = NewText.replaceAll('paierment', 'paiement ');

      NewText = NewText.replaceAll(' rėglement', ' règlement ');

      NewText = NewText.replaceAll('point s', 'points');

      NewText = NewText.replaceAll('raplde ', 'rapide ');

      NewText = NewText.replaceAll('sâr ', 'sur ');
      NewText = NewText.replaceAll('sür ', 'sur ');
      NewText = NewText.replaceAll('sir ', 'sur ');
      NewText = NewText.replaceAll('süũr ', 'sur ');

      NewText = NewText.replaceAll('å ', 'à ');
      NewText = NewText.replaceAll(' d ', ' à ');

      NewText = NewText.replaceAll('lle ', 'le ');

      NewText = NewText.replaceAll('pOur ', 'pour ');
      NewText = NewText.replaceAll('pOUr ', 'pour ');
      NewText = NewText.replaceAll('POUr ', 'Pour ');

      NewText = NewText.replaceAll('benèficier', 'bénéficier ');
      NewText = NewText.replaceAll('bénéficler ', 'bénéficier ');
      NewText = NewText.replaceAll('bénéicier', ' un bénéficier ');
      NewText = NewText.replaceAll('bene ficier', ' un bénéficier ');


      NewText = NewText.replaceAll('tarit', 'tarif ');
      NewText = NewText.replaceAll('larif ', 'tarif ');
      NewText = NewText.replaceAll('tarifminore', 'tarif minore');

      NewText = NewText.replaceAll('mninore', 'minoré ');
      NewText = NewText.replaceAll('minorė', 'minoré ');
      NewText = NewText.replaceAll('mingoré', 'minoré ');
      NewText = NewText.replaceAll('minaé', 'minoré ');
      NewText = NewText.replaceAll('minoré:', 'minoré ');

      NewText = NewText.replaceAll('joursS', 'jours ');
      NewText = NewText.replaceAll('lours', 'jours ');

      NewText = NewText.replaceAll('carfe', 'carte ');
      NewText = NewText.replaceAll('carto', 'carte ');

      NewText = NewText.replaceAll('bancairo', 'bancaire ');

      NewText = NewText.replaceAll('le:', 'le : ');
      NewText = NewText.replaceAll('lle ', 'le ');

      NewText = NewText.replaceAll('smarphone', 'smartphone ');

      NewText = NewText.replaceAll('CONDUC TEUR', 'CONDUCTEUR ');

      NewText = NewText.replaceAll('dviter', 'éviter ');

      NewText = NewText.replaceAll('e retrait de', 'le retrait de ');

      NewText = NewText.replaceAll('CIe ', 'clé ');
      NewText = NewText.replaceAll('Cle ', 'clé ');

      NewText = NewText.replaceAll('contesta tion', 'contestation ');

      NewText = NewText.replaceAll('règlemernt ', 'réglement ');

      // NewText = NewText.replaceAll('LAberté ', 'Liberté');
      // NewText = NewText.replaceAll('Kgaltt', 'Egalité');
      // NewText = NewText.replaceAll('Praternltf', 'Fraternité');

      NewText = NewText.replaceAll('fortaitaire: ', 'forfaitaire ');

      // suppression des ':'
      NewText = NewText.replaceAll(':', ' ');

      NewText = NewText.replaceAll('|', '');

      // NewText = NewText.replaceAll('/', '');

      // suppression des doubles espaces
      NewText = NewText.replaceAll(RegExp(' {2,}'), ' ');
      NewText = NewText.replaceAll(RegExp(' {3,}'), ' ');

      // suppression sauts de lignes
      //  NewText = NewText.replaceAll(RegExp(r'\r'), '');
      //  NewText = NewText.replaceAll(RegExp(r'\n'), '');
      //  NewText = NewText.replaceAll(RegExp(r'\r\n'), '');

      //  NewText = NewText.replaceAll('\r', ' ');
      //  NewText = NewText.replaceAll('\n', ' ');
      //  NewText = NewText.replaceAll('\r\n', ' ');

      // NewText = NewText.replaceAll(RegExp(r'CRLF'), '');

      // NewText = NewText.replaceAll('BR /', ' ');

      /// END : correction most of errors text recognition

      print(
          '=========================NewText après corrections===============================');
      print(ImagePath);
      print(ImagePage);
      print(NewText);
      print('--------------------------------------------------------');

      return (NewText);
    } catch (e) {
      // ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      //   const SnackBar(
      //     content: Text('An error occurred when scanning text'),
      //   ),
      // );
      return ('');
    }
  }
}

extension StringExtensions on String {
  String replaceAllDiacritics() {
    return replaceAllMapped(
      RegExp('[À-ž]'),
      (m) => diacriticsMapping[m.group(0)] ?? '',
    );
  }

  // put here your mapping, this cover chars corresponding to regex [À-ž]
  static const diacriticsMapping = {
    //[À-ÿ]
    '°': ' ',
    'À': 'A',
    'Á': 'A',
    'Â': 'A',
    'Ã': 'A',
    'Ä': 'A',
    'Å': 'A',
    'Æ': 'AE',
    'Ç': 'C',
    'È': 'E',
    'É': 'E',
    'Ê': 'E',
    'Ë': 'E',
    'Ì': 'I',
    'Í': 'I',
    'Î': 'I',
    'Ï': 'I',
    'Ð': 'D',
    'Ñ': 'N',
    'Ò': 'O',
    'Ó': 'O',
    'Ô': 'O',
    'Õ': 'O',
    'Ö': 'O',
    '×': 'x', //math multiplication
    'Ø': 'O',
    'Ù': 'U',
    'Ú': 'U',
    'Û': 'U',
    'Ü': 'U',
    'Ý': 'Y',
    'Þ': 'TH',
    'ß': 'SS',
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ã': 'a',
    'ä': 'a',
    'å': 'a',
    'æ': 'ae',
    'ç': 'c',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    'ì': 'i',
    'í': 'i',
    'î': 'i',
    'ï': 'i',
    'ð': 'd',
    'ñ': 'n',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ö': 'o',
    '÷': ' ', //math division
    'ø': 'o',
    'ù': 'u',
    'ú': 'u',
    'û': 'u',
    'ü': 'u',
    'ý': 'y',
    'þ': 'th',
    'ÿ': 'y',
    //[Ā-ž] EuropeanLatin
    'Ā': 'A',
    'ā': 'a',
    'Ă': 'A',
    'ă': 'a',
    'Ą': 'A',
    'ą': 'a',
    'Ć': 'C',
    'ć': 'c',
    'Ĉ': 'C',
    'ĉ': 'c',
    'Ċ': 'C',
    'ċ': 'c',
    'Č': 'C',
    'č': 'c',
    'Ď': 'D',
    'ď': 'd',
    'Đ': 'D',
    'đ': 'd',
    'Ē': 'E',
    'ē': 'e',
    'Ĕ': 'E',
    'ĕ': 'e',
    'Ė': 'E',
    'ė': 'e',
    'Ę': 'E',
    'ę': 'e',
    'Ě': 'E',
    'ě': 'e',
    'Ĝ': 'G',
    'ĝ': 'g',
    'Ğ': 'G',
    'ğ': 'g',
    'Ġ': 'G',
    'ġ': 'g',
    'Ģ': 'G',
    'ģ': 'g',
    'Ĥ': 'H',
    'ĥ': 'h',
    'Ħ': 'H',
    'ħ': 'h',
    'Ĩ': 'I',
    'ĩ': 'i',
    'Ī': 'I',
    'ī': 'i',
    'Ĭ': 'I',
    'ĭ': 'i',
    'Į': 'I',
    'į': 'i',
    'İ': 'I',
    'ı': 'i',
    'Ĳ': 'IJ',
    'ĳ': 'ij',
    'Ĵ': 'J',
    'ĵ': 'j',
    'Ķ': 'K',
    'ķ': 'k',
    'ĸ': 'k',
    'Ĺ': 'L',
    'ĺ': 'l',
    'Ļ': 'L',
    'ļ': 'l',
    'Ľ': 'L',
    'ľ': 'l',
    'Ŀ': 'L',
    'ŀ': 'l',
    'Ł': 'L',
    'ł': 'l',
    'Ń': 'N',
    'ń': 'n',
    'Ņ': 'N',
    'ņ': 'n',
    'Ň': 'N',
    'ň': 'n',
    'ŉ': 'n',
    'Ŋ': 'N',
    'ŋ': 'n',
    'Ō': 'O',
    'ō': 'o',
    'Ŏ': 'O',
    'ŏ': 'o',
    'Ő': 'O',
    'ő': 'o',
    'Œ': 'OE',
    'œ': 'oe',
    'Ŕ': 'R',
    'ŕ': 'r',
    'Ŗ': 'R',
    'ŗ': 'r',
    'Ř': 'R',
    'ř': 'r',
    'Ś': 'S',
    'ś': 's',
    'Ŝ': 'S',
    'ŝ': 's',
    'Ş': 'S',
    'ş': 's',
    'Š': 'S',
    'š': 's',
    'Ţ': 'T',
    'ţ': 't',
    'Ť': 'T',
    'ť': 't',
    'Ŧ': 'T',
    'ŧ': 't',
    'Ũ': 'U',
    'ũ': 'u',
    'Ū': 'U',
    'ū': 'u',
    'Ŭ': 'U',
    'ŭ': 'u',
    'Ů': 'U',
    'ů': 'u',
    'Ű': 'U',
    'ű': 'u',
    'Ų': 'U',
    'ų': 'u',
    'Ŵ': 'W',
    'ŵ': 'w',
    'Ŷ': 'Y',
    'ŷ': 'y',
    'Ÿ': 'Y',
    'Ź': 'Z',
    'ź': 'z',
    'Ż': 'Z',
    'ż': 'z',
    'Ž': 'Z',
    'ž': 'z',
  };
}
