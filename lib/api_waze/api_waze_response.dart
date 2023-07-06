class ApiWaze_response {
  String? status;
  String? requestId;
  Data? data;

  ApiWaze_response({this.status, this.requestId, this.data});

  ApiWaze_response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    requestId = json['request_id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['request_id'] = this.requestId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Alerts>? alerts;
//  List<Jams>? jams;

  Data({
    this.alerts
 // this.jams
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['alerts'] != null) {
      alerts = <Alerts>[];
      json['alerts'].forEach((v) {
        alerts!.add(new Alerts.fromJson(v));
      });
    }
    /*
    if (json['jams'] != null) {
      jams = <Jams>[];
      json['jams'].forEach((v) {
        jams!.add(new Jams.fromJson(v));
      });
    }
    */
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.alerts != null) {
      data['alerts'] = this.alerts!.map((v) => v.toJson()).toList();
    }
    /*
    if (this.jams != null) {
      data['jams'] = this.jams!.map((v) => v.toJson()).toList();
    }
    */
    return data;
  }
}

class Alerts {
  String? alertId;
  String? type;
  String? subtype;
  String? reportedBy;
  String? description;
  Null? image;
  String? publishDatetimeUtc;
  String? country;
  String? city;
  String? street;
  double? latitude;
  double? longitude;
  int? numThumbsUp;
  int? alertReliability;
  int? alertConfidence;
 // Null? nearBy;
  List<Comments>? comments;
  int? numComments;

  Alerts(
      {this.alertId,
        this.type,
        this.subtype,
        this.reportedBy,
        this.description,
        this.image,
        this.publishDatetimeUtc,
        this.country,
        this.city,
        this.street,
        this.latitude,
        this.longitude,
        this.numThumbsUp,
        this.alertReliability,
        this.alertConfidence,
      //this.nearBy,
        this.comments,
        this.numComments});

  Alerts.fromJson(Map<String, dynamic> json) {
    alertId = json['alert_id'];
    type = json['type'];
    subtype = json['subtype'];
    reportedBy = json['reported_by'];
    description = json['description'];
    image = json['image'];
    publishDatetimeUtc = json['publish_datetime_utc'];
    country = json['country'];
    city = json['city'];
    street = json['street'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    numThumbsUp = json['num_thumbs_up'];
    alertReliability = json['alert_reliability'];
    alertConfidence = json['alert_confidence'];
   // nearBy = json['near_by'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    numComments = json['num_comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alert_id'] = this.alertId;
    data['type'] = this.type;
    data['subtype'] = this.subtype;
    data['reported_by'] = this.reportedBy;
    data['description'] = this.description;
    data['image'] = this.image;
    data['publish_datetime_utc'] = this.publishDatetimeUtc;
    data['country'] = this.country;
    data['city'] = this.city;
    data['street'] = this.street;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['num_thumbs_up'] = this.numThumbsUp;
    data['alert_reliability'] = this.alertReliability;
    data['alert_confidence'] = this.alertConfidence;
  //  data['near_by'] = this.nearBy;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['num_comments'] = this.numComments;
    return data;
  }
}

class Comments {
  String? text;
  String? commentBy;
  int? timestamp;
  String? datetimeUtc;

  Comments({this.text, this.commentBy, this.timestamp, this.datetimeUtc});

  Comments.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    commentBy = json['comment_by'];
    timestamp = json['timestamp'];
    datetimeUtc = json['datetime_utc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['comment_by'] = this.commentBy;
    data['timestamp'] = this.timestamp;
    data['datetime_utc'] = this.datetimeUtc;
    return data;
  }
}

/*
class Jams {
  String? jamId;
  String? type;
  int? level;
  int? severity;
  List<LineCoordinates>? lineCoordinates;
  String? startLocation;
  String? endLocation;
  double? speedKmh;
  int? lengthMeters;
  int? delaySeconds;
  String? blockAlertId;
  String? blockAlertType;
  String? blockAlertDescription;
  String? blockAlertUpdateDatetimeUtc;
  String? blockStartDatetimeUtc;
  String? publishDatetimeUtc;
  String? updateDatetimeUtc;
  String? country;
  String? city;
  String? street;

  Jams(
      {this.jamId,
        this.type,
        this.level,
        this.severity,
        this.lineCoordinates,
        this.startLocation,
        this.endLocation,
        this.speedKmh,
        this.lengthMeters,
        this.delaySeconds,
        this.blockAlertId,
        this.blockAlertType,
        this.blockAlertDescription,
        this.blockAlertUpdateDatetimeUtc,
        this.blockStartDatetimeUtc,
        this.publishDatetimeUtc,
        this.updateDatetimeUtc,
        this.country,
        this.city,
        this.street});

  Jams.fromJson(Map<String, dynamic> json) {
    jamId = json['jam_id'];
    type = json['type'];
    level = json['level'];
    severity = json['severity'];
    if (json['line_coordinates'] != null) {
      lineCoordinates = <LineCoordinates>[];
      json['line_coordinates'].forEach((v) {
        lineCoordinates!.add(new LineCoordinates.fromJson(v));
      });
    }
    startLocation = json['start_location'];
    endLocation = json['end_location'];
    speedKmh = json['speed_kmh'];
    lengthMeters = json['length_meters'];
    delaySeconds = json['delay_seconds'];
    blockAlertId = json['block_alert_id'];
    blockAlertType = json['block_alert_type'];
    blockAlertDescription = json['block_alert_description'];
    blockAlertUpdateDatetimeUtc = json['block_alert_update_datetime_utc'];
    blockStartDatetimeUtc = json['block_start_datetime_utc'];
    publishDatetimeUtc = json['publish_datetime_utc'];
    updateDatetimeUtc = json['update_datetime_utc'];
    country = json['country'];
    city = json['city'];
    street = json['street'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jam_id'] = this.jamId;
    data['type'] = this.type;
    data['level'] = this.level;
    data['severity'] = this.severity;
    if (this.lineCoordinates != null) {
      data['line_coordinates'] =
          this.lineCoordinates!.map((v) => v.toJson()).toList();
    }
    data['start_location'] = this.startLocation;
    data['end_location'] = this.endLocation;
    data['speed_kmh'] = this.speedKmh;
    data['length_meters'] = this.lengthMeters;
    data['delay_seconds'] = this.delaySeconds;
    data['block_alert_id'] = this.blockAlertId;
    data['block_alert_type'] = this.blockAlertType;
    data['block_alert_description'] = this.blockAlertDescription;
    data['block_alert_update_datetime_utc'] = this.blockAlertUpdateDatetimeUtc;
    data['block_start_datetime_utc'] = this.blockStartDatetimeUtc;
    data['publish_datetime_utc'] = this.publishDatetimeUtc;
    data['update_datetime_utc'] = this.updateDatetimeUtc;
    data['country'] = this.country;
    data['city'] = this.city;
    data['street'] = this.street;
    return data;
  }
}


class LineCoordinates {
  double? lat;
  double? lon;

  LineCoordinates({this.lat, this.lon});

  LineCoordinates.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}

*/