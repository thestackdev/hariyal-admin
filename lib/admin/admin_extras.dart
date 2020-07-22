import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/services/add_admin.dart';
import 'package:superuser/utils.dart';

class AdminExtras extends StatefulWidget {
  @override
  _AdminExtrasState createState() => _AdminExtrasState();
}

class _AdminExtrasState extends State<AdminExtras> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return utils.container(
      child: ListView(
        children: <Widget>[
          utils.listTile(
            leading: Icon(MdiIcons.humanChild, color: Colors.red),
            title: 'Add Admin',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddAdmin(),
              ),
            ),
          ),
          utils.listTile(
            title: 'Logout',
            leading: Icon(MdiIcons.logout, color: Colors.red),
            onTap: () async {
              showDialog(
                context: context,
                child: utils.alertDialog(
                  content: 'Signout ?',
                  yesPressed: () {
                    Navigator.pop(context);
                    FirebaseAuth.instance.signOut();
                  },
                  noPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
