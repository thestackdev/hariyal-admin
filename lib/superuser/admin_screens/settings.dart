import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:superuser/services/add_admin.dart';
import 'package:superuser/superuser/categories.dart';

import '../../utils.dart';
import '../shorooms.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return Scaffold(
      appBar: utils.appbar('Settings'),
      body: utils.container(
        child: ListView(
          children: <Widget>[
            utils.listTile(
              title: 'Add Admin',
              leading: Icon(
                MdiIcons.humanChild,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(AddAdmin()),
            ),
            utils.listTile(
              title: 'Categories',
              leading: Icon(
                MdiIcons.cartArrowRight,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(
                CategoriesScreen(type: 'category'),
              ),
            ),
            utils.listTile(
              title: 'Locations',
              leading: Icon(
                MdiIcons.locationExit,
                color: Colors.red.shade300,
              ),
              onTap: () =>
                  Get.to(
                    CategoriesScreen(type: 'locations'),
                  ),
            ),
            utils.listTile(
              title: 'Showrooms',
              leading: Icon(
                MdiIcons.mapMarkerOutline,
                color: Colors.red.shade300,
              ),
              onTap: () => Get.to(Showrooms()),
            ),
          ],
        ),
      ),
    );
  }
}
