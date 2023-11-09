import 'package:animated_loading_indicators/animated_loading_indicators.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api_energies/api_FrenchDataEnergies_response.dart';
import '../api_energies/api_FrenchDataEnergies_call.dart';
import '../api_energies/api_FrenchBornes_call.dart';

import '../services/location_service.dart';
import '../constants.dart';
import 'api_energies/api_FrenchBornes_Response.dart';


class screen4_carburant extends StatefulWidget {
  const screen4_carburant({Key? key, this.androidDrawer, this.energy}) : super(key: key);

  final Widget? androidDrawer;
  final String? energy;

  @override
  State<screen4_carburant> createState() => screen4_carburantState();
}

class screen4_carburantState extends State<screen4_carburant> {

  bool orderByPrice = true;
  bool ascendingOrder = true; // Track the sorting order
  bool DistascendingOrder = true; // Track the sorting order

  int nbPlaces = 0; // number of places found using French database api and to show in the listview

// variables to change the color of the icons in the top bar
  int selectedIndex = 1;
  bool colorOne = true, colorTwo = false, colorThree = false;
//

  GeoPosition? positionToCall;

  APIResponse? apiResponse;

  late List<Bornes> listBornes;

  bool isLoading = false;
  bool isLoaded = false;

  @override
  void initState() {
    String? _energy = widget.energy;
    if (_energy == "electricy") {
      print ("--------------------------ernergy $_energy");
      getListBornes();
    } else {
      print ("--------------------------ernergy $_energy");
      getListCarburants();
    }
    super.initState();
  }


  //CallApi to get Energies Prices
  Future<Object?> getListCarburants() async {

    setState(() {
      isLoading = true;
    });

    apiResponse = (await ApiFranceCarburants().FrenchDataEnergiesApi());

    print('---------------------------------');
    print (apiResponse?.nhits);
    print('---------------------------------');
    print (apiResponse?.records.length);
    print('---------------------------------');

    if (apiResponse!.records.isNotEmpty) {
      setState(() {
        nbPlaces = apiResponse!.records.length!;
        //  nbPlaces = apiResponse!.nhits!;
        isLoaded = true;
      });
      return nbPlaces;
    } else {
      setState(() {
        nbPlaces = 0;
        isLoaded = false;
      });
      return null;
    }
  }



  Future<Object?> getListBornes() async {
    setState(() {
      isLoading = true;
    });
    print('--------------apiResponse REQUEST----------------');
    ApiFranceBornes().FrenchBornesRequest();

    print('--------------apiResponse?.nhits-------------------');
    print (listBornes?[1].nom_station);
    print('---------------apiResponse?.records.length------------------');
    print (listBornes?.length);
    print('---------------------------------');

    /// Print to test
    for (var e in listBornes) {
      print('Distance: ${e.distance}, Nom: ${e.nom_station}');
    }


    if (listBornes!.length > 0) {
      setState(() {
        nbPlaces = listBornes!.length!;
        //      nbPlaces = apiResponse!.nhits!;
        isLoaded = true;
      });
      return listBornes;
    } else {
      setState(() {
        nbPlaces = 0;
        isLoaded = true;
      });
      return listBornes;
    }
  }

  @override
  Widget build(BuildContext context) {

    print("nbPlaces : $nbPlaces");

//    print(apiResponse?.records.length);



    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: (isLoaded == false)
                  ? Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Nous interrogeons la base',
                          style: TextStyle_large),
                      UpDownLoader(
                        size: 12,
                        firstColor: Colors.teal,
                        secondColor: Colors.black,
                        //  duration: Duration(milliseconds: 600),
                      ),
                    ],
                  ))
                  : (isLoaded == true && nbPlaces > 0)
                  ? Column(
                children: [
                  Container(
                    color: color_background2,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        /*
                                Text(

                                  '      Classement par proximité ',
                                  style: TextStyle_regular_white,
                                ),
                                */
                        IconButton(
                          icon: Icon(
                            Icons.price_change,
                            color: selectedIndex == 1
                                ? Colors.yellowAccent
                                : Colors.white,
                            size: 36,
                          ),
                          highlightColor: Colors.greenAccent,
                          onPressed: () {
                            selectedIndex = 1;
                            toggleSortOrder();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.maps_ugc_outlined,
                            color: selectedIndex == 2
                                ? Colors.yellowAccent
                                : Colors.white,
                            size: 36,
                          ),
                          highlightColor: Colors.greenAccent,
                          onPressed: () {
                            selectedIndex = 2;
                            toggleDIstSortOrder();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: nbPlaces,
                      itemBuilder: (BuildContext context, int index) => Card(
                        shadowColor:Colors.tealAccent.shade100,
                        color: Colors.grey.shade300,
                        child: ListTile(
                          minLeadingWidth: 0,
                          leading: CircleAvatar(
                            radius: 12.0,
                            backgroundColor: color_background2,
                            child: Text(
                              "", // titles[index].substring(0, 1),
                              style: const TextStyle(
                                  color: Colors.white),
                            ),
                          ),
                          title: Text(
                            (apiResponse?.records[index].fields
                                .adresse !=
                                null)
                                ? apiResponse!
                                .records[index].fields.adresse
                                .toString()
                                : "",
                            style: TextStyle_regular2,
                          ),
                          subtitle: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Distance : " +
                                    DistanceFormat(apiResponse!
                                        .records[index].fields.dist
                                        .toString()) +
                                    " mètres",
                                style: TextStyle_regular2,
                              ),
                              Text(
                                "SP98 : " +
                                    PriceFormat(apiResponse!
                                        .records[index]
                                        .fields
                                        .sp98_prix
                                        .toString()) +
                                    " - e10 : " +
                                    PriceFormat(apiResponse!
                                        .records[index]
                                        .fields
                                        .e10_prix
                                        .toString()) +
                                    " - Diesel : " +
                                    PriceFormat(apiResponse!
                                        .records[index]
                                        .fields
                                        .gazole_prix
                                        .toString()),
                                style: TextStyle_regular2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Center(
                child: Text('No data found'),
              )),
        ],
      ),
    );
  }

  String PriceFormat(String _price) {
    if (_price == "--") return "";
    var formatPrice;
    var fPrice = NumberFormat("#.##", "fr_FR");
    (_price == 'null')
        ? formatPrice = 'N.C.'
        : formatPrice = fPrice.format(double.tryParse(_price.toString()));
    return formatPrice;
  }

  String DistanceFormat(String _distance) {
    var formatDistance;
    var fDistance = NumberFormat("##,###", "fr_FR");
    (_distance == 'null')
        ? formatDistance = 'N.C.'
        : formatDistance =
        fDistance.format(double.tryParse(_distance.toString()));
    return formatDistance;
  }

  void sortBySp98PrixAscending() {
    setState(() {
      apiResponse?.records.sort((a, b) =>
          (a.fields.sp98_prix ?? '').compareTo(b.fields.sp98_prix ?? ''));
    });
  }

  void sortBySp98PrixDescending() {
    setState(() {
      apiResponse?.records.sort((a, b) =>
          (b.fields.sp98_prix ?? '').compareTo(a.fields.sp98_prix ?? ''));
    });
  }

  void sortByDistAscending() {
    setState(() {
      apiResponse?.records
          .sort((a, b) => (a.fields.dist ?? '').compareTo(b.fields.dist ?? ''));
    });
  }

  void sortByDistDescending() {
    setState(() {
      apiResponse?.records
          .sort((a, b) => (b.fields.dist ?? '').compareTo(a.fields.dist ?? ''));
    });
  }

  void toggleSortOrder() {
    setState(() {
      ascendingOrder = !ascendingOrder;
      if (ascendingOrder) {
        sortBySp98PrixAscending();
      } else {
        sortBySp98PrixDescending();
      }
    });
  }

  void toggleDIstSortOrder() {
    setState(() {
      DistascendingOrder = !DistascendingOrder;
      if (ascendingOrder) {
        sortByDistAscending();
      } else {
        sortByDistDescending();
      }
    });
  }

  showBottomNav() {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        context: context,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Satoshi',
                          fontSize: 21),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.black,
                          size: 16,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }
}

