class paris_areas {
  String? datasetid;
  String? recordid;
  Fields? fields;
  Geometry? geometry;
  String? recordTimestamp;

  paris_areas({this.datasetid, this.recordid, this.fields, this.geometry, this.recordTimestamp});

  paris_areas.fromJson(Map<String, dynamic> json) {
    datasetid = json['datasetid'];
    recordid = json['recordid'];
    fields = json['fields'] != null ? new Fields.fromJson(json['fields']) : null;
    geometry = json['geometry'] != null ? new Geometry.fromJson(json['geometry']) : null;
    recordTimestamp = json['record_timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datasetid'] = this.datasetid;
    data['recordid'] = this.recordid;
    if (this.fields != null) {
      data['fields'] = this.fields!.toJson();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['record_timestamp'] = this.recordTimestamp;
    return data;
  }
}

class Fields {
  List<double>? geoPoint2d;
  String? nom;
  GeoShape? geoShape;

  Fields({this.geoPoint2d, this.nom, this.geoShape});

  Fields.fromJson(Map<String, dynamic> json) {
    geoPoint2d = json['geo_point_2d'].cast<double>();
    nom = json['nom'];
    geoShape = json['geo_shape'] != null ? new GeoShape.fromJson(json['geo_shape']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geo_point_2d'] = this.geoPoint2d;
    data['nom'] = this.nom;
    if (this.geoShape != null) {
      data['geo_shape'] = this.geoShape!.toJson();
    }
    return data;
  }
}

class GeoShape {
  List<List>? coordinates;
  String? type;

  GeoShape({this.coordinates, this.type});

  GeoShape.fromJson(Map<String, dynamic> json) {
    if (json['coordinates'] != null) {
      coordinates = <List>[];
   //   json['coordinates'].forEach((v) { coordinates!.add(new List.fromJson(v)); });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coordinates != null) {
  //    data['coordinates'] = this.coordinates!.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    return data;
  }
}

class Coordinates {


 // Coordinates({});

Coordinates.fromJson(Map<String, dynamic> json) {
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
return data;
}
}

class Geometry {
String? type;
List<double>? coordinates;

Geometry({this.type, this.coordinates});

Geometry.fromJson(Map<String, dynamic> json) {
type = json['type'];
coordinates = json['coordinates'].cast<double>();
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['type'] = this.type;
data['coordinates'] = this.coordinates;
return data;
}
}
