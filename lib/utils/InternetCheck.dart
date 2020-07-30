import 'package:connectivity/connectivity.dart';

Future<bool> internetCheck() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  bool isConnected = false;

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    isConnected = true;
  } else
    isConnected = false;
  return isConnected;
}
