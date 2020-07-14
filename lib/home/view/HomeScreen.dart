import 'package:Radar/profile/ProfileScreen.dart';
import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:Radar/requests/view/RequestsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final RequestsController requestsController;
  HomeScreen(this.requestsController);
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
      ChangeNotifierProvider.value(
        value: widget.requestsController,
        child: RequestsScreen(),
      ),
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
