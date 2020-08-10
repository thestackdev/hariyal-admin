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
  Widget build(BuildContext context) => controllers.utils.root(
        label: 'Change Password',
        child: loading
            ? controllers.utils.loading()
            : Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: <Widget>[
                    controllers.utils.inputTextField(
                        label: 'Old Password', controller: oldPass),
                    controllers.utils.inputTextField(
                        label: 'New Password', controller: newPass),
                    controllers.utils.inputTextField(
                        label: 'Re-Enter Password', controller: newPassClone),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          child: Text('forgot password ?'),
                          onPressed: () => Get.to(ForgotPassword()),
                        ),
                        controllers.utils.raisedButton('Change Password',
                            () async {
                          FocusScope.of(context).unfocus();
                          if (!oldPass.text.length.isNullOrBlank &&
                              !newPass.text.length.isNullOrBlank &&
                              !newPassClone.text.length.isNullOrBlank &&
                              newPass.text == newPassClone.text) {
                            loading = true;
                            handleState();
                            authCredential = EmailAuthProvider.getCredential(
                              email: controllers.firebaseUser.value.email,
                              password: oldPass.text,
                            );
                            try {
                              final resutlt = await controllers
                                  .firebaseUser.value
                                  .reauthenticateWithCredential(authCredential);
                              resutlt.user.updatePassword(newPassClone.text);
                              oldPass.clear();
                              newPass.clear();
                              newPassClone.clear();
                              loading = false;
                              handleState();
                              controllers.utils.snackbar(
                                  'Password Changed sucessfully changed');
                            } catch (e) {
                              loading = false;
                              handleState();
                              controllers.utils.snackbar('Wrong Password !');
                            }
                          } else {
                            if (newPass.text != newPassClone.text) {
                              controllers.utils
                                  .snackbar('New Passwords does\'t match');
                            } else {
                              controllers.utils
                                  .snackbar('Not a valid Password');
                            }
                          }
                        })
                      ],
                    ),
                  ],
                ),
              ),
      );

  handleState() => mounted ? setState(() => null) : null;
}
