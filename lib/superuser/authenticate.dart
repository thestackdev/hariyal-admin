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
  final textstyle = TextStyle(color: Colors.grey.shade700, fontSize: 16);
  bool loading = false;
  Utils utils = Utils();
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: utils.getAppbar('Hariyal'),
      body: utils.getContainer(
        child: loading
            ? utils.getLoadingIndicator()
            : ListView(
                children: <Widget>[
                  SizedBox(height: 90),
                  utils.getTextInputPadding(
                    child: Text('Login', style: titleStyle),
                  ),
                  utils.getTextInputPadding(
                      child: Text('Hey Admin !', style: contentStyle)),
                  utils.getTextInputPadding(
                    child: TextField(
                      style: textstyle,
                      controller: emailController,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: utils.getDecoration(
                        label: 'Email',
                        iconData: MdiIcons.emailOutline,
                      ),
                    ),
                  ),
                  utils.getTextInputPadding(
                    child: TextField(
                      style: textstyle,
                      controller: passwordController,
                      maxLines: 1,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: utils.getDecoration(
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
                        utils.getSnackbar(key, 'Invalid Credintials');
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
      utils.getSnackbar(key, e.toString());
      return false;
    }
  }

  handleSetState() {
    if (mounted) {
      setState(() {});
    }
  }
}
