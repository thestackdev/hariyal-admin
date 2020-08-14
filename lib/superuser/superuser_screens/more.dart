import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';

class Settings extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) => controllers.utils.root(
        label: 'More',
        child: ListView(
          children: <Widget>[
            controllers.utils.listTile(
              title: 'My Profile',
              leading: Icon(OMIcons.face, color: Colors.redAccent),
              onTap: () => Get.toNamed('profile'),
            ),
            controllers.utils.listTile(
              title: 'Add Admin',
              leading: Icon(OMIcons.personAdd, color: Colors.redAccent),
              onTap: () => Get.toNamed('add_admin'),
            ),
            controllers.utils.listTile(
              title: 'Add Product',
              leading: Icon(OMIcons.shoppingCart, color: Colors.redAccent),
              onTap: () => Get.toNamed('add_product'),
            ),
            controllers.utils.listTile(
              title: 'User Interests',
              leading: Icon(OMIcons.shoppingBasket, color: Colors.redAccent),
              onTap: () => Get.toNamed('interests'),
            ),
            controllers.utils.listTile(
              title: 'Products',
              leading: Icon(OMIcons.shoppingBasket, color: Colors.redAccent),
              onTap: () => Get.toNamed('allProducts'),
            ),
            controllers.utils.listTile(
              title: 'Customers',
              leading: Icon(OMIcons.childFriendly, color: Colors.redAccent),
              onTap: () => Get.toNamed('all_customers'),
            ),
            controllers.utils.listTile(
              title: 'Admins',
              leading: Icon(OMIcons.childFriendly, color: Colors.redAccent),
              onTap: () => Get.toNamed('admins'),
            ),
            controllers.utils.listTile(
              title: 'Categories',
              leading: Icon(OMIcons.category, color: Colors.redAccent),
              onTap: () => Get.toNamed('categories'),
            ),
            controllers.utils.listTile(
              title: 'Locations',
              leading: Icon(OMIcons.place, color: Colors.redAccent),
              onTap: () => Get.toNamed('states'),
            ),
            controllers.utils.listTile(
              title: 'Specifications',
              leading: Icon(OMIcons.newReleases, color: Colors.redAccent),
              onTap: () => Get.toNamed('specifications'),
            ),
            controllers.utils.listTile(
              title: 'Showrooms',
              leading: Icon(OMIcons.locationCity, color: Colors.redAccent),
              onTap: () => Get.toNamed('showrooms'),
            ),
            controllers.utils.listTile(
              title: 'Generate Report',
              leading: Icon(OMIcons.receipt, color: Colors.redAccent),
              onTap: () => Get.toNamed('reports'),
            ),
            controllers.utils.listTile(
              title: 'Logout',
              leading: Icon(OMIcons.exitToApp, color: Colors.redAccent),
              onTap: () => controllers.utils.getSimpleDialougeForNoContent(
                title: 'Logout ?',
                yesPressed: () => {
                  Get.back(),
                  controllers.firebaseAuth.signOut(),
                },
                noPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      );
}
