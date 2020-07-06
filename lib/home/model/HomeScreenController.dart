import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class HomeScreenController extends ChangeNotifier {
  LocationData locationData;

  HomeScreenController() {
    enableLocationTracking();
  }

  void enableLocationTracking() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    notifyListeners();
  }
}