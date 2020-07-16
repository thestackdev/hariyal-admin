import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/utils.dart';

class AddAdmin extends StatefulWidget {
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  Utils utils = Utils();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.getAppbar('Add Admin'),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: utils.getBoxDecoration(),
        child: loading
            ? utils.getLoadingIndicator()
            : ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                    child: TextField(
                      controller: name,
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      decoration: utils.getDecoration(
                        label: 'Full name',
                        iconData: MdiIcons.accountOutline,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                    child: TextField(
                      controller: email,
                      maxLines: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: utils.getDecoration(
                        label: 'Email',
                        iconData: MdiIcons.emailOutline,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                    child: TextField(
                      controller: password,
                      maxLines: 1,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: utils.getDecoration(
                        label: 'Password',
                        iconData: MdiIcons.lockOutline,
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  utils.getRaisedButton(
                    title: 'Confirm',
                    onPressed: addAdmin,
                  )
                ],
              ),
      ),
    );
  }

  addAdmin() async {
    if (email.text.length > 0 &&
        password.text.length > 0 &&
        name.text.length > 0) {
      loading = true;
      handleState();
      try {
        final result = await _auth.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        await _db.collection('admin').document(result.user.uid).setData(
          {
            'since': DateTime.now().millisecondsSinceEpoch,
            'name': name.text,
            'isSuperuser': false,
            'isAdmin': true,
          },
        );
        handleState();
        utils.getToast('Admin Successfully Added!');
      } catch (e) {
        loading = false;
        utils.getToast(e.toString());
        handleState();
      }
    } else {
      utils.getToast('Invalid entries');
    }
  }

  handleState() {
    if (mounted) {
      setState(() {});
    }
  }
}
