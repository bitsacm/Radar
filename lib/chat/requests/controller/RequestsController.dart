import 'dart:typed_data';
import 'package:Radar/chat/model/Message.dart';
import 'package:Radar/requests/model/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:Radar/utils/ConnectionState.dart' as util;

class RequestsController extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage;
  final Nearby _nearby = Nearby();
  final Location _location = Location();
  final Strategy _strategy = Strategy.P2P_CLUSTER;
  final List<Request> requests = [];
  final List<Message> messages = [];
  String _connectedDeviceID;
  Message _currentMessage;
  Request acceptedRequest;
  util.ConnectionState connectionState;

  RequestsController(this._secureStorage) {
    connectionState = util.ConnectionState.Disconnected;
    _init();
  }

  void _init() async {
    _nearby.askLocationPermission();
    LocationData data = await _location.getLocation();
    String uid = await _secureStorage.read(key: 'UID');
    _nearby.startDiscovery(
      uid,
      _strategy,
      serviceId: 'com.example.Radar',
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

  void requestConnection(Request request) async {
    acceptedRequest=request;
    String uid = await _secureStorage.read(key: 'UID');
    _nearby.requestConnection(
      uid,
      request.id,
      onConnectionInitiated: (endpointId, connectionInfo) {
        connectionState = util.ConnectionState.Connecting;
        notifyListeners();
        acceptConnection(endpointId);
      },
      onConnectionResult: (endpointId, status) {
        if (status == Status.CONNECTED) {
          connectionState = util.ConnectionState.Connected;

          notifyListeners();
          Fluttertoast.showToast(msg: status.toString());
          _connectedDeviceID = endpointId;
        }
      },
      onDisconnected: (endpointId) {
        connectionState = util.ConnectionState.Disconnected;
        notifyListeners();
      },
    );
  }

  void sendMessage(String message) {
    _currentMessage = Message(text: message, ownMessage: true);
    _nearby.sendBytesPayload(
        _connectedDeviceID, Uint8List.fromList(message.codeUnits));
  }

  void acceptConnection(endpointId) {
    _nearby.acceptConnection(
      endpointId,
      onPayLoadRecieved: (endpointId, payload) {
        print('request message recieved');

        if (endpointId == _connectedDeviceID) {
          messages.add(Message(
              text: String.fromCharCodes(payload.bytes), ownMessage: false));
          notifyListeners();
        }
      },
      onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {
        print('request payload update');

        if (payloadTransferUpdate.status == PayloadStatus.SUCCESS &&
            endpointId == _connectedDeviceID) {
          if (_currentMessage != null) {
            messages.add(_currentMessage);
            notifyListeners();
            _currentMessage = null;
          }
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          Fluttertoast.showToast(msg: payloadTransferUpdate.status.toString());
        }
      },
    );
  }
}
