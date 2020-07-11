import 'package:Radar/home/model/RequestsController.dart';
import 'package:Radar/home/view/CreateRequestDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RequestsController>(
      builder: (context, _controller, child) => Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              child: Text(
                'Active Requests',
                style: TextStyle(fontSize: 20),
              ),
              margin: EdgeInsets.only(top: 40),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => CreateRequestDialog(),
          ).then((value) {
            if (value != null) _controller.createRequest(value);
          }),
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
