import 'dart:typed_data';

import 'package:Radar/utils/ConnectedUsers.dart';
import 'package:Radar/utils/User.dart';
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
  util.ConnectionState connectionState;
  MyRequest myRequest;
  ConnectedUsers connectedUsers;

  ProfileController(this.connectedUsers) {
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
        connectedUsers.requestCreater = User(endpointId);
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
    connectedUsers.requestCreater.currentMessage = Message(text: message, ownMessage: true);
    _nearby.sendBytesPayload(connectedUsers.requestCreater.endpointId,
        Uint8List.fromList(message.codeUnits));
  }

  void cancelMyRequest() async {
    myRequest = null;
    await _nearby.stopAdvertising();
    notifyListeners();
  }

  void acceptConnection(endpointId) {
    _nearby.acceptConnection(
      endpointId,
      onPayLoadRecieved: (endpointId, payload) {
        if (endpointId == connectedUsers.requestCreater.endpointId) {
          connectedUsers.requestCreater.messages.add(
            Message(
                text: String.fromCharCodes(payload.bytes), ownMessage: false),
          );
          notifyListeners();
        } else if (endpointId == connectedUsers.requestAccepter.endpointId) {
          connectedUsers.requestAccepter.messages.add(
            Message(
                text: String.fromCharCodes(payload.bytes), ownMessage: false),
          );
          notifyListeners();
        }
      },
      onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {
        if (payloadTransferUpdate.status == PayloadStatus.SUCCESS &&
            endpointId == connectedUsers.requestCreater.endpointId) {
          if (connectedUsers.requestCreater.currentMessage != null) {

            connectedUsers.requestCreater.messages.add(connectedUsers.requestCreater.currentMessage);
            notifyListeners();
            connectedUsers.requestCreater.currentMessage = null;

          }
        } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS &&
            endpointId == connectedUsers.requestAccepter.endpointId) {
          if (connectedUsers.requestAccepter.currentMessage != null) {
            connectedUsers.requestAccepter.messages.add(connectedUsers.requestAccepter.currentMessage);
            notifyListeners();
            connectedUsers.requestAccepter.currentMessage = null;
          }
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          Fluttertoast.showToast(msg: payloadTransferUpdate.status.toString());
        }
      },
    );
  }
}
