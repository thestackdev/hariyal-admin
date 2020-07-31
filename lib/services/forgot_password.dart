import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/utils.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final email = TextEditingController();
  final customers = Firestore.instance.collection('customers');
  final auth = FirebaseAuth.instance;
  final utils = Utils();
  bool loading = false;

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Forgot Password'),
      body: utils.container(
        child: loading
            ? utils.progressIndicator()
            : ListView(
                children: <Widget>[
                  SizedBox(height: 30),
                  utils.inputTextField(label: 'Email', controller: email),
                  SizedBox(height: 18),
                  utils.getRaisedButton(
                      title: 'Request Password Reset',
                      onPressed: () async {
                        if (GetUtils.isEmail(email.text)) {
                          setState(() {
                            loading = true;
                          });
                          customers
                              .where('email', isEqualTo: email.text)
                              .getDocuments()
                              .then((value) {
                            if (value.documents.length > 0) {
                              auth.sendPasswordResetEmail(email: email.text);
                              setState(() {
                                loading = false;
                              });
                              utils.showSnackbar(
                                'Password reset link has sent to ${email.text}',
                              );
                            } else {
                              setState(() {
                                loading = false;
                              });
                              utils.showSnackbar(
                                'No customer found with this email',
                              );
                            }
                          });
                        } else {
                          utils.showSnackbar('Email not valid');
                        }
                      }),
                ],
              ),
      ),
    );
  }
}
