import 'dart:typed_data';
import 'package:Radar/utils/Roles.dart';
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
  final Roles roles;

  RequestsController(this._secureStorage, this.roles) {
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
    roles.requestAccepter
        .addRequestDetails(request.title, request.description);
    String uid = await _secureStorage.read(key: 'UID');
    _nearby.requestConnection(
      uid,
      request.id,
      onConnectionInitiated: (endpointId, connectionInfo) {
        roles.requestAccepter.connectionState =
            util.ConnectionState.Connecting;
        notifyListeners();
        acceptConnection(endpointId);
      },
      onConnectionResult: (endpointId, status) {
        if (status == Status.CONNECTED) {
          roles.requestAccepter.endpointId = endpointId;
          roles.requestAccepter.connectionState =
              util.ConnectionState.Connected;
          roles.requestAccepter.sendMessage = (String message) {
            roles.requestAccepter.currentMessage =
                Message(text: message, ownMessage: true);
            _nearby.sendBytesPayload(roles.requestAccepter.endpointId,
                Uint8List.fromList(message.codeUnits));
          };
          notifyListeners();
          Fluttertoast.showToast(msg: status.toString());
        }
      },
      onDisconnected: (endpointId) {
        roles.requestAccepter.connectionState =
            util.ConnectionState.Disconnected;
        notifyListeners();
        roles.requestAccepter.clearMessages();
      },
    );
  }

  void acceptConnection(endpointId) {
    _nearby.acceptConnection(
      endpointId,
      onPayLoadRecieved: (endpointId, payload) {
        if (endpointId == roles.requestAccepter.endpointId) {
          roles.requestAccepter.messages.add(
            Message(
                text: String.fromCharCodes(payload.bytes), ownMessage: false),
          );
          notifyListeners();
        } else if (endpointId == roles.requestCreater.endpointId) {
          roles.requestCreater.messages.add(
            Message(
                text: String.fromCharCodes(payload.bytes), ownMessage: false),
          );
          notifyListeners();
        }
      },
      onPayloadTransferUpdate: payloadTransferUpdate,
    );
  }

  void createRequest(Map<String, String> response) async {
    LocationData data = await _location.getLocation();

    await _nearby.startAdvertising(
        '${response['title']}+${response['description']}+${data.latitude}+${data.longitude}',
        _strategy, onConnectionInitiated: (endpointId, connectionInfo) async {
      roles.requestCreater.connectionState =
          util.ConnectionState.Connecting;
      notifyListeners();
      acceptConnection(endpointId);
    }, onConnectionResult: (endpointId, status) {
      if (status == Status.CONNECTED) {
        roles.requestCreater.endpointId = endpointId;
        roles.requestCreater.connectionState =
            util.ConnectionState.Connected;
        roles.requestCreater.sendMessage = (String message) {
          roles.requestCreater.currentMessage =
              Message(text: message, ownMessage: true);
          _nearby.sendBytesPayload(roles.requestCreater.endpointId,
              Uint8List.fromList(message.codeUnits));
        };

        notifyListeners();
        Fluttertoast.showToast(msg: status.toString());
      }
    }, onDisconnected: (endpointId) {
      roles.requestCreater.connectionState =
          util.ConnectionState.Disconnected;
      notifyListeners();
      roles.requestCreater.clearMessages();
    }, serviceId: 'com.example.Radar');
    roles.requestCreater
        .addRequestDetails(response['title'], response['description']);
    notifyListeners();
  }

  void cancelMyRequest() async {
    roles.requestCreater.clearRequestDetails();
    await _nearby.stopAdvertising();
    notifyListeners();
  }

  void payloadTransferUpdate(
      String endpointId, PayloadTransferUpdate payloadTransferUpdate) {
    if (payloadTransferUpdate.status == PayloadStatus.SUCCESS &&
        endpointId == roles.requestAccepter.endpointId) {
      if (roles.requestAccepter.currentMessage != null) {
        roles.requestAccepter.messages
            .add(roles.requestAccepter.currentMessage);
        notifyListeners();

        roles.requestAccepter.currentMessage = null;
      }
    } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS &&
        endpointId == roles.requestCreater.endpointId) {
      if (roles.requestCreater.currentMessage != null) {
        roles.requestCreater.messages
            .add(roles.requestCreater.currentMessage);
        notifyListeners();
        roles.requestCreater.currentMessage = null;
      }
    } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
      Fluttertoast.showToast(msg: payloadTransferUpdate.status.toString());
    }
  }
}
