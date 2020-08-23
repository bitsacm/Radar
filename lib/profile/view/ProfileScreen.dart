import 'package:Radar/profile/controller/ProfileController.dart';
import 'package:Radar/profile/view/MyRequestBar.dart';
import 'package:Radar/profile/view/MyRequestDetails.dart';
import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:Radar/utils/ConnectionState.dart' as util;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Consumer2<ProfileController, RequestsController>(
        builder: (context, _controller, _, child) {
      if (_controller.roles.requestCreater.connectionState ==
              util.ConnectionState.Disconnected ||
          _controller.roles.requestCreater.connectionState ==
              util.ConnectionState.Connected) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            backgroundColor: Color.fromARGB(255, 22, 86, 189),
            actions: <Widget>[
              IconButton(
                icon: Image.asset('assets/profile_screen/logout.png'),
                onPressed: () async {
                  await _controller.logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
                color: Colors.white,
              )
            ],
          ),
          body: Stack(
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
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/profile_screen/edit_name.svg',
                              ),
                            ),

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
              if (_controller.roles.requestCreater.doRequestDetailsExist())
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    child: MyRequestBar(
                      myRequestTitle:
                          _controller.roles.requestCreater.requestTitle,
                      cancelMyRequest: _controller.cancelMyRequest,
                    ),
                    onTap: () => showModalBottomSheet(
                      builder: (context) => MyRequestDetails(
                        myRequestTitle:
                            _controller.roles.requestCreater.requestTitle,
                        myRequestDescription:
                            _controller.roles.requestCreater.requestDescription,
                      ),
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
            ],
          ),
        );
      } else
        return Center(
          child: CircularProgressIndicator(),
        );
    });
  }
}
