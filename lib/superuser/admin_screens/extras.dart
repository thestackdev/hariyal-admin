import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/services/auth_services.dart';
import 'package:superuser/superuser/admin_screens/admins.dart';
import 'package:superuser/superuser/admin_screens/all_customers.dart';
import 'package:superuser/superuser/admin_screens/user_intrests.dart';
import 'package:superuser/utils.dart';

class Extras extends StatefulWidget {
  final uid;

  const Extras({Key key, this.uid}) : super(key: key);

  @override
  _ExtrasState createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return utils.getContainer(
      child: ListView(
        children: <Widget>[
          utils.listTile(
            title: 'Intrests',
            leading: Icon(MdiIcons.informationOutline, color: Colors.red),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserIntrests(),
              ),
            ),
          ),
          utils.listTile(
            title: 'Customers',
            leading: Icon(MdiIcons.humanMaleMale, color: Colors.red),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AllCustomers(),
              ),
            ),
          ),
          utils.listTile(
            title: 'Admins',
            leading: Icon(MdiIcons.humanChild, color: Colors.red),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Admins(uid: widget.uid),
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
                  content: 'Logout ?',
                  yesPressed: () {
                    Navigator.pop(context);
                    AuthServices().logout();
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
