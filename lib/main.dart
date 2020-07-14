import 'package:Radar/home/view/HomeScreen.dart';
import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:Radar/requests/view/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'auth/model/LoginScreenController.dart';
import 'auth/view/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final RequestsController _requestsController =
      RequestsController(_secureStorage);
  if ((await _secureStorage.read(key: 'UID')) == null)
    runApp(MyApp(
      initialRoute: '/login',
      secureStorage: _secureStorage,
      requestsController: _requestsController,
    ));
  else
    runApp(MyApp(
      initialRoute: '/',
      secureStorage: _secureStorage,
      requestsController: _requestsController,
    ));
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage secureStorage;
  final String initialRoute;
  final RequestsController requestsController;
  MyApp({
    @required this.secureStorage,
    @required this.initialRoute,
    @required this.requestsController,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      routes: {
        '/chat': (context) {
          return ChangeNotifierProvider.value(
            value: requestsController,
            child: ChatScreen(),
          );
        },
        '/login': (context) {
          return ChangeNotifierProvider<LoginScreenController>(
              create: (context) => LoginScreenController(),
              child: LoginScreen(secureStorage));
        },
        '/': (context) {
          return HomeScreen(requestsController);
        },
      },
    );
  }
}
