import 'package:Radar/home/model/HomeScreenController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<HomeScreenController>(
          builder: (context, controller, _) {
            return Text(controller.locationData?.latitude.toString());
          },
        ),
      ),
    );
  }
}
