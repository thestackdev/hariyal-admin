import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:superuser/admin/admin_home.dart';
import 'package:superuser/superuser/authenticate.dart';
import 'package:superuser/superuser/superuser_home.dart';
import 'package:superuser/utils.dart';

final Utils utils = Utils();
final Firestore _db = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

final appTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Ubuntu',
  primarySwatch: Colors.red,
  scaffoldBackgroundColor: Colors.red,
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
  }),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(
    Phoenix(
      child: AuthenticationChecker(),
    ),
  );
}

class AuthenticationChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (context, authsnap) {
        if (authsnap.connectionState == ConnectionState.active) {
          if (!authsnap.hasData) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: appTheme,
              home: Authenticate(),
            );
          } else {
            return DataStreamBuilder<DocumentSnapshot>(
              stream: _db
                  .collection('admin')
                  .document(authsnap.data.uid)
                  .snapshots(),
              errorBuilder: (context, error) => utils.nullWidget(error),
              loadingBuilder: (context) => Container(
                color: Colors.white,
                child: utils.progressIndicator(),
              ),
              builder: (context, snapshot) {
                return MultiProvider(
                  providers: [
                    Provider<DocumentSnapshot>.value(value: snapshot),
                    Provider<Utils>.value(value: utils),
                    StreamProvider<QuerySnapshot>.value(
                      initialData: null,
                      value: _db.collection('extras').snapshots(),
                    ),
                  ],
                  child: GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    navigatorKey: Get.key,
                    theme: appTheme,
                    home: homeWidget(
                      snapshot.data['isSuperuser'],
                      snapshot.data['isAdmin'],
                    ),
                  ),
                );
              },
            );
          }
        } else {
          return Container(
            color: Colors.white,
            child: utils.progressIndicator(),
          );
        }
      },
    );
  }

  homeWidget(bool isSuperuser, bool isAdmin) {
    if (isSuperuser) {
      return SuperuserHome();
    } else if (isAdmin) {
      return AdminHome();
    } else {
      _auth.signOut();
      return Authenticate();
    }
  }
}
