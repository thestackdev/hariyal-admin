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
  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
        color: Colors.grey.shade700, fontSize: 30, fontWeight: FontWeight.bold);
    final contentStyle = TextStyle(
        color: Colors.grey, fontSize: 18, fontWeight: FontWeight.normal);
    return SafeArea(
      child: Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 70),
                    child: Center(child: Text('//TODO Logo')),
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
                      'Hi Admin !',
                      style: contentStyle,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                    child: TextField(
                      controller: emailController,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: Utils().getDecoration(
                        label: 'email',
                        iconData: MdiIcons.emailOutline,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
                    child: TextField(
                      controller: passwordController,
                      maxLines: 1,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: Utils().getDecoration(
                        label: 'password',
                        iconData: MdiIcons.lockOutline,
                      ),
                    ),
                  ),
                  Center(
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      elevation: 0,
                      onPressed: () {
                        login();
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
    setState(() {
      loading = true;
    });

    final result = await AuthServices()
        .superuserLogin(emailController.text, passwordController.text);
    if (result == false) {
      setState(() {
        loading = false;
      });
    }
  }
}
