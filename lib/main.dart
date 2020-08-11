import 'package:Radar/chat/view/ChatScreen.dart';
import 'package:Radar/utils/Roles.dart';
import 'package:Radar/home/view/HomeScreen.dart';
import 'package:Radar/profile/controller/ProfileController.dart';
import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'auth/model/LoginScreenController.dart';
import 'auth/view/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final Roles _roles = Roles();
  final RequestsController _requestsController =
      RequestsController(_secureStorage, _roles);
  final ProfileController _profileController = ProfileController();
  if ((await _secureStorage.read(key: 'UID')) == null)
    runApp(MyApp(
      initialRoute: '/login',
      secureStorage: _secureStorage,
      requestsController: _requestsController,
      profileController: _profileController,
    ));
  else
    runApp(MyApp(
      initialRoute: '/home',
      secureStorage: _secureStorage,
      requestsController: _requestsController,
      profileController: _profileController,
    ));
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage secureStorage;
  final String initialRoute;
  final RequestsController requestsController;
  final ProfileController profileController;
  MyApp({
    @required this.secureStorage,
    @required this.initialRoute,
    @required this.requestsController,
    @required this.profileController,
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
        '/login': (context) {
          return ChangeNotifierProvider<LoginScreenController>(
            create: (context) => LoginScreenController(secureStorage),
            child: LoginScreen(),
          );
        },
        '/home': (context) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: requestsController),
              ChangeNotifierProvider.value(value: profileController),
            ],
            child: HomeScreen(),
          );
        },
        '/requestAccepterChat': (context) {
          return ChangeNotifierProvider.value(
              value: requestsController, child: ChatScreen());
        },
        '/requestCreaterChat': (context) {
          return ChangeNotifierProvider.value(
              value: requestsController, child: ChatScreen());
        }
      },
    );
  }
}
