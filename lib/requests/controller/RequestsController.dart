import 'dart:typed_data';
import 'package:Radar/utils/ConnectedUsers.dart';
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
  ConnectedUsers connectedUsers;

  RequestsController(this._secureStorage, this.connectedUsers) {
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
    connectedUsers.requestAccepter
        .addRequestDetails(request.title, request.description);
    String uid = await _secureStorage.read(key: 'UID');
    _nearby.requestConnection(
      uid,
      request.id,
      onConnectionInitiated: (endpointId, connectionInfo) {
        connectedUsers.requestAccepter.connectionState =
            util.ConnectionState.Connecting;
        notifyListeners();
        acceptConnection(endpointId);
      },
      onConnectionResult: (endpointId, status) {
        if (status == Status.CONNECTED) {
          connectedUsers.requestAccepter.endpointId = endpointId;
          connectedUsers.requestAccepter.connectionState =
              util.ConnectionState.Connected;
          notifyListeners();
          Fluttertoast.showToast(msg: status.toString());
        }
      },
      onDisconnected: (endpointId) {
        connectedUsers.requestAccepter.connectionState =
            util.ConnectionState.Disconnected;
        notifyListeners();
      },
    );
  }

  void sendMessage(String message) {
    connectedUsers.requestAccepter.currentMessage =
        Message(text: message, ownMessage: true);
    _nearby.sendBytesPayload(connectedUsers.requestAccepter.endpointId,
        Uint8List.fromList(message.codeUnits));
  }

  void acceptConnection(endpointId) {
    _nearby.acceptConnection(
      endpointId,
      onPayLoadRecieved: (endpointId, payload) {
        if (endpointId == connectedUsers.requestAccepter.endpointId) {
          connectedUsers.requestAccepter.messages.add(
            Message(
                text: String.fromCharCodes(payload.bytes), ownMessage: false),
          );
          notifyListeners();
        } else if (endpointId == connectedUsers.requestCreater.endpointId) {
          connectedUsers.requestCreater.messages.add(
            Message(
                text: String.fromCharCodes(payload.bytes), ownMessage: false),
          );
          notifyListeners();
        }
      },
      onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {
        if (payloadTransferUpdate.status == PayloadStatus.SUCCESS &&
            endpointId == connectedUsers.requestAccepter.endpointId) {
          if (connectedUsers.requestAccepter.currentMessage != null) {
            connectedUsers.requestAccepter.messages
                .add(connectedUsers.requestAccepter.currentMessage);
            notifyListeners();

            connectedUsers.requestAccepter.currentMessage = null;
          }
        } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS &&
            endpointId == connectedUsers.requestCreater.endpointId) {
          if (connectedUsers.requestCreater.currentMessage != null) {
            connectedUsers.requestCreater.messages
                .add(connectedUsers.requestCreater.currentMessage);
            notifyListeners();
            connectedUsers.requestCreater.currentMessage = null;
          }
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          Fluttertoast.showToast(msg: payloadTransferUpdate.status.toString());
        }
      },
    );
  }
}
