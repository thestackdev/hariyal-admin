import 'package:flutter/material.dart';
import 'package:superuser/services/add_admin.dart';
import 'package:superuser/services/auth_services.dart';

class AdminExtras extends StatefulWidget {
  @override
  _AdminExtrasState createState() => _AdminExtrasState();
}

class _AdminExtrasState extends State<AdminExtras> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddAdmin(),
            ),
          ),
          title: Center(
            child: Text('Add Admin'),
          ),
        ),
        ListTile(
          onTap: () async {
            await AuthServices().logout();
          },
          title: Center(
            child: Text('Logout'),
          ),
        )
      ],
    );
  }
}
