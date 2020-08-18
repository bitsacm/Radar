import 'package:Radar/requests/view/CustomFloatingButton.dart';
import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:Radar/requests/view/ConnectedDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:Radar/utils/ConnectionState.dart' as util;

class RequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RequestsController>(
      builder: (context, _controller, child) {
        if (_controller.roles.requestAccepter.connectionState ==
                util.ConnectionState.Connected &&
            _controller.roles.requestAccepter.shownConnectedDialog == false) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              showDialog(
                context: context,
                builder: (context) {
                  return ConnectedDialog(
                    ownRequest: false,
                  );
                },
              ).whenComplete(() {
                _controller.roles.requestAccepter.shownConnectedDialog = true;
                Navigator.of(context).pushNamed('/requestAccepterChat');
              });
            },
          );
        } else if (_controller.roles.requestCreater.connectionState ==
                util.ConnectionState.Connected &&
            _controller.roles.requestCreater.shownConnectedDialog == false) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) {
              showDialog(
                context: context,
                builder: (context) {
                  return ConnectedDialog(
                    ownRequest: true,
                  );
                },
              ).whenComplete(() {
                _controller.roles.requestCreater.shownConnectedDialog = true;
                Navigator.of(context).pushNamed('/requestCreaterChat');
              });
            },
          );
        }

        if (_controller.roles.requestAccepter.connectionState ==
                util.ConnectionState.Disconnected ||
            _controller.roles.requestAccepter.connectionState ==
                util.ConnectionState.Connected) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0.0,
              title: Text(
                'Active Requests',
                style: TextStyle(color: Color.fromRGBO(80, 80, 79, 1)),
              ),
              backgroundColor: Colors.white,
            ),
            body: Column(
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        _controller.requests[index].title,
                        style: Theme.of(context).textTheme.title,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _controller.requests[index].description,
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(5),
                      trailing: Text(
                          '${_controller.requests[index].distance.toStringAsFixed(2)} m'),
                      onTap: () => _controller
                          .requestConnection(_controller.requests[index]),
                    ),
                  ),
                  itemCount: _controller.requests.length,
                ),
              ],
            ),
            floatingActionButton: CustomFloatingButton(),
          );
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}
