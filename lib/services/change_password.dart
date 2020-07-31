import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/utils.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final utils = Utils();
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final newPassClone = TextEditingController();
  AuthCredential authCredential;
  final firebaseUser = Controllers.to.firebaseUser.value;
  bool loading = false;

  @override
  void dispose() {
    oldPass.dispose();
    newPass.dispose();
    newPassClone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Change Password'),
      body: utils.container(
        child: loading
            ? utils.progressIndicator()
            : ListView(
                children: <Widget>[
                  SizedBox(height: 18),
                  utils.inputTextField(
                      label: 'Old Password', controller: oldPass),
                  utils.inputTextField(
                      label: 'New Password', controller: newPass),
                  utils.inputTextField(
                      label: 'Re-Enter Password', controller: newPassClone),
                  SizedBox(height: 18),
                  utils.getRaisedButton(
                      title: 'Change Password',
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (oldPass.text.length > 0 &&
                            newPass.text.length > 0 &&
                            newPassClone.text.length > 0 &&
                            newPass.text == newPassClone.text) {
                          setState(() {
                            loading = true;
                          });
                          authCredential = EmailAuthProvider.getCredential(
                            email: firebaseUser.email,
                            password: oldPass.text,
                          );
                          try {
                            final resutlt = await firebaseUser
                                .reauthenticateWithCredential(authCredential);
                            resutlt.user.updatePassword(newPassClone.text);
                            utils.showSnackbar(
                                'Password Changed sucessfully changed');
                            setState(() {
                              loading = false;
                            });
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                            utils.showSnackbar('Not a valid Password');
                          }
                        } else {
                          if (newPass.text != newPassClone.text) {
                            utils.showSnackbar('New Passwords does\'t match');
                          } else {
                            utils.showSnackbar('Not a valid Password');
                          }
                        }
                      }),
                ],
              ),
      ),
    );
  }
}
