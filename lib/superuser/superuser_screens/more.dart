import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/all_products.dart';

class Settings extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controllers.utils.appbar('Console'),
      body: controllers.utils.container(
        child: ListView(
          children: <Widget>[
            controllers.utils.listTile(
              title: 'My Profile',
              leading: Icon(
                OMIcons.face,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/profile'),
            ),
            controllers.utils.listTile(
              title: 'Add Admin',
              leading: Icon(
                OMIcons.personAdd,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/add_admin'),
            ),
            controllers.utils.listTile(
              title: 'Add Product',
              leading: Icon(
                OMIcons.shoppingCart,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/add_product'),
            ),
            controllers.utils.listTile(
              title: 'User Interests',
              leading: Icon(
                OMIcons.shoppingBasket,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/interests'),
            ),
            controllers.utils.listTile(
              title: 'My Products',
              leading: Icon(OMIcons.shoppingBasket, color: Colors.red),
              onTap: () => Get.to(AllProducts(
                query: controllers.products
                    .orderBy('timestamp', descending: true)
                    .where('isDeleted', isEqualTo: false),
              )),
            ),
            controllers.utils.listTile(
              title: 'Customers',
              leading: Icon(OMIcons.childFriendly, color: Colors.red),
              onTap: () => Get.toNamed('/all_customers'),
            ),
            controllers.utils.listTile(
              title: 'Admins',
              leading: Icon(OMIcons.childFriendly, color: Colors.red),
              onTap: () => Get.toNamed('/admins'),
            ),
            controllers.utils.listTile(
              title: 'Categories',
              leading: Icon(
                OMIcons.category,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/categories'),
            ),
            controllers.utils.listTile(
              title: 'Locations',
              leading: Icon(
                OMIcons.place,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/states'),
            ),
            controllers.utils.listTile(
              title: 'Specifications',
              leading: Icon(
                OMIcons.newReleases,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/specifications'),
            ),
            controllers.utils.listTile(
              title: 'Showrooms',
              leading: Icon(
                OMIcons.locationCity,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.toNamed('/showrooms'),
            ),
            controllers.utils.listTile(
              title: 'Logout',
              leading: Icon(OMIcons.exitToApp, color: Colors.red),
              onTap: () => controllers.utils.getSimpleDialouge(
                title: 'Confirm',
                content: Text('Logout ?'),
                yesPressed: () => {
                  controllers.changeScreen(0),
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
