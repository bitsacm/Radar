import 'dart:typed_data';

import 'package:Radar/chat/model/Message.dart';
import 'package:Radar/requests/model/MyRequest.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:Radar/utils/ConnectionState.dart' as util;

class ProfileController with ChangeNotifier {
  final Nearby _nearby = Nearby();
  final Location _location = Location();
  final Strategy _strategy = Strategy.P2P_CLUSTER;
  final List<Message> messages = [];
  String _connectedDeviceID;
  Message _currentMessage;
  util.ConnectionState connectionState;
  MyRequest myRequest;

  ProfileController() {
    connectionState = util.ConnectionState.Disconnected;
  }
  void createRequest(Map<String, String> response) async {
    LocationData data = await _location.getLocation();

    await _nearby.startAdvertising(
        '${response['title']}+${response['description']}+${data.latitude}+${data.longitude}',
        _strategy, onConnectionInitiated: (endpointId, connectionInfo) async {
      connectionState = util.ConnectionState.Connecting;
      notifyListeners();
      acceptConnection(endpointId);
    }, onConnectionResult: (endpointId, status) {
      if (status == Status.CONNECTED) {
        connectionState = util.ConnectionState.Connected;
        notifyListeners();
        Fluttertoast.showToast(msg: status.toString());
        _connectedDeviceID = endpointId;
      }
    }, onDisconnected: (endpointId) {
      connectionState = util.ConnectionState.Disconnected;
      notifyListeners();
    }, serviceId: 'com.example.Radar');
    myRequest = MyRequest(
      title: response['title'],
      description: response['description'],
      userLocation: data,
    );
    notifyListeners();
  }

  void sendMessage(String message) {
    _currentMessage = Message(text: message, ownMessage: true);
    _nearby.sendBytesPayload(
        _connectedDeviceID, Uint8List.fromList(message.codeUnits));
  }

  void cancelMyRequest() async {
    myRequest = null;
    await _nearby.stopAdvertising();
    notifyListeners();
  }

  void acceptConnection(endpointId) async {
    _nearby.acceptConnection(
      endpointId,
      onPayLoadRecieved: (endpointId, payload) {
        print('profile message recieved');
        if (endpointId == _connectedDeviceID) {
          messages.add(
            Message(
                text: String.fromCharCodes(payload.bytes), ownMessage: false),
          );
          notifyListeners();
        }
      },
      onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {
        print('profile payload update');
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
