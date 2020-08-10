import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/all_products.dart';

class AdminExtras extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Extras',
      child: ListView(
        children: <Widget>[
          controllers.utils.listTile(
            title: 'My Profile',
            leading: Icon(OMIcons.face, color: Colors.red.shade300),
            onTap: () => Get.toNamed('profile'),
          ),
          controllers.utils.listTile(
            leading: Icon(OMIcons.personAdd, color: Colors.red),
            title: 'Add Admin',
            onTap: () => Get.toNamed('add_admin'),
          ),
          controllers.utils.listTile(
            leading: Icon(OMIcons.shoppingCart, color: Colors.red),
            title: 'Add Product',
            onTap: () => Get.toNamed('add_product'),
          ),
          controllers.utils.listTile(
            leading: Icon(OMIcons.shoppingCart, color: Colors.red),
            title: 'My Products',
            onTap: () => Get.to(
              AllProducts(
                query: controllers.products
                    .orderBy('timestamp', descending: true)
                    .where(
                      'author',
                      isEqualTo: controllers.firebaseUser.value.uid,
                    ),
              ),
            ),
          ),
          controllers.utils.listTile(
            title: 'Logout',
            leading: Icon(OMIcons.exitToApp, color: Colors.redAccent),
            onTap: () => controllers.utils.getSimpleDialougeForNoContent(
              title: 'Logout ?',
              yesPressed: () => {
                controllers.changeScreen(0),
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
}
