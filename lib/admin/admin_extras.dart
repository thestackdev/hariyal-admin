import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/utils.dart';

class AdminExtras extends StatelessWidget {
  final products = Firestore.instance.collection('products');
  final controllers = Controllers.to;
  final Utils utils = Utils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Extras'),
      body: utils.container(
        child: ListView(
          children: <Widget>[
            utils.listTile(
              title: 'My Profile',
              leading: Icon(MdiIcons.faceProfile, color: Colors.red.shade300),
              onTap: () => Get.toNamed('profile'),
            ),
            utils.listTile(
              leading: Icon(MdiIcons.humanChild, color: Colors.red),
              title: 'Add Admin',
              onTap: () => Get.toNamed('add_admin'),
            ),
            utils.listTile(
              leading: Icon(MdiIcons.humanChild, color: Colors.red),
              title: 'My Products',
              onTap: () => Get.toNamed(
                'all_products',
                arguments: products.where('author',
                    isEqualTo: controllers.firebaseUser.value.uid),
              ),
            ),
            utils.listTile(
              title: 'Logout',
              leading: Icon(MdiIcons.logout, color: Colors.red),
              onTap: () async {
                showDialog(
                  context: context,
                  child: utils.alertDialog(
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
