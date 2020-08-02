import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

import 'forgot_password.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final controllers = Controllers.to;
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final newPassClone = TextEditingController();
  AuthCredential authCredential;
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
      appBar: controllers.utils.appbar('Change Password'),
      body: controllers.utils.container(
        child: loading
            ? controllers.utils.progressIndicator()
            : ListView(
                children: <Widget>[
                  SizedBox(height: 18),
                  controllers.utils.inputTextField(
                      label: 'Old Password', controller: oldPass),
                  controllers.utils.inputTextField(
                      label: 'New Password', controller: newPass),
                  controllers.utils.inputTextField(
                      label: 'Re-Enter Password', controller: newPassClone),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'forgot password ?',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => Get.to(ForgotPassword()),
                      ),
                      controllers.utils.getRaisedButton(
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
                                email: controllers.firebaseUser.value.email,
                                password: oldPass.text,
                              );
                              try {
                                final resutlt = await controllers
                                    .firebaseUser.value
                                    .reauthenticateWithCredential(
                                        authCredential);
                                resutlt.user.updatePassword(newPassClone.text);
                                controllers.utils.showSnackbar(
                                    'Password Changed sucessfully changed');
                                setState(() {
                                  loading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  loading = false;
                                });
                                controllers.utils
                                    .showSnackbar('Not a valid Password');
                              }
                            } else {
                              if (newPass.text != newPassClone.text) {
                                controllers.utils.showSnackbar(
                                    'New Passwords does\'t match');
                              } else {
                                controllers.utils
                                    .showSnackbar('Not a valid Password');
                              }
                            }
                          }),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
