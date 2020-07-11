import 'package:Radar/home/model/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';

class RequestsController extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage;
  final Nearby _nearby = Nearby();
  final Location _location = Location();
  final Strategy _strategy = Strategy.P2P_CLUSTER;
  final List<Request> requests = [];

  RequestsController(this._secureStorage) {
    _init();
  }

  void _init() async {
    _nearby.askLocationAndExternalStoragePermission();
    LocationData data = await _location.getLocation();
    String uid = await _secureStorage.read(key: 'UID');
    _nearby.startDiscovery(
      uid,
      _strategy,
      onEndpointFound: (endpointId, endpointName, serviceId) {
        requests.add(Request.create(endpointId, endpointName, data));
        notifyListeners();
      },
      onEndpointLost: (endpointId) {
        requests.removeWhere((element) => element.id == endpointId);
        notifyListeners();
      },
    );
  }

  void createRequest(Map<String, String> response) async {
    LocationData data = await _location.getLocation();
    _nearby.startAdvertising(
      '${response['title']}+${response['description']}+${data.latitude}+${data.longitude}',
      _strategy,
      onConnectionInitiated: (endpointId, connectionInfo) async {
        _nearby.acceptConnection(
          endpointId,
          onPayLoadRecieved: (endpointId, payload) {},
        );
      },
      onConnectionResult: (endpointId, status) {
        Fluttertoast.showToast(msg: status.toString());
      },
      onDisconnected: (endpointId) {},
    );
  }

  void requestConnection(Request request) async {
    String uid = await _secureStorage.read(key: 'UID');
    _nearby.requestConnection(
      uid,
      request.id,
      onConnectionInitiated: (endpointId, connectionInfo) {
        _nearby.acceptConnection(
          endpointId,
          onPayLoadRecieved: (endpointId, payload) {},
        );
      },
      onConnectionResult: (endpointId, status) {
        Fluttertoast.showToast(msg: status.toString());
      },
      onDisconnected: (endpointId) {},
    );
  }
}
