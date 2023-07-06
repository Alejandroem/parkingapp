

class APIResponseWaze {
  final String? status;
  final String? request_id;
  final List<ForeCast>? data;

  const APIResponseWaze({
  required this.status,
  required this.request_id,
  required this.data,
  });

  factory APIResponseWaze.fromJson(Map<String, dynamic> map) {
    return APIResponseWaze (
        status: map["status"] as String?,
        request_id: map["request_id"] as String?,
        data: DataConverter().listMappable(map["data"]).map((e) => ForeCast.fromJson(e)).toList(),
    );
  }

}

  class ForeCast {
    final String? alert_id;
/*
    final String? type;
    final String? subtype;
    final String? reported_by;
    final String? description;
    final String? image;
    final String? publish_datetime_utc;
    final String? country;
    final String? city;
    final String? street;
    final double? latitude;
    final double? longitude;
    final int? num_thumbs_up;
    final int? alert_reliability;
    final int? alert_confidence;
    final String? near_by;
    final List? comments;
    final int? num_comments;
 */

const ForeCast({
  required this.alert_id,
 /*
  required this.type,
  required this.subtype,
  required this.reported_by,
  required this.description,
  required this.image,
  required this.publish_datetime_utc,
  required this.country,
  required this.city,
  required this.street,
  required this.latitude,
  required this.longitude,
  required this.num_thumbs_up,
  required this.alert_reliability,
  required this.alert_confidence,
  required this.near_by,
  required this.comments,
  required this.num_comments,

  */
});

factory ForeCast.fromJson(Map<String, dynamic> map) {
  return ForeCast (
    alert_id: map["alert_id"] as String?,
  /*
    type: map["type"] as String?,
    subtype: map["subtype"] as String?,
    reported_by: map["reported_byString"] as String?,
    description: map["descriptionString"] as String?,
    image: map["imageString"] as String?,
    publish_datetime_utc: map["publish_datetime_utcString"] as String?,
    country: map["countryString"] as String?,
    city: map["cityString"] as String?,
    street: map["streetString"] as String?,
    latitude: map["latitudeString"] as double?,
    longitude: map["longitudeString"] as double?,
    num_thumbs_up: map["num_thumbs_up"] as int?,
    alert_reliability: map["alert_reliability"] as int?,
    alert_confidence: map["alert_confidence"] as int?,
    near_by: map["near_by"] as String?,
    comments: map["comments"] as List?,
    num_comments: map["num_comments"] as int?,
    */
  );
}

}

class DataConverter {
  List<Map<String, dynamic>> listMappable(List<dynamic> records) {
    return records.map((e) => e as Map<String, dynamic>).toList();
  }



}
