import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/services/add_admin.dart';

import '../../utils.dart';
import 'extras/extra_identifier.dart';
import 'extras/shorooms.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.getAppbar('Settings'),
      body: utils.getContainer(
        child: ListView(
          children: <Widget>[
            utils.listTile(
              title: 'Add Admin',
              leading: Icon(
                MdiIcons.humanChild,
                color: Colors.red.shade300,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddAdmin(),
                ),
              ),
            ),
            utils.listTile(
              title: 'Categories',
              leading: Icon(
                MdiIcons.cartArrowRight,
                color: Colors.red.shade300,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExtraIdentifier(
                    identifier: 'category',
                  ),
                ),
              ),
            ),
            utils.listTile(
              title: 'States',
              leading: Icon(
                MdiIcons.locationExit,
                color: Colors.red.shade300,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExtraIdentifier(
                    identifier: 'states',
                  ),
                ),
              ),
            ),
            utils.listTile(
              title: 'Areas',
              leading: Icon(
                MdiIcons.locationExit,
                color: Colors.red.shade300,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExtraIdentifier(
                    identifier: 'areas',
                  ),
                ),
              ),
            ),
            utils.listTile(
              title: 'Showrooms',
              leading: Icon(
                MdiIcons.mapMarkerOutline,
                color: Colors.red.shade300,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Showrooms(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
