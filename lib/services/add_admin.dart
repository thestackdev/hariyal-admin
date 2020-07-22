import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/utils.dart';

class AddAdmin extends StatefulWidget {
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  Utils utils = Utils();
  bool loading = false;
  bool checkBoxValue = false;
  final Firestore _db = Firestore.instance;
  String helperMessage;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: utils.appbar('Add Admin'),
      body: utils.container(
        child: loading
            ? utils.progressIndicator()
            : ListView(
                children: <Widget>[
                  utils.textInputPadding(
                    child: TextField(
                      controller: name,
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      decoration: utils.inputDecoration(
                        label: 'Full name',
                        iconData: MdiIcons.accountOutline,
                      ),
                    ),
                  ),
            utils.textInputPadding(
              child: TextField(
                controller: email,
                maxLines: null,
                keyboardType: TextInputType.emailAddress,
                decoration: utils.inputDecoration(
                  label: 'Email',
                  iconData: MdiIcons.emailOutline,
                ),
              ),
            ),
            utils.textInputPadding(
              child: TextField(
                controller: password,
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                decoration: utils.inputDecoration(
                  label: 'Password',
                  iconData: MdiIcons.lockOutline,
                ),
              ),
            ),
            SizedBox(height: 18),
            utils.getRaisedButton(
              title: 'Add Admin',
              onPressed: checkBoxValue
                  ? () async {
                FocusScope.of(context).unfocus();
                if (email.text.length > 0 &&
                    password.text.length > 0 &&
                    name.text.length > 0) {
                  register();
                } else {
                  utils.snackBar(scaffoldKey, 'Invalid entries');
                }
              }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  register() async {
    loading = true;
    handleState();
    FirebaseApp app = await FirebaseApp.configure(
      name: 'the-hariyal',
      options: await FirebaseApp.instance.options,
    );
    try {
      final result =
      await FirebaseAuth.fromApp(app).createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await _db.collection('admin').document(result.user.uid).setData(
        {
          'since': DateTime
              .now()
              .millisecondsSinceEpoch,
          'name': name.text.toLowerCase(),
          'isSuperuser': false,
          'isAdmin': true,
        },
      );
      email.clear();
      password.clear();
      name.clear();
      helperMessage = "Admin Added Successfully !";
      loading = false;
      handleState();
    } catch (error) {
      loading = false;
      handleState();
      helperMessage = utils.errorMessageHelper(error.code);
    }
    utils.snackBar(scaffoldKey, helperMessage);
  }

  handleState() {
    if (mounted) {
      setState(() {});
    }
  }
}
