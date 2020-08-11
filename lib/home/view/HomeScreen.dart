import 'package:Radar/profile/view/ProfileScreen.dart';
import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:Radar/requests/view/CreateRequestDialog.dart';
import 'package:Radar/requests/view/RequestsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
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
      RequestsScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  right: 40,
                  top: 8,
                  bottom: 8,
                ),
                child: FittedBox(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Icon(Icons.message),
                        ),
                        Text('Requests'),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  top: 8,
                  bottom: 8,
                ),
                child: FittedBox(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Icon(Icons.person),
                        ),
                        Text('Profile'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _pages[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => CreateRequestDialog(),
        ).then((value) {
          if (value != null)
            Provider.of<RequestsController>(context, listen: false)
                .createRequest(value);
        }),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
