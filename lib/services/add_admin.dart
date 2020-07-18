import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/services/auth_services.dart';
import 'package:superuser/utils.dart';

class AddAdmin extends StatefulWidget {
  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  Utils utils = Utils();
  bool loading = false;
  bool checkBoxValue = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: utils.getAppbar('Add Admin'),
      body: utils.getContainer(
        child: loading
            ? utils.getLoadingIndicator()
            : ListView(
                children: <Widget>[
                  utils.getTextInputPadding(
                    child: TextField(
                      controller: name,
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      decoration: utils.getDecoration(
                        label: 'Full name',
                        iconData: MdiIcons.accountOutline,
                      ),
                    ),
                  ),
                  utils.getTextInputPadding(
                    child: TextField(
                      controller: email,
                      maxLines: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: utils.getDecoration(
                        label: 'Email',
                        iconData: MdiIcons.emailOutline,
                      ),
                    ),
                  ),
                  utils.getTextInputPadding(
                    child: TextField(
                      controller: password,
                      maxLines: 1,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: utils.getDecoration(
                        label: 'Password',
                        iconData: MdiIcons.lockOutline,
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Container(
                    margin: EdgeInsets.all(9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          onChanged: (value) {
                            checkBoxValue = value;
                            handleState();
                          },
                          value: checkBoxValue,
                        ),
                        Flexible(
                          child: Text(
                            'As of now when you try to create a new Admin you\'ll get logged out on successfull creation of Admin.',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  utils.getRaisedButton(
                    title: 'Add Admin',
                    onPressed: checkBoxValue
                        ? () async {
                            FocusScope.of(context).unfocus();
                            if (email.text.length > 0 &&
                                password.text.length > 0 &&
                                name.text.length > 0) {
                              loading = true;
                              handleState();
                              final result = await AuthServices().addAdmin(
                                  email.text.trim(),
                                  password.text.trim(),
                                  name.text.toLowerCase().trim(),
                                  context);

                              if (result == true) {
                                loading = false;
                                handleState();
                              } else {
                                loading = false;
                                handleState();
                                utils.getSnackbar(scaffoldKey, result);
                              }
                            } else {
                              utils.getSnackbar(scaffoldKey, 'Invalid entries');
                            }
                          }
                        : null,
                  ),
                ],
              ),
      ),
    );
  }

  handleState() {
    if (mounted) {
      setState(() {});
    }
  }
}
