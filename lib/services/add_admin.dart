import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class AddAdmin extends StatefulWidget {
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final controllers = Controllers.to;
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    register() async {
      loading = true;
      handleState();
      FirebaseApp app = await FirebaseApp.configure(
        name: 'the-hariyal',
        options: await FirebaseApp.instance.options,
      );
      try {
        final result =
            await FirebaseAuth.fromApp(app).createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        await controllers.admin.document(result.user.uid).setData(
          {
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'name': name.text.toLowerCase(),
            'isSuperuser': false,
            'isAdmin': true,
          },
        );
        email.clear();
        password.clear();
        name.clear();
        loading = false;
        handleState();
      } catch (error) {
        loading = false;
        handleState();
        controllers.utils.errorMessageHelper(error.code);
      }
      controllers.utils.showSnackbar('Admin Added Successfully !');
    }

    return Scaffold(
      appBar: controllers.utils.appbar('Add Admin'),
      body: controllers.utils.container(
        child: loading
            ? controllers.utils.progressIndicator()
            : ListView(
                children: <Widget>[
                  controllers.utils.inputTextField(
                    label: 'Full name',
                    controller: name,
                  ),
                  controllers.utils.inputTextField(
                    controller: email,
                    label: 'Email',
                  ),
                  controllers.utils.inputTextField(
                    controller: password,
                    label: 'Password',
                  ),
                  SizedBox(height: 18),
                  RaisedButton(
                    child: Text(
                      'Add Admin',
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (GetUtils.isEmail(email.text) &&
                          password.text.length > 0 &&
                          name.text.length > 0) {
                        register();
                      } else {
                        controllers.utils.showSnackbar('Invalid entries');
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }

  handleState() => (mounted) ? setState(() => null) : null;
}
