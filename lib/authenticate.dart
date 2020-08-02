import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/forgot_password.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final controllers = Controllers.to;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  bool isHidden = true;

  final contentStyle = TextStyle(
    color: Colors.grey,
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controllers.utils.appbar('Hariyal'),
      body: controllers.utils.container(
        child: loading
            ? controllers.utils.progressIndicator()
            : ListView(
                children: <Widget>[
                  SizedBox(height: 90),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Text('Hey Admin !', style: contentStyle),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    child: TextField(
                      controller: emailController,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                      decoration: controllers.utils.authDecoration(
                          label: 'Email',
                          icon: Icon(OMIcons.email, color: Colors.red),
                          onPressed: () {}),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    child: TextField(
                      obscureText: isHidden,
                      controller: passwordController,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                      decoration: controllers.utils.authDecoration(
                          label: 'Password',
                          icon: Icon(
                            isHidden ? OMIcons.lock : OMIcons.lockOpen,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            isHidden = !isHidden;
                            handleSetState();
                          }),
                    ),
                  ),
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
                        title: 'Login',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (GetUtils.isEmail(emailController.text) &&
                              passwordController.text.isNotEmpty) {
                            login();
                          } else {
                            controllers.utils
                                .showSnackbar('Invalid Credintials');
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  login() async {
    loading = true;
    handleSetState();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } catch (e) {
      loading = false;
      handleSetState();
      controllers.utils.showSnackbar(
        controllers.utils.errorMessageHelper(e.code),
      );
      return false;
    }
  }

  handleSetState() => (mounted) ? setState(() {}) : null;
}
