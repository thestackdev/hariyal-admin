import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';

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
            title: 'Products',
            onTap: () => Get.toNamed('allProducts'),
          ),
          controllers.utils.listTile(
            leading: Icon(OMIcons.shoppingCart, color: Colors.red),
            title: 'Generate Report',
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
}
