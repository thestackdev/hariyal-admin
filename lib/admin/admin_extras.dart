import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/services/add_admin.dart';
import 'package:superuser/services/auth_services.dart';
import 'package:superuser/utils.dart';

class AdminExtras extends StatefulWidget {
  @override
  _AdminExtrasState createState() => _AdminExtrasState();
}

class _AdminExtrasState extends State<AdminExtras> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: utils.getBoxDecoration(),
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Colors.grey.shade100,
            ),
            child: ListTile(
              leading: Icon(
                MdiIcons.humanChild,
                color: Colors.red,
              ),
              trailing: Icon(
                MdiIcons.chevronRight,
                color: Colors.red,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddAdmin(),
                ),
              ),
              title: Text(
                'Add Admin',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Colors.grey.shade100,
            ),
            child: ListTile(
              leading: Icon(
                MdiIcons.logout,
                color: Colors.red,
              ),
              trailing: Icon(
                MdiIcons.chevronRight,
                color: Colors.red,
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    title: Text(
                      'Are you sure ?',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      'Do you want to signout',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            AuthServices().logout();
                          }),
                      FlatButton(
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
