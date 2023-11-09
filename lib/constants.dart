import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poly_geofence_service/models/lat_lng.dart';

const kblueColor = Color(0xFF00D9F6);
const kgreyColor = Color(0xFF6C7589);
const kbackgroundColor = Color(0xFF0E121E);

// couleurs
var color_theme = Colors.grey;
var color_background = Colors.white60;
var color_background2 = Colors.teal;
var color_background3 = Colors.yellow;
var color_shadow = Colors.grey;
var color_border = Colors.teal;
var color_icone = Colors.white;
var color_button = Colors.grey;
var color_texte1 = Colors.teal;
var color_texte2 = Colors.black;
var color_selectItem = Colors.white;
var color_UnselectItem = Colors.black;

var border_radius = 5.00;

final TextStyle_verylarge = GoogleFonts.poppins(
    color: Colors.teal, fontSize: 50, fontWeight: FontWeight.bold);

final TextStyle_large = GoogleFonts.poppins(
    color: Colors.teal, fontSize: 24, fontWeight: FontWeight.bold);

final TextStyle_large_grey = GoogleFonts.poppins(
    color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold);

final TextStyle_medium = GoogleFonts.poppins(
    color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold);

final TextStyle_small =
GoogleFonts.poppins(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.w600);

final TextStyle_small_red =
GoogleFonts.poppins(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold);

final TextStyle_smallwhite =
GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600);

final TextStyle_regular =
GoogleFonts.poppins(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.w600);

final TextStyle_regular2 =
GoogleFonts.poppins(color: Colors.teal, fontSize: 14, fontWeight: FontWeight.w600);

final TextStyle_regular_bold =
GoogleFonts.poppins(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.w600);

final TextStyle_verysmall =
GoogleFonts.poppins(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.w600);

final TextStyle_verysmall_white =
GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600);

final TextStyle_veryverysmall =
GoogleFonts.poppins(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.w600);

final TextStyle_button =
GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);

final TextStyle_regular_white =
GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);

final TextStyle_regular_green =
GoogleFonts.poppins(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w600);

final TextStyle_regular_grey =
GoogleFonts.poppins(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600);

final smallTextStyle =
GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600);

final largeTextStyle = GoogleFonts.poppins(
    color: Colors.teal, fontSize: 60, fontWeight: FontWeight.bold);

/*
List<LatLng> MyZoneResidentielle = const [
  LatLng(48.867504, 2.299248),
  LatLng(48.873383, 2.295423),
  LatLng(48.875076, 2.309177),
  LatLng(48.876483, 2.307869),
  LatLng(48.880376, 2.308952),
  LatLng(48.881295, 2.316480),
  LatLng(48.877898, 2.326919),
  LatLng(48.881295, 2.316480),
  LatLng(48.875537, 2.326559),
  LatLng(48.873731, 2.327058),
  LatLng(48.872732, 2.326608),
  LatLng(48.869601, 2.325870),
  LatLng(48.869500, 2.325149),
  LatLng(48.868992, 2.325321),
  LatLng(48.865094, 2.322432),
  LatLng(48.870565, 2.305298),
  LatLng(48.867504, 2.299248),
];
*/

// Map to help create the various shades of a material color.
Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

// Custom Colors for our app. In this case I'm going for a terminal look.
MaterialColor colorHackerHeading = MaterialColor(0xff13fa16, color);
MaterialColor colorHackerBorder = MaterialColor(0xff13690c, color);
MaterialColor colorHackerBackground = MaterialColor(0xff000000, color);


class AppConstants {
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoiYWxlamFuZHJvZW0iLCJhIjoiY2xuOXFhYXE2MDh4NjJpbGhiYm81eDZmZSJ9.5ZXXM4Rxx1ceSWulnq2sow';

  static const String mapBoxStyleId = 'clka2b8s303b901qj3qarh65f';
  //Paris
  //static const myLocation = LatLng(48.8955025, 2.368245);
  //Itaugua
  static const myLocation = LatLng(-25.388877, -57.359082);
}
