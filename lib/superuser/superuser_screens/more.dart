import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:superuser/services/add_admin.dart';
import 'package:superuser/services/all_products.dart';
import 'package:superuser/services/profile.dart';
import 'package:superuser/superuser/utilities/categories.dart';
import 'package:superuser/superuser/utilities/specifications.dart';
import 'package:superuser/superuser/utilities/states.dart';
import 'package:superuser/utils.dart';
import '../../authenticate.dart';
import '../../utils.dart';
import '../interests.dart';
import '../utilities/shorooms.dart';
import 'admins.dart';
import 'customers.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();

    return Scaffold(
      appBar: utils.appbar('Superuser Console'),
      body: utils.container(
        child: ListView(
          children: <Widget>[
            utils.listTile(
              title: 'My Profile',
              leading: Icon(
                MdiIcons.faceProfile,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(Profile()),
            ),
            utils.listTile(
              title: 'Add Admin',
              leading: Icon(
                MdiIcons.humanChild,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(AddAdmin()),
            ),
            utils.listTile(
              title: 'Interests',
              leading: Icon(
                MdiIcons.humanChild,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(Interests()),
            ),
            utils.listTile(
              title: 'Categories',
              leading: Icon(
                MdiIcons.cartArrowRight,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(CategoriesScreen()),
            ),
            utils.listTile(
              title: 'Specifications',
              leading: Icon(
                MdiIcons.cartArrowRight,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(Specifications()),
            ),
            utils.listTile(
              title: 'Locations',
              leading: Icon(
                MdiIcons.locationExit,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(States()),
            ),
            utils.listTile(
              title: 'Showrooms',
              leading: Icon(
                MdiIcons.mapMarkerOutline,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(Showrooms()),
            ),
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
              onTap: () => utils.getSimpleDialouge(
                title: 'Confirm',
                content: Text('Logout ?'),
                yesPressed: () {
                  Get.back();
                  FirebaseAuth.instance.signOut();
                  Get.offAll(Authenticate());
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
