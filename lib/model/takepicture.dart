import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mycar/databases/DatabaseClient.dart';
import 'package:mycar/databases/documents.dart';
import 'package:mycar/drawerscreens/mespapiers.dart';
import 'dart:async';
import '../text_FR.dart';
import '../constants.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';


class Takepicture extends StatefulWidget {
  int IdKey;
  String? IdNom;
  Takepicture({required this.IdKey, this.IdNom});

 // const Takepicture({Key? key}) : super(key: key);



// Takepicture({required this.Documents});


  @override
  State<Takepicture> createState() => _TakepictureState();
}

class _TakepictureState extends State<Takepicture> {
  List<String> _pictures = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }


  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: color_background2,
          title: const Text('Scanner Documents'),
        ),
        body: SingleChildScrollView(
            child: Container(
                height: size.height,
                width: size.width,
                color: Colors.white,
                child: Card(

                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          height: (size.height / 3) ,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: color_background,
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
                                child: Text("Conseils prise de vue",
                                    style: TextStyle_regular),
                              ),
                              Container(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(" Positionnez votre document sur un fond sombre",
                                          style: TextStyle_regular),
                                    ]),
                              ),


                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: onPressed,
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                          elevation: 10,
                                          shadowColor: Colors.white,
                                        ),
                                        child:
                                        Text("Cliquez ici pour prendre une photo")),
                                  ],
                                ),
                              ),
                            ],
                          )),


                    ],
                  ),

                  elevation: 7.5,
                  //color: Colors.teal,
                  margin: EdgeInsets.all(10),
                )
            )


        ),
    );
  }

  void onPressed() async {
    List<String> pictures;
    try {
      // utilisation de la bibliotheque CunningDocumentScanner
      // pour prendre en photo puis recadrer automatiquement l'image
      // https://github.com/jachzen/cunning_document_scanner

      pictures = await CunningDocumentScanner.getPictures() ?? [];


      if (!mounted) {
        print('aucune photo');
        return;
      }


      print ('***********************************');
      print ("photo prise");
      print (pictures);
      print ('widget.IdKey =');
      print (widget.IdKey);
      print ('***********************************');

        setState(() {

            _pictures = pictures;

              Map<String, dynamic> map = {'documents': widget.IdKey};
              map["id"]  = widget.IdKey;
              map["nom"] = widget.IdNom;
              for (var picture in _pictures) map["image"] = picture;

              Documents documents = Documents.fromMap(map);

              DatabaseClient()
                  .DocumentsUpdateImage(widget.IdKey,map["image"])
                  .then((success) => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>mespapiers())));
        });



    } catch (exception) {
      // Handle exception here
    }
  }
}

Future<Null> _selectDate(BuildContext context) async {

}