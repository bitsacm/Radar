import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: null,
            color: Colors.white,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                //backgroundImage: NetworkImage('url'),
                radius: 60,
              ),
            ),
            Container(
                padding: EdgeInsets.all(16),
                child: ListTile(
                  trailing: IconButton(icon: Icon(Icons.save), onPressed: null),
                  title: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Name ',
                    ),
                    onEditingComplete: null,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
