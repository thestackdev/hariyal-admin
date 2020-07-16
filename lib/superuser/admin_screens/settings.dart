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
  final textstyle = TextStyle(color: Colors.grey.shade700);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        elevation: 0,
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Container(
        decoration: Utils().getBoxDecoration(),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.grey.shade100,
              ),
              child: ListTile(
                leading: Icon(
                  MdiIcons.humanChild,
                  color: Colors.red.shade300,
                ),
                trailing: Icon(
                  MdiIcons.chevronRight,
                  color: Colors.red.shade300,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddAdmin(),
                  ),
                ),
                title: Text('Add Admin', style: textstyle),
              ),
            ),
            Container(
              margin: EdgeInsets.all(9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.grey.shade100,
              ),
              child: ListTile(
                leading: Icon(
                  MdiIcons.notificationClearAll,
                  color: Colors.red.shade300,
                ),
                trailing: Icon(
                  MdiIcons.chevronRight,
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
                title: Text('Categories', style: textstyle),
              ),
            ),
            Container(
              margin: EdgeInsets.all(9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.grey.shade100,
              ),
              child: ListTile(
                leading: Icon(
                  MdiIcons.mapMarker,
                  color: Colors.red.shade300,
                ),
                trailing: Icon(
                  MdiIcons.chevronRight,
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
                title: Text('States', style: textstyle),
              ),
            ),
            Container(
              margin: EdgeInsets.all(9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.grey.shade100,
              ),
              child: ListTile(
                leading: Icon(
                  MdiIcons.mapMarker,
                  color: Colors.red.shade300,
                ),
                trailing: Icon(
                  MdiIcons.chevronRight,
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
                title: Text('Areas', style: textstyle),
              ),
            ),
            Container(
              margin: EdgeInsets.all(9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.grey.shade100,
              ),
              child: ListTile(
                leading: Icon(
                  MdiIcons.shoppingOutline,
                  color: Colors.red.shade300,
                ),
                trailing: Icon(
                  MdiIcons.chevronRight,
                  color: Colors.red.shade300,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Showrooms(),
                  ),
                ),
                title: Text('Showrooms', style: textstyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
