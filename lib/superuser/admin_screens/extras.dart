import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/services/all_products.dart';
import 'package:superuser/superuser/admin_screens/admins.dart';
import 'package:superuser/superuser/admin_screens/customers.dart';
import 'package:superuser/utils.dart';

class Extras extends StatefulWidget {
  @override
  _ExtrasState createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return utils.container(
      child: ListView(
        children: <Widget>[
          utils.listTile(
            title: 'My Products',
            leading: Icon(MdiIcons.cartOutline, color: Colors.red),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AllProducts(),
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
                builder: (_) => Admins(),
              ),
            ),
          ),
          utils.listTile(
            title: 'Logout',
            leading: Icon(MdiIcons.logout, color: Colors.red),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return utils.alertDialog(
                    content: 'Logout ?',
                    yesPressed: () {
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut();
                    },
                    noPressed: () {
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
