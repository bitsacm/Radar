import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String description;
  ChatAppBar({@required this.title, @required this.description});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 22, 86, 189),
      title: Text('as'),
      actions: [
        IconButton(icon: Icon(Icons.info_outline_rounded), onPressed: () {}),
      ],
      toolbarHeight: 56,
    );
    Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6.0,
          )
        ],
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title ?? 'Title'),
              SizedBox(
                height: 5,
              ),
              FittedBox(
                child: Text(description ??
                    'Maiores dolor quibusdam esse minus in. Fuga incidunt quaerat temporibus harum nemo impedit quibusdam expedita suscipit. Ut dicta dolore labore consequuntur itaque. Incidunt sed autem ea autem molestiae ducimus.'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70);
}
