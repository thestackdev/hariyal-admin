import 'package:flutter/material.dart';
import 'package:superuser/services/add_admin.dart';
import 'package:superuser/services/auth_services.dart';
import 'extras/extra_identifier.dart';
import 'extras/shorooms.dart';

class Extras extends StatefulWidget {
  @override
  _ExtrasState createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Colors.grey.shade300,
          ),
          child: ListTile(
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
        ),
        Container(
          margin: EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Colors.grey.shade300,
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExtraIdentifier(
                    identifier: 'category',
                  ),
                ),
              );
            },
            title: Center(
              child: Text('Categories'),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Colors.grey.shade300,
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExtraIdentifier(
                    identifier: 'states',
                  ),
                ),
              );
            },
            title: Center(
              child: Text('States'),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Colors.grey.shade300,
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExtraIdentifier(
                    identifier: 'areas',
                  ),
                ),
              );
            },
            title: Center(
              child: Text('Areas'),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Colors.grey.shade300,
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Showrooms(),
                ),
              );
            },
            title: Center(
              child: Text('Showrooms'),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Colors.red.shade300,
          ),
          child: ListTile(
            onTap: () async {
              AuthServices().logout();
            },
            title: Center(
              child: Text('Logout'),
            ),
          ),
        ),
      ],
    );
  }
}
