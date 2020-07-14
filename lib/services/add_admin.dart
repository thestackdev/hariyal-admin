import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/utils.dart';

class AddAdmin extends StatefulWidget {
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  String email, password, name;
  Utils utils = Utils();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Admin'),
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                  child: TextField(
                    onChanged: (value) {
                      name = value;
                    },
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    decoration: utils.getDecoration(
                      label: 'Full name',
                      iconData: MdiIcons.accountOutline,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                  child: TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    decoration: utils.getDecoration(
                      label: 'Email',
                      iconData: MdiIcons.emailOutline,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                  child: TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: utils.getDecoration(
                      label: 'Password',
                      iconData: MdiIcons.lockOutline,
                    ),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    elevation: 0,
                    color: Colors.red.shade300,
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      addAdmin(email, password, name);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  addAdmin(email, password, name) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    Firestore _db = Firestore.instance;
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection('admin').document(result.user.uid).setData(
        {
          'since': DateTime.now().millisecondsSinceEpoch,
          'name': name,
          'isSuperuser': false,
          'isAdmin': true,
        },
      );
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Admin Successfully Added!');
    } catch (e) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }
}
