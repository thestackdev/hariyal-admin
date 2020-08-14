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
        await controllers.admin.document(result.user.uid).setData({
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'name': name.text.toLowerCase(),
          'isSuperuser': false,
          'isAdmin': true,
          'imageUrl': null,
        });
        email.clear();
        password.clear();
        name.clear();
        loading = false;
        handleState();
        controllers.utils.snackbar('Admin Added !');
      } catch (error) {
        loading = false;
        handleState();
        controllers.utils.snackbar(
          controllers.utils.errorMessageHelper(error.code),
        );
      }
    }

    return controllers.utils.root(
      label: 'Add Admin',
      child: loading
          ? controllers.utils.loading()
          : Padding(
              padding: const EdgeInsets.all(18),
              child: Wrap(
                runSpacing: 18,
                spacing: 18,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Full name'),
                    controller: name,
                    style: Get.theme.textTheme.headline2,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: email,
                    style: Get.theme.textTheme.headline2,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: password,
                    style: Get.theme.textTheme.headline2,
                  ),
                  controllers.utils.raisedButton('Add Admin', () async {
                    FocusScope.of(context).unfocus();
                    (GetUtils.isEmail(email.text) &&
                            !password.text.length.isNullOrBlank &&
                            !name.text.length.isNullOrBlank)
                        ? register()
                        : controllers.utils.snackbar('Invalid entries');
                  })
                ],
              ),
            ),
    );
  }

  handleState() => (mounted) ? setState(() => null) : null;
}
