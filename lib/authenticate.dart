import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';

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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Hariyal',
      child: loading
          ? controllers.utils.loading()
          : ListView(
              children: <Widget>[
                SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Login',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .apply(fontSizeFactor: 1.8),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Text(
                    'Hey Admin !',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  child: TextField(
                    controller: emailController,
                    style: Theme.of(context).textTheme.headline2,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      suffixIcon: Icon(OMIcons.email, size: 21),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  child: TextField(
                    obscureText: isHidden,
                    controller: passwordController,
                    style: Theme.of(context).textTheme.headline2,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isHidden ? OMIcons.lock : OMIcons.lockOpen,
                          size: 21,
                        ),
                        onPressed: () {
                          isHidden = !isHidden;
                          handleSetState();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Text('forgot password ?',
                          style: Theme.of(context).textTheme.headline2),
                      onPressed: () => Get.toNamed('forgotPassword'),
                    ),
                    controllers.utils.raisedButton(
                        'Login',
                        () => {
                              FocusScope.of(context).unfocus(),
                              if (GetUtils.isEmail(
                                      emailController.text.trim()) &&
                                  passwordController.text.isNotEmpty)
                                {
                                  login(),
                                }
                              else
                                {
                                  controllers.utils
                                      .snackbar('Invalid Email or Password !')
                                }
                            }),
                  ],
                )
              ],
            ),
    );
  }

  login() async {
    loading = true;
    handleSetState();

    try {
      await controllers.firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      loading = false;
      handleSetState();
      controllers.utils.snackbar(
        controllers.utils.errorMessageHelper(e.code),
      );
      return false;
    }
  }

  handleSetState() => (mounted) ? setState(() => null) : null;
}
