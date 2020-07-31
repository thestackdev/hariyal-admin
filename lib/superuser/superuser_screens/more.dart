import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/services/all_products.dart';
import 'package:superuser/utils.dart';

import '../../utils.dart';

class Settings extends StatelessWidget {
  final products = Firestore.instance.collection('products');
  final Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Console'),
      body: utils.container(
        child: ListView(
          children: <Widget>[
            utils.listTile(
              title: 'My Profile',
              leading: Icon(
                MdiIcons.faceProfile,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/profile'),
            ),
            utils.listTile(
              title: 'Add Admin',
              leading: Icon(
                MdiIcons.humanChild,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/add_admin'),
            ),
            utils.listTile(
              title: 'User Interests',
              leading: Icon(
                MdiIcons.humanChild,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/interests'),
            ),
            utils.listTile(
              title: 'My Products',
              leading: Icon(MdiIcons.cartOutline, color: Colors.red),
              onTap: () => Get.to(AllProducts(query: products)),
            ),
            utils.listTile(
              title: 'Customers',
              leading: Icon(MdiIcons.humanMaleMale, color: Colors.red),
              onTap: () => Get.toNamed('/all_customers'),
            ),
            utils.listTile(
              title: 'Admins',
              leading: Icon(MdiIcons.humanChild, color: Colors.red),
              onTap: () => Get.toNamed('/admins'),
            ),
            utils.listTile(
              title: 'Categories',
              leading: Icon(
                MdiIcons.cartArrowRight,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/categories'),
            ),
            utils.listTile(
              title: 'Locations',
              leading: Icon(
                MdiIcons.locationExit,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/states'),
            ),
            utils.listTile(
              title: 'Specifications',
              leading: Icon(
                MdiIcons.cartArrowRight,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/specifications'),
            ),
            utils.listTile(
              title: 'Showrooms',
              leading: Icon(
                MdiIcons.mapMarkerOutline,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/showrooms'),
            ),
            utils.listTile(
              title: 'Logout',
              leading: Icon(MdiIcons.logout, color: Colors.red),
              onTap: () => utils.getSimpleDialouge(
                title: 'Confirm',
                content: Text('Logout ?'),
                yesPressed: () => {
                  Get.back(),
                  FirebaseAuth.instance.signOut(),
                },
                noPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
