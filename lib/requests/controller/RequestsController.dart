import 'dart:typed_data';
import 'package:Radar/requests/model/Message.dart';
import 'package:Radar/requests/model/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';

enum ConnectionState {
  Disconnected,
  Connecting,
  Connected,
}

class RequestsController extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage;
  final Nearby _nearby = Nearby();
  final Location _location = Location();
  final Strategy _strategy = Strategy.P2P_CLUSTER;
  final List<Request> requests = [];
  final List<Message> messages = [];
  String _connectedDeviceID;
  Message _currentMessage;
  ConnectionState connectionState;

  RequestsController(this._secureStorage) {
    connectionState = ConnectionState.Disconnected;
    _init();
  }

  void _init() async {
    _nearby.askLocationPermission();
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
        connectionState = ConnectionState.Connecting;
        notifyListeners();
        _nearby.acceptConnection(
          endpointId,
          onPayLoadRecieved: (endpointId, payload) {
            messages.add(Message(
                text: String.fromCharCodes(payload.bytes), ownMessage: false));
            notifyListeners();
          },
          onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {
            if (payloadTransferUpdate.status == PayloadStatus.SUCCESS &&
                endpointId == _connectedDeviceID) {
              if (_currentMessage != null) {
                messages.add(_currentMessage);
                notifyListeners();
                _currentMessage = null;
              }
            } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
              Fluttertoast.showToast(
                  msg: payloadTransferUpdate.status.toString());
            }
          },
        );
      },
      onConnectionResult: (endpointId, status) {
        connectionState = ConnectionState.Connected;
        notifyListeners();
        Fluttertoast.showToast(msg: status.toString());
        _connectedDeviceID = endpointId;
      },
      onDisconnected: (endpointId) {
        connectionState = ConnectionState.Disconnected;
        notifyListeners();
      },
    );
  }

  void requestConnection(Request request) async {
    String uid = await _secureStorage.read(key: 'UID');
    _nearby.requestConnection(
      uid,
      request.id,
      onConnectionInitiated: (endpointId, connectionInfo) {
        connectionState = ConnectionState.Connecting;
        notifyListeners();
        _nearby.acceptConnection(
          endpointId,
          onPayLoadRecieved: (endpointId, payload) {
            messages.add(Message(
                text: String.fromCharCodes(payload.bytes), ownMessage: false));

            notifyListeners();
          },
          onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {
            if (payloadTransferUpdate.status == PayloadStatus.SUCCESS &&
                endpointId == _connectedDeviceID) {
              if (_currentMessage != null) {
                messages.add(_currentMessage);
                notifyListeners();
                _currentMessage = null;
              }
            } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
              Fluttertoast.showToast(
                  msg: payloadTransferUpdate.status.toString());
            }
          },
        );
      },
      onConnectionResult: (endpointId, status) {
        connectionState = ConnectionState.Connected;

        notifyListeners();
        Fluttertoast.showToast(msg: status.toString());
        _connectedDeviceID = endpointId;
      },
      onDisconnected: (endpointId) {
        connectionState = ConnectionState.Disconnected;
        notifyListeners();
      },
    );
  }

  void sendMessage(String message) {
    _currentMessage = Message(text: message, ownMessage: true);
    _nearby.sendBytesPayload(
        _connectedDeviceID, Uint8List.fromList(message.codeUnits));
  }
}
