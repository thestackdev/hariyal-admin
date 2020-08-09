import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final controllers = Controllers.to;
  final email = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Forgot Password',
      child: loading
          ? controllers.utils.loading()
          : ListView(
              children: <Widget>[
                SizedBox(height: 30),
                controllers.utils.inputTextField(
                  label: 'Email',
                  controller: email,
                ),
                SizedBox(height: 18),
                controllers.utils.raisedButton(
                  'Request Password Reset',
                  () async {
                    if (GetUtils.isEmail(email.text)) {
                      setState(() {
                        loading = true;
                      });
                      controllers.customers
                          .where('email', isEqualTo: email.text)
                          .getDocuments()
                          .then((value) {
                        if (value.documents.length > 0) {
                          controllers.firebaseAuth
                              .sendPasswordResetEmail(email: email.text);
                          setState(() {
                            loading = false;
                          });
                          controllers.utils.snackbar(
                            'Password reset link has sent to ${email.text}',
                          );
                        } else {
                          setState(() {
                            loading = false;
                          });
                          controllers.utils.snackbar(
                            'No customer found with this email',
                          );
                        }
                      });
                    } else {
                      controllers.utils.snackbar('Email not valid');
                    }
                  },
                )
              ],
            ),
    );
  }
}
