import 'package:Radar/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'auth/model/LoginScreenController.dart';
import 'auth/view/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  if ((await _secureStorage.read(key: 'UID')) == null)
    runApp(MyApp(
      initialRoute: '/login',
      secureStorage: _secureStorage,
    ));
  else
    runApp(MyApp(
      initialRoute: '/',
      secureStorage: _secureStorage,
    ));
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage secureStorage;
  final String initialRoute;
  MyApp({@required this.secureStorage, @required this.initialRoute});

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
        '/login': (context) {
          return ChangeNotifierProvider<LoginScreenController>(
              create: (context) => LoginScreenController(),
              child: LoginScreen(secureStorage));
        },
        '/': (context) {
          return HomeScreen();
        },
      },
    );
  }
}
