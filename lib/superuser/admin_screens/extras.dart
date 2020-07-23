import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:superuser/services/all_products.dart';
import 'package:superuser/superuser/admin_screens/admins.dart';
import 'package:superuser/superuser/admin_screens/customers.dart';
import 'package:superuser/utils.dart';

class Extras extends StatefulWidget {
  @override
  _ExtrasState createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return utils.container(
      child: ListView(
        children: <Widget>[
          utils.listTile(
            title: 'My Products',
            leading: Icon(MdiIcons.cartOutline, color: Colors.red),
            onTap: () => Get.to(AllProducts()),
          ),
          utils.listTile(
            title: 'Customers',
            leading: Icon(MdiIcons.humanMaleMale, color: Colors.red),
            onTap: () => Get.to(AllCustomers()),
          ),
          utils.listTile(
            title: 'Admins',
            leading: Icon(MdiIcons.humanChild, color: Colors.red),
            onTap: () => Get.to(Admins()),
          ),
          utils.listTile(
            title: 'Logout',
            leading: Icon(MdiIcons.logout, color: Colors.red),
            onTap: () => utils.simpleDialouge(
              label: 'Confirm',
              content: Text('Logout ?'),
              yesPressed: () {
                Get.back();
                FirebaseAuth.instance.signOut();
                Phoenix.rebirth(context);
              },
              noPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }
}
