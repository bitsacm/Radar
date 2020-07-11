import 'package:location/location.dart';
import 'dart:math';

class Request {
  String id;
  String title;
  String description;
  double distance;

  Request({this.id, this.title, this.description, this.distance});

  factory Request.create(String id, String request, LocationData userLocation) {
    List<String> list = request.split('+');
    String title = list[0];
    String description = list[1];
    double requestLatitude = double.parse(list[2]);
    double requestLongitude = double.parse(list[3]);
    double userLatitude = userLocation.latitude;
    double userLongitude = userLocation.longitude;
    double latDifference = pi * (userLatitude - requestLatitude).abs() / 180;
    double lonDifference = pi * (userLongitude - requestLongitude).abs() / 180;
    double a = sin(latDifference / 2) * sin(latDifference / 2) +
        cos(pi * (requestLatitude) / 180) *
            cos(pi * (userLatitude) / 180) *
            sin(lonDifference / 2) *
            sin(lonDifference / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = 6378 * c * 1000;
    return Request(
      id: id,
      title: title,
      description: description,
      distance: distance,
    );
  }
}
