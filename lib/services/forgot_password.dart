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
    return Scaffold(
      appBar: controllers.utils.appbar('Forgot Password'),
      body: controllers.utils.container(
        child: loading
            ? controllers.utils.progressIndicator()
            : ListView(
                children: <Widget>[
                  SizedBox(height: 30),
                  controllers.utils
                      .inputTextField(label: 'Email', controller: email),
                  SizedBox(height: 18),
                  controllers.utils.getRaisedButton(
                      title: 'Request Password Reset',
                      onPressed: () async {
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
                              controllers.utils.showSnackbar(
                                'Password reset link has sent to ${email.text}',
                              );
                            } else {
                              setState(() {
                                loading = false;
                              });
                              controllers.utils.showSnackbar(
                                'No customer found with this email',
                              );
                            }
                          });
                        } else {
                          controllers.utils.showSnackbar('Email not valid');
                        }
                      }),
                ],
              ),
      ),
    );
  }
}
