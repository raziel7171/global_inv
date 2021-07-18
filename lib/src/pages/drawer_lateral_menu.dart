import 'package:flutter/material.dart';

class drawerLateralMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu drawer'),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              size: 40,
            ),
            title: Text('First item'),
            subtitle: Text("This is the 1st item"),
            trailing: Icon(Icons.more_vert),
            onTap: () {},
          ),
          ListTile(
            title: Text('Second item'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Close the menu'),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
