import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:Radar/utils/ConnectionState.dart' as util;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomFloatingButton extends StatefulWidget {
  @override
  _CustomFloatingButtonState createState() => _CustomFloatingButtonState();
}

class _CustomFloatingButtonState extends State<CustomFloatingButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  List<Widget> list = [];

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget requestAccepterChat(Function onPressed) {
    return Container(
      child: FloatingActionButton(
        onPressed: onPressed,
        child: FittedBox(child: Text('Accepted Request')),
        heroTag: 'requestAccepter',
      ),
    );
  }

  Widget requestCreaterChat(Function onPressed) {
    return Container(
      child: FloatingActionButton(
        onPressed: onPressed,
        child:FittedBox(child: Text('My Request')),
        heroTag: 'requestCreater',
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
        heroTag: 'toggle',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestsController>(
      builder: (context, _requestsController, child) {
        list.clear();
        if (_requestsController.roles.requestCreater.connectionState ==
                util.ConnectionState.Connected &&
            _requestsController.roles.requestAccepter.connectionState !=
                util.ConnectionState.Connected) {
          list.add(Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value,
              0.0,
            ),
            child: requestCreaterChat(() {
              Navigator.of(context).pushNamed('/requestCreaterChat');
            }),
          ));
          list.add(toggle());
        } else if (_requestsController.roles.requestCreater.connectionState !=
                util.ConnectionState.Connected &&
            _requestsController.roles.requestAccepter.connectionState ==
                util.ConnectionState.Connected) {
          list.add(Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value,
              0.0,
            ),
            child: requestAccepterChat(() {
              Navigator.of(context).pushNamed('/requestAccepterChat');
            }),
          ));
          list.add(toggle());
        } else if (_requestsController.roles.requestCreater.connectionState ==
                util.ConnectionState.Connected &&
            _requestsController.roles.requestAccepter.connectionState ==
                util.ConnectionState.Connected) {
          list.add(Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value * 2.0,
              0.0,
            ),
            child: requestAccepterChat(() {
              Navigator.of(context).pushNamed('/requestAccepterChat');
            }),
          ));
          list.add(Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value,
              0.0,
            ),
            child: requestCreaterChat(() {
              Navigator.of(context).pushNamed('/requestCreaterChat');
            }),
          ));
          list.add(toggle());
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: list,
        );
      },
    );
  }
}
