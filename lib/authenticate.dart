import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/utils.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final titleStyle = TextStyle(
    color: Colors.grey.shade700,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  final contentStyle = TextStyle(
    color: Colors.grey,
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  bool loading = false;
  Utils utils = Utils();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Hariyal'),
      body: utils.container(
        child: loading
            ? utils.progressIndicator()
            : ListView(
                children: <Widget>[
                  SizedBox(height: 90),
                  utils.textInputPadding(
                    child: Text('Login', style: titleStyle),
                  ),
                  utils.textInputPadding(
                      child: Text('Hey Admin !', style: contentStyle)),
                  utils.textInputPadding(
                    child: TextField(
                      style: utils.inputTextStyle(),
                      controller: emailController,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: utils.inputDecoration(
                        label: 'Email',
                        iconData: MdiIcons.emailOutline,
                      ),
                    ),
                  ),
                  utils.textInputPadding(
                    child: TextField(
                      style: utils.inputTextStyle(),
                      controller: passwordController,
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
                    title: 'Login',
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (emailController.text.length > 0 &&
                          passwordController.text.length > 0) {
                        login();
                      } else {
                        utils.showSnackbar('Invalid Credintials');
                      }
                    },
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
      utils.showSnackbar(utils.errorMessageHelper(e.code));
      return false;
    }
  }

  handleSetState() {
    if (mounted) {
      setState(() {});
    }
  }
}
