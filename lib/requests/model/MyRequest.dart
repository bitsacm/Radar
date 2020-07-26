import 'package:flutter/material.dart';
import 'package:location/location.dart';

class MyRequest {
  String title;
  String description;
  LocationData userLocation;

  MyRequest({
    @required this.title,
    @required this.description,
    @required this.userLocation,
  });
}
