import 'package:Radar/profile/controller/ProfileController.dart';
import 'package:Radar/requests/controller/RequestsController.dart'
    as requestController;
import 'package:Radar/chat/view/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Radar/utils/ConnectionState.dart' as util;

class RequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<requestController.RequestsController, ProfileController>(
      builder: (context, _controller, _, child) {
        if (_controller.connectionState == util.ConnectionState.Disconnected) {
          return Scaffold(
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
          );
        } else if (_controller.connectionState ==
            util.ConnectionState.Connecting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          return ChatScreen(_controller);
        }
      },
    );
  }
}
