import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';

class AdminExtras extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controllers.utils.appbar('Extras'),
      body: controllers.utils.container(
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
              title: 'My Products',
              onTap: () => Get.toNamed(
                'all_products',
                arguments: controllers.products.where(
                  'author',
                  isEqualTo: controllers.firebaseUser.value.uid,
                ),
              ),
            ),
            controllers.utils.listTile(
              title: 'Logout',
              leading: Icon(OMIcons.cloudOff, color: Colors.red),
              onTap: () async {
                showDialog(
                  context: context,
                  child: controllers.utils.alertDialog(
                    content: 'Signout ?',
                    yesPressed: () {
                      Get.back();
                      FirebaseAuth.instance.signOut();
                    },
                    noPressed: () {
                      Get.back();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
