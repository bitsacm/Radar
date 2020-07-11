import 'package:Radar/home/model/RequestsController.dart';
import 'package:Radar/home/view/ProfileScreen.dart';
import 'package:Radar/home/view/RequestsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final FlutterSecureStorage _secureStorage;
  HomeScreen(this._secureStorage);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex;
  List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    this.currentIndex = 0;
    _pages = [
      ChangeNotifierProvider(
          create: (context) => RequestsController(widget._secureStorage),
          child: RequestsScreen()),
      ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            this.currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.message), title: Text('Requests')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
      body: _pages[this.currentIndex],
    );
  }
}
