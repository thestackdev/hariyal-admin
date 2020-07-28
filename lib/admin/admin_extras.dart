import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/authenticate.dart';
import 'package:superuser/services/add_admin.dart';
import 'package:superuser/services/profile.dart';
import 'package:superuser/utils.dart';
import 'package:provider/provider.dart';

class AdminExtras extends StatelessWidget {
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();

    return utils.container(
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
            leading: Icon(MdiIcons.humanChild, color: Colors.red),
            title: 'Add Admin',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddAdmin(),
              ),
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
                    Get.offAll(Authenticate());
                  },
                  noPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
