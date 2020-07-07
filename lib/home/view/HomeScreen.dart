import 'package:Radar/home/model/HomeScreenController.dart';
import 'package:Radar/home/view/ProfileScreen.dart';
import 'package:Radar/home/view/RequestsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex;
  List<Widget> _pages = [
    RequestsScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    this.currentIndex = 0;
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
            icon: Icon(Icons.message),
            title: Text('Requests')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile')
          )
        ],
      ),
      body: _pages[this.currentIndex],
    );
  }
}