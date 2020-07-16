import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/services/auth_services.dart';
import 'package:superuser/utils.dart';

class AdminAuthenticate extends StatefulWidget {
  @override
  _AdminAuthenticateState createState() => _AdminAuthenticateState();
}

class _AdminAuthenticateState extends State<AdminAuthenticate> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: utils.getAppbar('Hariyal'),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: utils.getBoxDecoration(),
        child: loading
            ? utils.getLoadingIndicator()
            : ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 70),
                    child: Center(
                        //  child: Image.asset('assets/hariyal_logo.jpg'),
                        ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 9, horizontal: 27),
                    child: Text(
                      'Login',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 9, horizontal: 27),
                    child: Text(
                      'Hey Admin !',
                      style: contentStyle,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                    child: TextField(
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      controller: emailController,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: utils.getDecoration(
                        label: 'Email',
                        iconData: MdiIcons.emailOutline,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                    child: TextField(
                      style: TextStyle(color: Colors.grey, fontSize: 16),
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
            Center(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                elevation: 0,
                onPressed: () {
                  if (emailController.text.length > 0 &&
                      passwordController.text.length > 0) {
                    login();
                  } else {
                    utils.getToast('Invalid Credintials');
                  }
                },
                shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      color: Colors.red.shade300,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  login() async {
    handleSetState();

    final result = await AuthServices()
        .superuserLogin(emailController.text, passwordController.text);
    if (result == false) {
      handleSetState();
    }
  }

  handleSetState() {
    if (mounted) {
      setState(() {
        loading = !loading;
      });
    }
  }
}
