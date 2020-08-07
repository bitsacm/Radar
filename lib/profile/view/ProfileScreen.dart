import 'package:Radar/profile/controller/ProfileController.dart';
import 'package:Radar/chat/view/ChatScreen.dart';
import 'package:Radar/profile/view/MyRequestBar.dart';
import 'package:Radar/profile/view/MyRequestDetails.dart';
import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Radar/utils/ConnectionState.dart' as util;

class ProfileScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 22, 86, 189),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/profile_screen/logout.png'),
            onPressed: null,
            color: Colors.white,
          )
        ],
      ),
      body: Consumer2<ProfileController, RequestsController>(
        builder: (context, _controller, _, child) {
          if (_controller.connectedUsers.requestCreater.connectionState ==
              util.ConnectionState.Disconnected) {
            return Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: mediaQuery.size.height > 400 ? 40 : 0,
                  ),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/profile_screen/profile_pic.png'),
                        radius: 50,
                        backgroundColor: Colors.transparent,
                      ),
                      // ),
                      Container(
                        padding: EdgeInsets.all(12),
                        child: ListTile(
                          // trailing: IconButton(
                          // icon: Image.asset(
                          //     'assets/profile_screen/edit_name.png'),
                          // onPressed: null),
                          title: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              // icon: Icon(Icons.person),
                              // labelText: 'Name ',

                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hintText: 'Full Name',
                              hintStyle: TextStyle(
                                fontFamily: 'Verdana',
                                fontSize: 16,
                              ),
                              suffixIcon: Image.asset(
                                  'assets/profile_screen/edit_name.png'),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                            ),
                            onEditingComplete: null,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_controller.connectedUsers.requestCreater
                    .doRequestDetailsExist())
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: MyRequestBar(_controller),
                      onTap: () => showModalBottomSheet(
                        builder: (context) => MyRequestDetails(_controller),
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
              ],
            );
          } else if (_controller
                  .connectedUsers.requestCreater.connectionState ==
              util.ConnectionState.Connecting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            return ChatScreen(
              _controller,
            );
          }
        },
      ),
    );
  }
}
